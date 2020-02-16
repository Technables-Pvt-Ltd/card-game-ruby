import { PUBNUB_INIT } from "../constants/gameactiontype";

export const dispatchaction = {
    pubnub_init
}


function pubnub_init(config){
    return {
        type: PUBNUB_INIT,
        msg: config
    }
}