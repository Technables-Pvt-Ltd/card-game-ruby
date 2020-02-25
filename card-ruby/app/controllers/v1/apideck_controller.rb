require "db_controller"
require "sqlite3"

class V1::ApideckController < ApplicationController
  include DbController

  #db = SQLite3::Database.new

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

      db = SQLite3::Database.open "db/card.sqlite3"
      db.results_as_hash = true

      check_user_exists = db.prepare("select 1 where exists(select 1 from game_decks gd
        inner join card_games cg on gd.gameid = cg.id
         where gd.userid = :userid and deckid<> :deckid
         and isselected = 1 
         and cg.code = :code)")
      decks = check_user_exists.execute :userid => userid, :deckid=> deckid, :code => code
      exists = decks.any?

      if (exists == true)
        proceed = false
        error = "user already exists in this game"
      else
        check_deck_available = db.prepare("select 1 where exists(select 1 from game_decks gd
          where gd.deckid =:deckid  and gd.gameid = :gameid and isselected=true and userid <> :userid)")
        taken_cards = check_deck_available.execute :deckid => deckid, :gameid => game.id, :userid => userid
        is_taken = taken_cards.any?

        if (is_taken)
          proceed = false
          error = "this deck is already selected"
        else
          #ActiveRecord::Base.connection.execute("END TRANSACTION; END;")
          #error = 'udpated'
          update_deck_card = db.prepare("update game_decks
                    set isselected = 1, userid = :userid
                    where deckid = :deckid and gameid = :gameid")
          update_deck_card.execute :userid => userid, :deckid => deckid, :gameid => game.id
        end

        # gamedecks = GameDeck.where("gameid=?", game.id)

        # gamedecks.each do |deck|
        #   error += deck.id.to_s + " "
        #   if (deck.id == deckid)
        #     if (deck.isselected == false)
        #       deck.isselected = true
        #       deck.userid = userid
        #       deck.save
        #     else
        #       proceed = false
        #       error = "this deck is already selected"
        #     end
        #   end
        # end
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

  def removePlayerFromGame?(code, userid)
    proceed = false
    error = ""
    game = CardGame.where("code = ?", code)
    if (game.length == 0)
      proceed = false
      error = "game with the provided code does not exists"
    else
      proceed = true
      error = ""
      gamedecks = GameDeck.where("gameid=?", game.id)

      check_deck_available = db.prepare("select 1 where exists(select 1 from game_decks gd
        where gd.deckid =:deckid  and gd.gameid = :gameid and isselected=true and userid = :userid)")
      taken_cards = check_deck_available.execute :deckid => deckid, :gameid => game.id, :userid => userid
      is_taken = taken_cards.any?

      if (is_taken)
        update_deck_card = db.prepare("update game_decks
          set isselected = 1, userid = :userid
          where deckid = :deckid and gameid = :gameid")
          update_deck_card.execute :userid => userid, :deckid => deckid, :gameid => game.id
      else
        #ActiveRecord::Base.connection.execute("END TRANSACTION; END;")
        #error = 'udpated'
        proceed = false
        error = "sorry!! could not complete the operation"
      end

      # gamedecks.each do |deck|
      #   if (deck.userid == userid)
      #     if (deck.isselected == true)
      #       deck.isselected = false
      #       deck.userid = ""
      #       deck.save
      #     else
           
      #     end
      #   end
      # end
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
      #return {proceed: proceed, error: error, decklist = getGameDeck?(gameid)}
    end
  end

  def getGameDeck?(gameid)
    db = SQLite3::Database.open "db/card.sqlite3"
    db.results_as_hash = true
    statememt = db.prepare("select dt.id, dt.name, gd.isselected , gd.userid
      from game_decks gd 
      Inner Join deck_data dt 
        on dt.id = gd.deckid  where gd.gameid = :gameid")
    decks = statememt.execute :gameid => gameid
    #decks = GameDeck.select("dt.id, dt.name, game_decks.isselected").joins("Inner Join deck_data dt on dt.id = game_decks.deckid").where(gameid: gameid)
    return decks
  end

  def getGameDeckByCode?(gamecode)
    db = SQLite3::Database.open "db/card.sqlite3"
    db.results_as_hash = true
    statement = db.prepare("select dt.id as id, dt.name, gd.isselected , gd.userid, dt.deckclass
      from game_decks gd 
      Inner Join deck_data dt 
        on dt.id = gd.deckid 
      inner join card_games cg 
        on cg.id = gd.gameid
      where cg.code = :gamecode")

    decks = statement.execute :gamecode => gamecode

    #decks = GameDeck.select("dt.id, dt.name, game_decks.isselected").joins("Inner Join deck_data dt on dt.id = game_decks.deckid").where(code: gamecode)
    return decks
  end

  # def addGameDeck
  #   #truncatetable?('deck_data')
  #   checkdeckdata()
  #   decks = DeckDatum.select(:id, :name, :deckclass).all

  #   resultDecks = []

  #   decks.each do |deck|
  #     cards = DeckCard.select(:id, :deckid, :name).where(deckid: deck.id)

  #     resultCards = []

  #     cards.each do |card|
  #       effects = CardEffectsMap.select('card_effects_maps.id, eff.name, eff.effectclass, card_effects_maps.count,card_effects_maps.cardid').joins('Inner Join card_effects eff on eff.id = card_effects_maps.effectid')#.where(cardid: card.id)
  #       resultCards<< {card: card ,effects: effects};
  #     end

  #     resultDecks << { deck: deck, cards: resultCards }
  #   end

  #   message = MSG_DECK_INITIATED
  #   status = STATUS_OK
  #   success = true
  #   data = {
  #     :deck => resultDecks,

  #   }

  #   response_data = ApiResponse.new(message, success, data)
  #   render json: response_data, status: STATUS_OK
  # end

  def init
    check = checkdeckdata()
    decks = DeckDatum.select(:id, :name, :deckclass).all
    message = MSG_DECK_INITIATED
    status = STATUS_OK
    success = true
    data = {
      :deck => decks,
      :check => check,
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
    render json: response_data, status: STATUS_OK
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
    render json: response_data, status: STATUS_OK
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
    render json: response_data, status: STATUS_OK
  end

  def removeplayer
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
      result = removePlayerFromGame?(gameid, deckid, userid)
      message = MSG_PLAYER_LEFT
      success = true
      data = {
        :data => { result: result },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: STATUS_OK
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
      message = MSG_DECK_INITIATED
      success = true
      data = {
        :data => { gameid: gameid, userid: userid },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: STATUS_OK
  end
end
