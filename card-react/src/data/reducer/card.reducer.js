import { PUBNUB_INIT } from "../constants/gameactiontype";

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
            debugger;
            return {
                ...state,
                roomId: action.msg.roomId,
                lobbyChannel: action.msg.lobbyChannel
            }
        default: return state;
    }
}

export default cardgame;