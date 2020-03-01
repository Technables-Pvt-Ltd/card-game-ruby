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
        :proceed => proceed, :error => error, :updated => true,
      }
      return data
    else
      data = {
        :proceed => proceed, :error => error, :update => false,
      }
      return data
    end
  end

  def apply_card_effect?(cardid, playerid, targetid)
    proceed = false
    error = ""
    players = GamePlayer.where("id  = ? and status = 1 and hasturn = 1", playerid)
    #game = games.first()
    data = []
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

      #cardffects = CardEffectsMap.where(:cardid => cardid)

      cardffects = CardEffectsMap.where(:cardid => cardid)
      # select effectid, count from card_effects_maps
      # where cardid = #{cardid}")

      if (cardffects.any? == true)
        proceed = true
        error = ""
        #data = cardffects.length
        movecard = true
        cardffects.each do |cardeffect|
          #cardeffect = OpenStruct.new(effect)
          data << { effect: cardeffect }
          case cardeffect.effectid
          when 1
            apply_playagain?(playerid, cardeffect.count)
            #break
          when 2
            apply_draw?(playerid, cardeffect.count)
            #break
          when 3
            apply_attack?(targetid, cardeffect.count)
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
        :proceed => proceed, :error => error, :data => data,
      }
      return data
    else
      data = {
        :proceed => proceed, :error => error, :data => [],
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
    if (health > 10)
      health = 10
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
          select playerid, cardid, o_deckid, cur_deckid from player_cards 
          where playerid = #{playerid} and pile_type = 4
          ")

        PlayerCard.find_by_sql("delete from player_cards 
            where playerid = #{playerid} and pile_type = 4")

        shuffle_cards.shuffle.each_with_index do |card, index|
          deck_card = OpenStruct.new(card)

          playerid = playerid
          cardid = deck_card.id
          o_deckid = deck_card.o_deckid
          cur_deckid = deck_card.cur_deckid
          pile_type = index < remaining_card_count ? 2 : 1 ## 1-> deck, 2->hand, 3->active, 4->discard, 5-> temp
          card_health = 0

          PlayerCard.create(playerid: playerid, cardid: cardid, o_deckid: o_deckid, cur_deckid: cur_deckid, pile_type: pile_type, card_health: card_health)
        end
      end
    else
      #shuffle discard and select count cards
      shuffle_cards = PlayerCard.find_by_sql("
        select playerid, cardid, o_deckid, cur_deckid from player_cards 
        where playerid = #{playerid} and pile_type = 4
        ")

      PlayerCard.find_by_sql("delete from player_cards 
          where playerid = #{playerid} and pile_type = 4")

      shuffle_cards.shuffle.each_with_index do |deck_card, index|
        playerid = playerid
        cardid = deck_card.id
        o_deckid = deck_card.o_deckid
        cur_deckid = deck_card.cur_deckid
        pile_type = index < count ? 2 : 1 ## 1-> deck, 2->hand, 3->active, 4->discard, 5-> temp
        card_health = 0

        PlayerCard.create(playerid: playerid, cardid: cardid, o_deckid: o_deckid, cur_deckid: cur_deckid, pile_type: pile_type, card_health: card_health)
      end
    end
  end

  def apply_attack?(targetplayerid, count)
    deck_cards = PlayerCard.find_by_sql("select id,card_health from player_cards 
      where pile_type = 3 and playerid=#{targetplayerid} order by updated_at")

    remaining_count = count
    if (deck_cards.any?)
      deck_cards.each do |deck_card|
        #deck_card = OpenStruct.new(card)
        health = deck_card.card_health
        if (remaining_count >= health)
          deck_card.card_health = 0
          move_card_to_discard?(deck_card.id)
          remaining_count = remaining_count - health
        else
          deck_card.card_health = health - remaining_count
          remaining_count = 0
        end
        deck_card.save!
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
        else
          target_player.health = player_health - remaining_count
          target_player.save!
        end
      end
    end
  end

  def move_to_next_player?(playerid)
    current_player = GamePlayer.where(:id => playerid).first()
    GamePlayer.update_all(:hasturn => 0)
    position = current_player.position
    gameid = current_player.gameid
    newposition = (position + 1).remainder(4)

    new_player = GamePlayer.where(:gameid => gameid, :position => newposition).first()
    new_player.hasturn = 1
    new_player.playcount = 1
    new_player.save!
    apply_draw?(new_player.id, 1)
  end

  def move_card_to_discard?(id)
    discard_cards = PlayerCard.where(:id => id)

    discard_card = discard_cards.first()
    discard_card.card_health = 0
    discard_card.pile_type = 4
    discard_card.save!
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
end
