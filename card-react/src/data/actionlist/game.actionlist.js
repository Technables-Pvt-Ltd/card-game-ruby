import { dispatchaction } from './dispatchactionlist'
import { services } from '../services'

export const gameactionlist = {
    pubnubint,
    deckinit
}

function pubnubint(config) {
    return dispatch => {
        dispatch(dispatchaction.pubnub_init(config));
    }
}

function deckinit(obj, bindingResult) {
    services.initdeck(obj).then(
        res => {

            if (res && res.data) {
                let respObj = res.data;

                if (respObj.success) {

                    var resp = null;
                    resp = res.data;

                    if (bindingResult) bindingResult(resp);
                }
            }
            else {

            }
        }
    )
}

