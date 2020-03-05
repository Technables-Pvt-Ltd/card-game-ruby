require "db_controller"
require "open_struct"

class V1::ApideckController < ApplicationController
  include DbController

  ####################################################
  ############## API HELPER METHODS ##################
  ####################################################

  def index
    message = MSG_API_WELCOME
    success = true
    data = {
      :deck => MSG_API_VERSION,
    }

    response_data = ApiResponse.new(message, success, data)
    render json: response_data, status: STATUS_OK
  end

  def createGame?(code, userid, deckid)
    game = CardGame.create(code: code, userid: userid, status: GAME_STATUS_INIT)

    masterdeck = DeckDatum.all

    masterdeck.each do |deck|
      gameid = game.id
      isselected = false
      user = ""
      if (deck.id == deckid.to_i)
        isselected = true
        user = userid
      end

      GameDeck.create(gameid: gameid, deckid: deck.id, userid: user, isselected: isselected)
    end

    return getGameDeck?(game.id)
  end

  def addPlayertoGame?(code, deckid, userid)
    proceed = false
    error = ""
    games = CardGame.where("code = ?", code)
    game = games.first()
    if (games.length == 0)
      proceed = false
      error = "game with the provided code does not exists"
    elsif game.status != GAME_STATUS_INIT
      proceed = false
      error = "game does not accept player anymore"
    else
      proceed = true
      error = ""

      statement = "select 1 where exists(select 1 from game_decks gd
      inner join card_games cg on gd.gameid = cg.id
       where gd.userid = '#{userid}' and deckid <> #{deckid}
       and isselected = 1 
       and cg.code = '#{code}')"

      decks = GameDeck.connection.select_all(statement)
      exists = decks.any?

      if (exists == true)
        proceed = false
        error = "user already exists in this game"
      else
        check_deck_available = "select 1 where exists(select 1 from game_decks gd
          where gd.deckid = #{deckid}  and gd.gameid = #{game.id} and isselected=true and userid <> '#{userid}')"
        taken_cards = GameDeck.connection.select_all(check_deck_available)
        is_taken = taken_cards.any?

        if (is_taken)
          proceed = false
          error = "this deck is already selected"
        else
          update_deck_card = "update game_decks
                    set isselected = 1, userid = '#{userid}'
                    where deckid = #{deckid} and gameid = #{game.id}"
          GameDeck.find_by_sql (update_deck_card)
        end
      end
    end
    if proceed
      data = {
        :proceed => proceed, :error => error, :decklist => getGameDeckByCode?(code),
      }
      return data
    else
      data = {
        :proceed => proceed, :error => error, :decklist => [],
      }
      return data
    end
  end

  def removePlayerFromGame?(code, userid, deckid)
    proceed = false
    error = ""
    games = CardGame.where("code = ?", code)

    if (games.length == 0)
      proceed = false
      error = "game with the provided code does not exists"
    else
      game = games.first()
      proceed = true
      error = ""

      check_deck_available = ("select 1 where exists(select 1 from game_decks gd
        where gd.deckid =#{deckid}  and gd.gameid = #{game.id} and isselected = 1 and userid = '#{userid}')")
      taken_cards = GameDeck.connection.select_all(check_deck_available)
      is_taken = taken_cards.any?

      if (is_taken)
        update_deck_card = ("update game_decks
          set isselected = 0, userid = ''
          where deckid = #{deckid} and gameid = #{game.id}")
        GameDeck.find_by_sql(update_deck_card)
      else
        proceed = false
        error = "sorry!! could not complete the operation "
      end
    end
    if proceed
      data = {
        :proceed => proceed, :error => error, :decklist => [],
      }
      return data
    else
      data = {
        :proceed => proceed, :error => error, :decklist => getGameDeck?(game.id),
      }
      return data
    end
  end

  def closeGame?(code, userid)
    proceed = false
    error = ""
    games = CardGame.where("code = ?", code)
    data = nil
    if (games.length == 0)
      proceed = false
      error = "game with the provided code does not exists"
    else
      game = games.first()
      if game.userid == userid
        proceed = true
        error = ""

        delete_game_decks = ("delete from game_decks where gameid = #{game.id}")
        GameDeck.find_by_sql(delete_game_decks)
        #delete_game_decks.execute :gameid => game.id

        delete_card_game = ("delete from card_games where id = #{game.id}")
        CardGame.find_by_sql(delete_card_game)
        #delete_card_game.execute :gameid => game.id
      else
        proceed = fase
        error = "close request initiated by non-admin user"
      end
    end
    if proceed
      data = {
        :proceed => proceed, :error => error,
      }
      #return data
    else
      data = {
        :proceed => proceed, :error => error,
      }
    end
    return data
  end

  def start_game?(gamecode, userid)
    proceed = false
    error = ""
    games = CardGame.find_by_sql("select id, code, userid from card_games where code = '#{gamecode}' and status = 1")
    data = nil
    if (games.length == 0)
      proceed = false
      error = "game with the provided code does not exists"
    else
      game = games.first()
      if game.userid == userid
        proceed = true
        error = ""

        CardGame.transaction do
          update_game = CardGame.lock("FOR UPDATE NOWAIT").find_by(code: gamecode)
          update_game.status = 2
          update_game.save!
        end

        game_decks = GameDeck.select("gameid, deckid, userid").where(:gameid => game.id, :isselected => true)

        total_players = game_decks.length

        player_position_master = [0, 1, 2, 3]
        player_turn_master = [false, false, false, false]

        player_position = player_position_master[0...total_players].shuffle
        player_turn = player_turn_master[0...total_players].shuffle

        game_decks.each_with_index do |deck, index|
          gameid = game.id
          p_userid = deck.userid
          deckid = deck.deckid
          position = player_position[index]
          health = PLAYER_HEALTH
          status = 1
          hasturn = player_turn[index]
          playcount = 0
          withdraw_count = 5
          # if (hasturn == true)
          #   playcount = 1
          #   withdraw_count = 6
          # end

          game_player = GamePlayer.create(gameid: gameid, deckid: deckid, userid: p_userid, position: position, health: health, status: status, hasturn: hasturn, playcount: playcount)

          ### insert into player_card ###

          deck_cards = DeckCard.find_by_sql("select id from deck_cards where deckid = #{deckid}")
          #deck_card = deck_cards.first()

          deck_cards.shuffle.each_with_index do |deck_card, index|
            playerid = game_player.id
            cardid = deck_card.id
            o_deckid = deckid
            cur_deckid = deckid
            pile_type = index < withdraw_count ? 2 : 1 ## 1-> deck, 2->hand, 3->active, 4->discard, 5-> temp
            card_health = 0

            PlayerCard.create(playerid: playerid, cardid: cardid, o_deckid: o_deckid, cur_deckid: cur_deckid, pile_type: pile_type, card_health: card_health)
          end
        end
      else
        proceed = fase
        error = "game start request initiated by non-admin user"
      end

      select_random_player?(game.id)
    end
    if proceed
      data = {
        :proceed => proceed, :error => error,
      }
      #return data
    else
      data = {
        :proceed => proceed, :error => error,
      }
    end
    return data
  end

  def select_random_player?(gameid)
    random_player = GamePlayer.where(:gameid => gameid).order("RANDOM()").first()
    random_player.hasturn = 1
    random_player.playcount = 1
    random_player.save!

    top_draw_card = PlayerCard.where(:playerid => random_player.id, :pile_type => 1).first()
    top_draw_card.pile_type = 2
    top_draw_card.save!
  end

  def getGameDeck?(gameid)
    statememt = "select dt.id, dt.name, gd.isselected , gd.userid
      from game_decks gd 
      Inner Join deck_data dt 
        on dt.id = gd.deckid  where gd.gameid = #{gameid}"
    decks = GameDeck.connection.select_all(statememt)
    return decks
  end

  def getGameDeckByCode?(gamecode)
    statement = ("select dt.id as id, dt.name, gd.isselected , gd.userid, dt.deckclass
    from game_decks gd 
    Inner Join deck_data dt 
      on dt.id = gd.deckid 
    inner join card_games cg 
      on cg.id = gd.gameid
    where cg.code = '#{gamecode}'")

    decks = GameDeck.connection.select_all(statement)
    return decks
  end

  def get_GameData?(gamecode, firstload, count)
    proceed = false
    error = ""
    games = CardGame.find_by_sql("select id, code, status from card_games where code = '#{gamecode}' and status = 2")
    data = nil
    temp_pile = []
    if (games.length == 0)
      proceed = false
      error = "game with the provided code does not exists " + gamecode
    else
      game = games.first()
      proceed = true
      error = ""
      hastempFile = false
      players = []
      complete = false
      active_players_count = GamePlayer.where(:gameid => game.id, :status => 1).count(:id)

      if active_players_count > 1
        gameplayers = GamePlayer.connection.select_all("select gp.userid,gp.id as id,dt.name, dt.deckclass, 
        gp.position, gp.hasturn, gp.health, gp.status, gp.playcount
        from game_players gp
        inner join deck_data dt on gp.deckid = dt.id
        where gp.gameid = #{game.id} order by gp.position")

        gameplayers.each do |playerObj|
          player = OpenStruct.new(playerObj)

          deck_pile_count = 0
          discard_pile_count = 0

          deck_pile_count = PlayerCard.where(:playerid => player.id, :pile_type => 1).count
          discard_pile_count = PlayerCard.where(:playerid => player.id, :pile_type => 4).count

          deck_pile = PlayerCard.connection.select_all("select pc.id,cardid, dc.name, pc.card_health,
          pc.o_deckid, pc.cur_deckid, pc.pile_type from player_cards pc
          inner join deck_cards dc on pc.cardid = dc.id
          where playerid = #{player.id} order by pc.updated_at")

          #temp_pile = []
          hand_pile_cards = []
          active_pile_cards = []
          deck_pile.each do |cardObj|
            card = OpenStruct.new(cardObj)
            card_effects = CardEffectsMap.connection.select_all("select cem.id, ce.name, ce.effectclass,
            cem.count from card_effects_maps cem
            inner join card_effects ce on cem.effectid = ce.id
            where cem.cardid = #{card.cardid}")

            if card.pile_type == 2
              hand_pile_cards << { cardid: card.cardid, name: card.name, card_health: card.card_health, o_deckid: card.o_deckid, cur_deckid: card.cur_deckid, effects: card_effects }
            elsif card.pile_type == 3
              active_pile_cards << { cardid: card.cardid, name: card.name, card_health: card.card_health, o_deckid: card.o_deckid, cur_deckid: card.cur_deckid, effects: card_effects, deckclass: player.deckclass }
            elsif card.pile_type == 5
              if (firstload.to_s == "true")
                hastempFile = true
                move_card_to_deck?(card.id)
              else
                temp_pile << { cardid: card.cardid, name: card.name, card_health: card.card_health, o_deckid: card.o_deckid, cur_deckid: card.cur_deckid, effects: card_effects, deckclass: player.deckclass }
              end
            end
          end
          if (hastempFile.to_s == "true" && firstload.to_s == "true")
            update_player_playcount?(player.id)
          end

          if (hand_pile_cards.length == 0 && player.status == 1)
            hand_pile_cards = draw_card_from_pile?(player.id, 2)
            #get_GameData?(gamecode, firstload)

          end

          players << {
            userid: player.userid,
            playerid: player.id,
            name: player.name,
            deckclass: player.deckclass,
            position: player.position,
            hasturn: player.hasturn,
            health: player.health,
            status: player.status,
            playcount: player.playcount,
            deck_pile_count: deck_pile_count,
            hand_pile: hand_pile_cards,
            active_pile: active_pile_cards,
            discard_pile_count: discard_pile_count,
          #hastempFile: hastempFile,
          #temp_pile: temp_pile,
          }
        end
      else
        complete = true
        winner_data = GamePlayer.connection.select_all("select gp.userid,gp.id as id,dt.name, dt.deckclass
          from game_players gp
          inner join deck_data dt on gp.deckid = dt.id
          where gp.gameid = #{game.id} and gp.status = 1 order by gp.position")
        winner = nil?
        winner_data.each do |winner_hash|
          winner_obj = OpenStruct.new(winner_hash)
          winner = { name: winner_obj.name, deckclass: winner_obj.deckclass }
        end
        data = { winner: winner }
      end
    end
    if proceed
      result = {
        :proceed => proceed, :error => error, players: players, complete: complete, temp_pile: temp_pile, data: data,
      }
      #return data
    else
      result = {
        :proceed => proceed, :error => error, players: [], temp_pile: [],
      }
    end
    return result
  end

  def draw_card_from_pile?(playerid, count)
    deck_cards = PlayerCard.where(:pile_type => 1, :playerid => playerid).limit(count) # limit #{count}")
    if deck_cards.any?
      deck_count = deck_cards.length
      if dec_count = count
        deck_cards.each do |deck_card|
          #card = OpenStruct.new(deck_card)
          deck_card.pile_type = 2
          deck_card.save!
        end
      else
        deck_cards.each do |deck_card|
          #deck_card = OpenStruct.new(deck_card)
          deck_card.pile_type = 2
          deck_card.save!
        end

        #shuffle discard and select (count-deck_count) cards
        remaining_card_count = count - deck_count

        shuffle_cards = PlayerCard.find_by_sql("
          select id, playerid, cardid, o_deckid, cur_deckid from player_cards 
          where playerid = #{playerid} and pile_type = 4
          ")

        # PlayerCard.find_by_sql("delete from player_cards
        #     where playerid = #{playerid} and pile_type = 4")

        shuffle_cards.shuffle.each_with_index do |card, index|
          deck_card = OpenStruct.new(card)

          playerid = playerid
          cardid = deck_card.cardid
          o_deckid = deck_card.o_deckid
          cur_deckid = deck_card.cur_deckid
          pile_type = index < remaining_card_count ? 2 : 1 ## 1-> deck, 2->hand, 3->active, 4->discard, 5-> temp
          card_health = 0

          PlayerCard.create(playerid: playerid, cardid: cardid, o_deckid: o_deckid, cur_deckid: cur_deckid, pile_type: pile_type, card_health: card_health)
          PlayerCard.delete(:id => deck_card.id)
        end
      end
    else
      #shuffle discard and select count cards
      shuffle_cards = PlayerCard.find_by_sql("
        select id, playerid, cardid, o_deckid, cur_deckid from player_cards 
        where playerid = #{playerid} and pile_type = 4
        ")

      shuffle_cards.shuffle.each_with_index do |deck_card, index|
        playerid = playerid
        cardid = deck_card.cardid
        o_deckid = deck_card.o_deckid
        cur_deckid = deck_card.cur_deckid
        pile_type = index < count ? 2 : 1 ## 1-> deck, 2->hand, 3->active, 4->discard, 5-> temp
        card_health = 0

        PlayerCard.create(playerid: playerid, cardid: cardid, o_deckid: o_deckid, cur_deckid: cur_deckid, pile_type: pile_type, card_health: card_health)
        PlayerCard.delete(:id => deck_card.id)
      end
    end

    deck_cards = PlayerCard.where(:pile_type => 1, :playerid => playerid).limit(count) # limit #{count}")
  end

  def update_player_playcount?(playerid)
    current_player = GamePlayer.where(:hasturn => 1).first()
    GamePlayer.update_all(:hasturn => 0)

    if current_player.nil?
      game = GamePlayer.where(:id => playerid).first()
      select_random_player?(game.id)
    else
      current_player.hasturn = 1
      current_player.playcount = current_player.playcount + 1
      current_player.save!
    end
  end

  def move_card_to_deck?(id)
    discard_cards = PlayerCard.where(:id => id)

    discard_card = discard_cards.first()
    discard_card.card_health = 0
    discard_card.pile_type = 2
    discard_card.save!
  end

  def get_playercard?(playerid)
    deck_pile = PlayerCard.connection.select_all("select cardid, dc.name, pc.card_health,
          pc.o_deckid, pc.cur_deckid, pc.pile_type from player_cards pc
          inner join deck_cards dc on pc.cardid = dc.id
          where playerid = #{playerid}")

    #deck_pile_cards = []
    hand_pile_cards = []
    active_pile_cards = []
    #discard_pile_cards = []
    deck_pile.each do |cardObj|
      card = OpenStruct.new(cardObj)
      card_effects = CardEffectsMap.connection.select_all("select cem.id, ce.name, ce.effectclass,
            cem.count from card_effects_maps cem
            inner join card_effects ce on cem.effectid = ce.id
            where cem.cardid = #{card.cardid}")

      if card.pile_type == 2
        hand_pile_cards << { cardid: card.cardid, name: card.name, card_health: card.card_health, o_deckid: card.o_deckid, cur_deckid: card.cur_deckid, effects: card_effects }
      elsif card.pile_type == 3
        active_pile_cards << { cardid: card.cardid, name: card.name, card_health: card.card_health, o_deckid: card.o_deckid, cur_deckid: card.cur_deckid, effects: card_effects }
      end
    end

    deck_pile_count = 0
    discard_pile_count = 0

    deck_pile_count = PlayerCard.where(:playerid => playerid, :pile_type => 1).count
    discard_pile_count = PlayerCard.where(:playerid => playerid, :pile_type => 4).count

    playercard = {
      :deck_pile_count => deck_pile_count,
      :discard_pile_count => discard_pile_count,
      :hand_pile => hand_pile_cards,
      :active_pile => active_pile_cards,
    }
    return playercard
  end

  ####################################################
  ################### API LIST #######################
  ####################################################

  def init
    check = checkdeckdata()
    decks = DeckDatum.select(:id, :name, :deckclass).all
    message = MSG_DECK_INITIATED
    status = STATUS_OK
    success = true
    data = {
      :deck => decks,
    }

    response_data = ApiResponse.new(message, success, data)
    render json: response_data, status: STATUS_OK
  end

  def initgame
    code = params[:gameid]
    deckid = params[:deckid]
    userid = params[:userid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gameid].present? || !params[:deckid].present? || !params[:userid].present?) || code.nil? || deckid.nil? || userid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      gamedecks = createGame?(code, userid, deckid)
      message = MSG_DECK_INITIATED
      success = true
      data = {
        :data => { decks: gamedecks },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: status
  end

  def getgamedeck
    gameid = params[:gameid]
    proceed = true
    status = STATUS_OK
    err_msg = ""

    if !params[:gameid].present? || gameid.nil?
      proceed = false
      status = STATUS_NOT_FOUND
      err_msg = MSG_PARAM_MISSING
    end

    if proceed
      gamedeck = getGameDeckByCode?(gameid)
      message = MSG_DECK_LISTING
      success = true
      data = {
        :data => { deck: gamedeck },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: status
  end

  def addplayer
    gameid = params[:gameid]
    deckid = params[:deckid]
    userid = params[:userid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gameid].present? || !params[:deckid].present? || !params[:userid].present?) || gameid.nil? || deckid.nil? || userid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      result = addPlayertoGame?(gameid, deckid, userid)
      message = MSG_PLAYER_JOINED
      success = true
      data = {
        :data => { result: result },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: status
  end

  def removeplayer
    gameid = params[:gameid]
    userid = params[:userid]
    deckid = params[:deckid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gameid].present? || !params[:userid].present? || !params[:deckid].present?) || gameid.nil? || userid.nil? || deckid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      result = removePlayerFromGame?(gameid, userid, deckid)
      message = MSG_PLAYER_LEFT
      success = true
      data = {
        :data => { result: result },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: status
  end

  def closegame
    gameid = params[:gameid]
    userid = params[:userid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gameid].present? || !params[:userid].present?) || gameid.nil? || userid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      result = closeGame?(gameid, userid)
      message = MSG_GAME_CLOSED
      success = true
      data = {
        :data => { result: result },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: status
  end

  def startgame
    gameid = params[:gameid]
    userid = params[:userid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gameid].present? || !params[:userid].present?) || gameid.nil? || userid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      data = start_game?(gameid, userid)
      message = MSG_GAME_STARTED
      success = true
      data = {
        :data => { gamedata: data },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: status
  end

  def getGameData
    gamecode = params[:gamecode]
    firstload = params[:firstload]

    if (!params[:firstload].present?)
      firstload = false
    end

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gamecode].present? || !params[:firstload]) || gamecode.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      data = get_GameData?(gamecode, firstload, 0)
      message = MSG_GAME_PLAYGING
      success = true
      data = {
        :gamedata => data,
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: status
  end

  def getplayercard
    playerid = params[:playerid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:playerid].present?) || playerid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      data = get_playercard?(playerid)
      message = MSG_GAME_PLAYGING
      success = true
      data = {
        :playercard => data,
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: status
  end
end
