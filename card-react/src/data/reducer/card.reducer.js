import { PUBNUB_INIT, GAME_START } from "../constants/gameactiontype";

export const initialState = {
    roomId: null,
    lobbyChannel: null,
    gameChannel: null,
    isDisabled: false,
    isPlaying: false
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
        default: return state;
    }
}

export default cardgame;