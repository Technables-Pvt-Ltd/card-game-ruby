import {
    ROUTE_API_URL,
    ROUTE_API_INITDECK,
    ROUTE_API_DECKLIST,
    ROUTE_API_INITGAME,
    ROUTE_API_JOINGAME,
    ROUTE_API_LEAVEGAME,
    ROUTE_API_CLOSEGAME,
    ROUTE_API_STARTGAME,
    ROUTE_API_GETGAMEDATA,
    ROUTE_API_GETPLAYERCARD,
    ROUTE_API_THROW_CARD,
    ROUTE_API_APPLY_CARD_EFFECT
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
        GET_GAME: GenerateDeckURI(ROUTE_API_GETGAMEDATA),
        GET_PLAYER_CARD: GenerateDeckURI(ROUTE_API_GETPLAYERCARD)
    },

    CARDAPI: {
        THROW_CARD: GenerateCardURI(ROUTE_API_THROW_CARD),
        APPLY_CARD_EFFECT: GenerateCardURI(ROUTE_API_APPLY_CARD_EFFECT),
    }
}

function GenerateDeckURI(uri) {
    return ROUTE_API_URL + 'v1/deck/' + uri;
}

function GenerateCardURI(uri) {
    return ROUTE_API_URL + 'v1/card/' + uri;
}