import {
    ROUTE_API_URL,
    ROUTE_API_INITDECK,
    ROUTE_API_INITGAME
} from '../constants/apiroutes'

export default {
    DECKAPI :{
        INIT_DECK: GenerateDeckURI(ROUTE_API_INITDECK),
        INIT_GAME: GenerateDeckURI(ROUTE_API_INITGAME)
    }
}

function GenerateDeckURI(uri) {
    return ROUTE_API_URL + 'v1/deck/' + uri;
}

function GenerateCardURI(uri) {
    return ROUTE_API_URL + 'v1/deck/' + uri;
}