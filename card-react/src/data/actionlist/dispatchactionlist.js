import { PUBNUB_INIT, GAME_START } from "../constants/gameactiontype";

export const dispatchaction = {
    pubnub_init,
    game_start
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