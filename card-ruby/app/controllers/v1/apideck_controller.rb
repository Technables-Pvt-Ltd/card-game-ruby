class V1::ApideckController < ApplicationController
  def index
    message = MSG_API_VERSION
    success = true
    data = {
      :deck => MSG_API_VERSION,
    }

    response_data = ApiResponse.new(message, success, data)
    render json: response_data, status: STATUS_OK
  end

  def init
    message = MSG_DECK_INITIATED
    status = STATUS_OK
    success = true
    data = {
      :deck => DECK_MASTER,
    }

    response_data = ApiResponse.new(message, success, data)
    render json: response_data, status: STATUS_OK
  end

  def initgame
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
      message = MSG_DECK_INITIATED
      success = true
      data = {
        :data => { gameid: gameid, deckid: deckid, userid: userid },
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
      message = MSG_DECK_INITIATED
      success = true
      data = {
        :data => { gameid: gameid, deckid: deckid, userid: userid },
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
      message = MSG_DECK_INITIATED
      success = true
      data = {
        :data => { gameid: gameid, deckid: deckid, userid: userid },
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
    if (!params[:gameid].present? ||  !params[:userid].present?) || gameid.nil? || userid.nil?
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

  def startgame
    gameid = params[:gameid]
    userid = params[:userid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gameid].present? ||  !params[:userid].present?) || gameid.nil? || userid.nil?
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
