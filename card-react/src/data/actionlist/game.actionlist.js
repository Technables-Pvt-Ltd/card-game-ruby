import { dispatchaction } from './dispatchactionlist'
import { services } from '../services'

export const gameactionlist = {
    pubnubint,
    deckinit,
    gameinit,
    dispatchPlayerdata,
    dispatchPlayerCard,
    decklist,
    joingame,
    leavegame,
    closegame,
    startgame,
    gamestart,
    getgamedata,
    getPlayerCard,
    throwcard,
    applycardeffect,
    movenextplayer
}

function pubnubint(config) {
    return dispatch => {
        dispatch(dispatchaction.pubnub_init(config));
    }
}

function gamestart(config) {
    return dispatch => {
        dispatch(dispatchaction.game_start(config));
    }
}

function dispatchPlayerdata(playerObj) {
    return dispatch => {
        dispatch(dispatchaction.dispatch_playerdata(playerObj))
    }
}

function dispatchPlayerCard(playerObj) {
    return dispatch => {
        dispatch(dispatchaction.dispatch_playercard(playerObj))
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

async function startgame(obj) {
    let result = null;
    await services.startgame(obj).then(
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

async function getgamedata(obj) {
    let result = null;
    await services.getgamedata(obj).then(
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

async function getPlayerCard  (obj) {
    let result = null;
    await services.getplayerdata(obj).then(
        res => {
            if (res && res.data) {
                let respObj = res.data;
                if (respObj.success)
                    result = respObj.data;
            }
        }, err => { console.log(err) }
    )

    return result;
}

async function throwcard  (obj) {
    let result = null;
    await services.throwcard(obj).then(
        res => {
            if (res && res.data) {
                let respObj = res.data;
                if (respObj.success)
                    result = respObj.data;
            }
        }, err => { console.log(err) }
    ) 

    return result;
}

async function applycardeffect(obj) {
    let result = null;
    await services.applycardeffect(obj).then(
        res => {
            if (res && res.data) {
                let respObj = res.data;
                if (respObj.success)
                    result = respObj.data;
            }
        }, err => { console.log(err) }
    ) 

    return result;
}

async function movenextplayer(obj) {
    let result = null;
    await services.movenextplayer(obj).then(
        res => {
            if (res && res.data) {
                let respObj = res.data;
                if (respObj.success)
                    result = respObj.data;
            }
        }, err => { console.log(err) }
    ) 

    return result;
}

