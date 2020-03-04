import EndPoints from '../endpoints';
import axios from 'axios'

export const services = {
  initdeck,
  initgame,
  decklist,
  joingame,
  leavegame,
  closegame,
  startgame,
  getgamedata,
  getplayerdata,
  throwcard,
  applycardeffect,
  movenextplayer
}

const deckEndPoint = EndPoints.DECKAPI;
const cardEndPoint = EndPoints.CARDAPI;

function getHeader() {

  let axiosConfig = {
    headers: {
      get: {
        "Content-Type": "application/json;charset=UTF-8",
        "Access-Control-Allow-Origin": "*"
      }
    }
  };

  return axiosConfig;
}

async function initdeck(obj) {
let axiosConfig = getHeader();

  var response = null;

  response = await axios.get(deckEndPoint.INIT_DECK, obj, axiosConfig);

  return response;
}

async function initgame(obj) {
  let axiosConfig = getHeader();
  var response = null;

  let url = deckEndPoint.INIT_GAME + `?gameid=${obj.gameid}&deckid=${obj.deckid}&userid=${obj.userid}`;
  response = await axios.get(url, obj, axiosConfig);

  return response;
}

async function decklist(obj) {
  let axiosConfig = getHeader();
  var response = null;

  let url = deckEndPoint.DECK_LIST + `?gameid=${obj.gameid}`;
  response = await axios.get(url, obj, axiosConfig);

  return response;
}

async function joingame(obj) {
  let axiosConfig = getHeader();
  var response = null;

  let url = deckEndPoint.JOIN_GAME + `?gameid=${obj.gameid}&deckid=${obj.deckid}&userid=${obj.userid}`;
  response = await axios.get(url, obj, axiosConfig);

  return response;
}

async function leavegame(obj) {
  let axiosConfig = getHeader();
  var response = null;

  let url = deckEndPoint.LEAVE_GAME + `?gameid=${obj.gameid}&deckid=${obj.deckid}&userid=${obj.userid}`;
  response = await axios.get(url, obj, axiosConfig);

  return response;
}

async function closegame(obj) {
  let axiosConfig = getHeader();
  var response = null;

  let url = deckEndPoint.CLOSE_GAME + `?gameid=${obj.gameid}&userid=${obj.userid}`;
  response = await axios.get(url, obj, axiosConfig);

  return response;
}

async function startgame(obj) {
  let axiosConfig = getHeader();
  var response = null;

  let url = deckEndPoint.START_GAME + `?gameid=${obj.gameid}&userid=${obj.userid}`;
  response = await axios.get(url, obj, axiosConfig);

  return response;
}

async function getgamedata(obj) {
  let axiosConfig = getHeader();
  var response = null;

  let url = deckEndPoint.GET_GAME + `?gamecode=${obj.gamecode}&firstload=${obj.isFirstLoad}`;
  response = await axios.get(url, obj, axiosConfig);

  return response;
}

async function getplayerdata(obj) {
  let axiosConfig = getHeader();
  var response = null;

  let url = deckEndPoint.GET_PLAYER_CARD + `?playerid=${obj.playerid}`;
  response = await axios.get(url, obj, axiosConfig);

  return response;
}

async function throwcard(obj) {
  let axiosConfig = getHeader();
  var response = null;

  let url = cardEndPoint.THROW_CARD + `?cardid=${obj.cardid}&playerid=${obj.playerid}`;
  response = await axios.get(url, obj, axiosConfig);

  return response;
}

async function applycardeffect(obj) {
  let axiosConfig = getHeader();
  var response = null;

  let url = cardEndPoint.APPLY_CARD_EFFECT + `?cardid=${obj.cardid}&playerid=${obj.playerid}&targetid=${obj.targetid}`;
  response = await axios.get(url, obj, axiosConfig);

  return response;
}

async function movenextplayer(obj) {
  let axiosConfig = getHeader();
  var response = null;

  let url = cardEndPoint.MOVE_NEXT_PLAYER + `?gamecode=${obj.gamecode}&currentplayer=${obj.currentPlayerid}`;
  response = await axios.get(url, obj, axiosConfig);

  return response;
}

