require "open_struct"

class V1::ApicardController < ApplicationController
  ####################################################
  ############## API HELPER METHODS ##################
  ####################################################
  def throw_card?(cardid, playerid)
    proceed = false
    error = ""
    players = GamePlayer.where("id  = ? and status = 1 and hasturn = 1 and playcount > 0", playerid)
    #player = GamePlayer.where("id  = ? and status = 1 and playcount > 0 ", playerid)
    #game = games.first()
    if (players.length == 0)
      proceed = false
      error = "invalid player request"
    else
      proceed = true
      error = ""
      can_attack = false
      opponent_data = []

      statement = "select 1 where exists(select 1 from player_cards where cardid = #{cardid} 
      and playerid = #{playerid} and pile_type = 2)"

      cards = PlayerCard.connection.select_all(statement)
      exists = cards.any?
      playcount = 0
      if (exists == true)
        proceed = true
        error = ""
        player = players.first()
        update_card = PlayerCard.lock("FOR UPDATE NOWAIT").find_by(playerid: playerid, cardid: cardid)
        update_card.pile_type = 5
        update_card.save!

        attack_statement = "select 1 where exists (select 1 from card_effects_maps where effectid = 3 and cardid = #{cardid})"

        attact_cards = CardEffectsMap.find_by_sql(attack_statement)
        can_attack = attact_cards.any?

        if can_attack
          opponent_data = get_opponent_data?(playerid)
        end

        update_player = GamePlayer.lock("FOR UPDATE NOWAIT").find_by(id: playerid)

        update_player.playcount = player.playcount - 1
        update_player.save!
      else
        proceed = false
        error = "invalid card request "
      end
    end
    if proceed
      data = {
        :proceed => proceed, :error => error, :updated => true, :can_attack => can_attack, :opponent_data => opponent_data,
      }
      return data
    else
      data = {
        :proceed => proceed, :error => error, :update => false, :can_attack => false,
      }
      return data
    end
  end

  def get_opponent_data?(playerid)
    game = GamePlayer.where(:id => playerid).first()

    statement = "select gp.id, dd.name, gp.health, dd.deckclass from game_players gp inner join deck_data dd on gp.deckid = dd.id
    and gp.gameid = #{game.gameid} and gp.id <> #{playerid} and gp.status = 1"

    game_players = GamePlayer.connection.select_all(statement)

    opponent_data = []

    game_players.each do |player|
      game_player = OpenStruct.new(player)

      card_health = 0
      card_health = PlayerCard.where(:playerid => game_player.id, :pile_type => 3).sum("card_health")

      opponent_data << {
        playerid: game_player.id,
        name: game_player.name,
        health: game_player.health,
        deckclass: game_player.deckclass,
        card_health: card_health,
      }
    end
    return opponent_data
  end

  def apply_card_effect?(cardid, playerid, targetid)
    proceed = false
    error = ""
    players = GamePlayer.where("id  = ? and status = 1 and hasturn = 1", playerid)
    data = []
    #game = games.first()
    if (players.length == 0)
      proceed = false
      error = "invalid player request"
    else
      proceed = true
      error = ""

      statement = "select 1 where exists(select 1 from player_cards where cardid = #{cardid} 
      and playerid = #{playerid} and pile_type = 5)"

      cards = PlayerCard.connection.select_all(statement)
      exists = cards.any?

      cardffects = CardEffectsMap.where(:cardid => cardid)

      if (cardffects.any? == true)
        proceed = true
        error = ""
        movecard = true
        cardffects.each do |cardeffect|
          case cardeffect.effectid
          when 1
            apply_playagain?(playerid, cardeffect.count)
            #break
          when 2
            apply_draw?(playerid, cardeffect.count)
            #break
          when 3
            data = apply_attack?(targetid, cardeffect.count)

            #break
          when 4
            movecard = false
            apply_defense?(playerid, cardid, cardeffect.count)
            #break
          when 5
            apply_heal?(playerid, cardeffect.count)
            #break
          else
            #data = cardeffect
            break
          end
        end
        if (movecard)
          deck_card = PlayerCard.where(:playerid => playerid, :cardid => cardid).first()
          move_card_to_discard?(deck_card.id)
        end
        # data =
      else
        proceed = false
        error = "invalid card request "
      end
    end
    if proceed
      updated_player = GamePlayer.where("id  = ? and status = 1 and hasturn = 1", playerid).first()

      if (updated_player.playcount == 0)
        move_to_next_player?(playerid)
      end

      data = {
        :proceed => proceed, :error => error, :updated => true, :data => data,
      }
      return data
    else
      data = {
        :proceed => proceed, :error => error, :updated => false,
      }
      return data
    end
  end

  def apply_playagain?(playerid, count)
    players = GamePlayer.where("id  = ? and status = 1 and hasturn = 1", playerid)
    player = players.first()
    update_player = GamePlayer.lock("FOR UPDATE NOWAIT").find_by(id: playerid)
    update_player.playcount = player.playcount + count
    update_player.save!
  end

  def apply_heal?(playerid, count)
    players = GamePlayer.where("id  = ? and status = 1 and hasturn = 1", playerid)

    player = players.first()
    health = player.health
    health = health + count
    if (health > PLAYER_HEALTH)
      health = PLAYER_HEALTH
    end
    update_player = GamePlayer.lock("FOR UPDATE NOWAIT").find_by(id: playerid)
    update_player.health = health
    update_player.save!
  end

  def apply_defense?(playerid, cardid, count)
    update_card = PlayerCard.lock("FOR UPDATE NOWAIT").find_by(playerid: playerid, cardid: cardid)
    update_card.pile_type = 3
    update_card.card_health = count
    update_card.save!
  end

  def apply_draw?(playerid, count)
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
          select id,playerid, cardid, o_deckid, cur_deckid from player_cards 
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
        select id,playerid, cardid, o_deckid, cur_deckid from player_cards 
        where playerid = #{playerid} and pile_type = 4
        ")

      # PlayerCard.find_by_sql("delete from player_cards
      #     where playerid = #{playerid} and pile_type = 4")

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
  end

  def apply_attack?(targetplayerid, count)
    deck_cards = PlayerCard.find_by_sql("select id,card_health from player_cards 
      where pile_type = 3 and playerid=#{targetplayerid} order by updated_at")
    data = []

    remaining_count = count
    #data << { remaining_count: remaining_count }
    if (deck_cards.any?)
      deck_cards.each do |deck_card|
        #deck_card = OpenStruct.new(card)
        health = deck_card.card_health
        if (remaining_count >= health)
          deck_card.card_health = 0
          move_card_to_discard?(deck_card.id)
          remaining_count = remaining_count - health
          deck_card.save!
        else
          deck_card.card_health = health - remaining_count
          remaining_count = 0
          deck_card.save!
        end
      end
    end

    if (remaining_count > 0)
      target_player = GamePlayer.where(:id => targetplayerid).first()
      if !target_player.nil?
        player_health = target_player.health
        if (player_health <= remaining_count)
          target_player.health = 0
          target_player.status = 0
          target_player.playcount = 0
          target_player.save!

          reset_player?(targetplayerid)
        else
          target_player.health = player_health - remaining_count
          target_player.save!
        end
      end
    end

    #return deck_cards
  end

  def reset_player?(playerid)
    player = GamePlayer.where(:id => playerid, :status => 0, :health => 0).first()
    #if player.any?
    statement = "update player_cards set pile_type = 1, card_health = 0, cur_deckid = o_deckid where playerid = #{player.id}"
    PlayerCard.find_by_sql(statement)
    #end
  end

  def move_to_next_player?(playerid)
    current_player = GamePlayer.where(:id => playerid).first()
    GamePlayer.update_all(:hasturn => 0)
    position = current_player.position
    gameid = current_player.gameid

    totalPlayers = GamePlayer.where(:gameid => current_player.gameid).count(:id)

    newposition = position

    nextplayer = true
    next_player = nil
    while (nextplayer)
      newposition = (newposition + 1).remainder(totalPlayers)
      next_player = GamePlayer.where(:gameid => gameid, :position => newposition).first()
      if (next_player.status == 1)
        nextplayer = false
      end
    end
    #new_player = GamePlayer.where(:gameid => gameid, :position => newposition).first()
    next_player.hasturn = 1
    next_player.playcount = 1
    next_player.save!
    apply_draw?(next_player.id, 1)
  end

  def move_card_to_discard?(id)
    discard_cards = PlayerCard.where(:id => id)

    discard_card = discard_cards.first()
    discard_card.card_health = 0
    discard_card.pile_type = 4
    discard_card.save!
  end

  def move_next_force?(gamecode)
    game = CardGame.where(:code => gamecode).first()

    active_players_count = GamePlayer.where(:gameid => game.id, :status => 1).count(:id)

    if (active_players_count > 1)
      timeout_player = GamePlayer.where(:gameid => game.id, :hasturn => 1).first()
      timeout_player.health = 0
      timeout_player.status = 0
      timeout_player.save!
      #player = OpenStruct.new(timeout_player);
      reset_player?(timeout_player.id)
      move_to_next_player?(timeout_player.id)
    end
    data = {
      :proceed => true, :error => "", :updated => true,
    }
  end

  ####################################################
  ################### API LIST #######################
  ####################################################
  def throwcard
    cardid = params[:cardid]
    playerid = params[:playerid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:cardid].present? || !params[:playerid].present?) || cardid.nil? || playerid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      result = throw_card?(cardid, playerid)
      message = MSG_CARD_THROWN
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

  def applycardeffect
    cardid = params[:cardid]
    playerid = params[:playerid]
    targetid = params[:targetid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:cardid].present? || !params[:playerid].present?) || cardid.nil? || playerid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      result = apply_card_effect?(cardid, playerid, targetid)
      message = MSG_EFFECT_APPLIED
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

  def movenextforce
    gamecode = params[:gamecode]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gamecode].present?) || gamecode.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      result = move_next_force?(gamecode)
      message = MSG_PLAYER_TIMEOUT
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
end
