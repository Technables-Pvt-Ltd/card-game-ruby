import {
    ROUTE_API_URL,
    ROUTE_API_INITDECK,
    ROUTE_API_DECKLIST,
    ROUTE_API_INITGAME,
    ROUTE_API_JOINGAME
} from '../constants/apiroutes'

export default {
    DECKAPI :{
        INIT_DECK: GenerateDeckURI(ROUTE_API_INITDECK),
        INIT_GAME: GenerateDeckURI(ROUTE_API_INITGAME),
        DECK_LIST: GenerateDeckURI(ROUTE_API_DECKLIST),
        JOIN_GAME: GenerateDeckURI(ROUTE_API_JOINGAME),
    }
}

function GenerateDeckURI(uri) {
    return ROUTE_API_URL + 'v1/deck/' + uri;
}

function GenerateCardURI(uri) {
    return ROUTE_API_URL + 'v1/deck/' + uri;
}