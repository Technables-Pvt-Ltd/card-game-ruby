import { PUBNUB_INIT, GAME_START, PLAYER_DATA, PLAYER_CARD } from "../constants/gameactiontype";

export const initialState = {
    roomId: null,
    lobbyChannel: null,
    gameChannel: null,
    isDisabled: false,
    isPlaying: false,
    topPlayer: null,
    bottomPlayer: null,
    rightPlayer: null,
    leftPlayer: null,
    mycard: null
};

const cardgame = (state = initialState, action) => {
    switch (action.type) {

        case PUBNUB_INIT:
            return {
                ...state,
                roomId: action.msg.roomId,
                lobbyChannel: action.msg.lobbyChannel
            }
        case GAME_START:
            return {
                ...state,
                roomId: action.msg.roomId,
                lobbyChannel: action.msg.lobbyChannel,
                gameChannel: action.msg.gameChannel,
                isDisabled: action.msg.isDisabled,
                isPlaying: action.msg.isPlaying
            }
        case PLAYER_DATA:
            return {
                ...state,
                roomId: action.data.roomId,
                lobbyChannel: action.data.lobbyChannel,
                gameChannel: action.data.gameChannel,
                isDisabled: action.data.isDisabled,
                isPlaying: action.data.isPlaying,
                topPlayer: action.data.topPlayer,
                bottomPlayer: action.data.bottomPlayer,
                rightPlayer: action.data.rightPlayer,
                leftPlayer: action.data.leftPlayer,
            }
        case PLAYER_CARD:
            return {
                ...state,
                mycard: action.data.mycard
            }
        default: return state;
    }
}

export default cardgame;