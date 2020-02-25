import { dispatchaction } from './dispatchactionlist'
import { services } from '../services'

export const gameactionlist = {
    pubnubint,
    deckinit,
    gameinit,
    decklist,
    joingame,
    leavegame,
    closegame
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
                    resp = respObj.data;

                    if (bindingResult) bindingResult(resp);
                }
            }
            else {

            }
        }, err => { console.log(err) }
    )
}

function gameinit(obj, bindingResult) {
    services.initgame(obj).then(
        res => {
            if (res && res.data) {
                let respObj = res.data;
                if (respObj.success) {
                    if (bindingResult) bindingResult(respObj.data)
                }
            }
        }, err => { console.log(err) }
    );
}

async function decklist(obj, bindingResult) {
    let result = null;
    await services.decklist(obj).then(
        res => {
            if (res && res.data) {
                let respObj = res.data;
                if (respObj.success) {
                    result = respObj.data;
                    if (bindingResult) bindingResult(respObj.data)
                }
            }
        }, err => { console.log(err) }
    );
    return result;
}

async function joingame(obj, bindingResult) {
    let result = null;
    await services.joingame(obj).then(
        res => {
            if (res && res.data) {
                let respObj = res.data;
                if (respObj.success) {
                    result = respObj.data;
                    if (bindingResult) bindingResult(respObj.data)
                }
            }
        }, err => { console.log(err) }
    );
    return result;
}

async function leavegame(obj) {
    let result = null;
    await services.leavegame(obj).then(
        res => {
            if (res && res.data) {
                let respObj = res.data;
                if (respObj.success) {
                    result = respObj.data;

                }
            }
        }, err => { console.log(err) }
    );
    return result;
}

async function closegame(obj) {
    let result = null;
    await services.closegame(obj).then(
        res => {
            if (res && res.data) {
                let respObj = res.data;
                if (respObj.success) {
                    result = respObj.data;

                }
            }
        }, err => { console.log(err) }
    );
    return result;
}

