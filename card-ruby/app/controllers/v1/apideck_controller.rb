require "db_controller"

class V1::ApideckController < ApplicationController
  include DbController

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
      if (deck.id == deckid)
        isSelected = true
        user = userid
      end

      GameDeck.create(gameid: gameid, deckid: deck.id, userid: user, isselected: isselected)
    end

    return getGameDeck?(game.id)
  end

  def addPlayertoGame?(gameid, deckid, userid)
    proceed = false
    error = ''
    game = CardGame.where("code = ?", code)
    if(game.length==0)
      proceed = false
      error = 'game with the provided code does not exists'
    elsif game.status == GAME_STATUS_INIT
      proceed = false
      error = 'game does not accept player anymore'
    else
      proceed = true
      error = ''
      gamedecks = GameDeck.where('gameid=?', game.id)

      gamedecks.each do |deck|        
        if (deck.id == deckid )
          if(deck.isselected==false)

          deck.isselected = true
          deck.userid = userid
          deck.save
          
          else
            proceed = false
            error ='this deck is already selected'
          end
        end
      end
    end
    if proceed
      return {proceed: proceed, error: error, decklist = getGameDeck?(gameid)}
    else
      return {proceed: proceed, error: error, decklist = []}
    end

  end

  def removePlayerFromGame?(code,  userid)
    proceed = false
    error = ''
    game = CardGame.where("code = ?", code)
    if(game.length==0)
      proceed = false
      error = 'game with the provided code does not exists'    
    else
      proceed = true
      error = ''
      gamedecks = GameDeck.where('gameid=?', game.id)

      gamedecks.each do |deck|        
        if (deck.userid == userid )
          if(deck.isselected==true)
            deck.isselected = false
            deck.userid = ''
            deck.save          
          else
            proceed = false
            error ='sorry!! could not complete the operation'
          end
        end
      end
    end
    if proceed
      return {proceed: proceed, error: error, decklist = []}
    else
      return {proceed: proceed, error: error, decklist = getGameDeck?(gameid)}
    end

  end

  def getGameDeck?(gameid)
    decks = GameDeck.select("dt.id, dt.name, game_decks.isselected").joins("Inner Join deck_data dt on dt.id = game_decks.deckid").where(gameid: gameid)
    return decks
  end

  def getGameDeckByCode?(gamecode)
    decks = GameDeck.select("dt.id, dt.name, game_decks.isselected").joins("Inner Join deck_data dt on dt.id = game_decks.deckid").where(code: gamecode)
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

    if !params[:gameid].ispresent? || gameid.nil?
      proceed = false
      status = STATUS_NOT_FOUND
      err_msg = MSG_PARAM_MISSING
    end

    if proceed
      gamedeck = getGameDeck?(gameid)
      message = MSG_DECK_INITIATED
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
      result = addPlayertoGame?(gameid, deckid, userid);
      message = MSG_DECK_INITIATED
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
      result = removePlayerFromGame?(gameid, deckid, userid);
      message = MSG_DECK_INITIATED
      success = true
      data = {
        :data => { result:result},
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
