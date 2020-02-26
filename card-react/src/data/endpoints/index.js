import {
    ROUTE_API_URL,
    ROUTE_API_INITDECK,
    ROUTE_API_DECKLIST,
    ROUTE_API_INITGAME,
    ROUTE_API_JOINGAME,
    ROUTE_API_LEAVEGAME,
    ROUTE_API_CLOSEGAME,
    ROUTE_API_STARTGAME
} from '../constants/apiroutes'

export default {
    DECKAPI :{
        INIT_DECK: GenerateDeckURI(ROUTE_API_INITDECK),
        INIT_GAME: GenerateDeckURI(ROUTE_API_INITGAME),
        DECK_LIST: GenerateDeckURI(ROUTE_API_DECKLIST),
        JOIN_GAME: GenerateDeckURI(ROUTE_API_JOINGAME),
        LEAVE_GAME: GenerateDeckURI(ROUTE_API_LEAVEGAME),
        CLOSE_GAME: GenerateDeckURI(ROUTE_API_CLOSEGAME),
        START_GAME: GenerateDeckURI(ROUTE_API_STARTGAME),
    }
}

function GenerateDeckURI(uri) {
    return ROUTE_API_URL + 'v1/deck/' + uri;
}

function GenerateCardURI(uri) {
    return ROUTE_API_URL + 'v1/deck/' + uri;
}