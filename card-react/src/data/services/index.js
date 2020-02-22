import EndPoints from '../endpoints';
import axios from 'axios'

export const services = {
  initdeck
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