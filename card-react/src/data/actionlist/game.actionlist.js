import {dispatchaction} from './dispatchactionlist'

export const gameactionlist = {
    pubnubint
}

function pubnubint(config){
    return dispatch => {
        dispatch(dispatchaction.pubnub_init(config));
    }
}

