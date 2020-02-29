import { PUBNUB_INIT, GAME_START, PLAYER_DATA, PLAYER_CARD } from "../constants/gameactiontype";

export const dispatchaction = {
    pubnub_init,
    game_start,
    dispatch_playerdata,
    dispatch_playercard
}


function pubnub_init(config){
    return {
        type: PUBNUB_INIT,
        msg: config
    }
}

function game_start(config){
    return {
        type: GAME_START,
        msg: config
    }
}

function dispatch_playerdata(playersObj){
    return {
        type: PLAYER_DATA,
        data: playersObj
    }
}

function dispatch_playercard(playersObj){
    return {
        type: PLAYER_CARD,
        data: playersObj
    }
}