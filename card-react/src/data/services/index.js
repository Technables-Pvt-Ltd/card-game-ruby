import EndPoints from '../endpoints';
import axios from 'axios'

export const services = {
  initdeck,
  initgame,
  decklist,
  joingame,
  leavegame,
  closegame
}

const deckEndPoint = EndPoints.DECKAPI;

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