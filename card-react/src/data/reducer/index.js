import { combineReducers } from "redux";

import cardgame from './card.reducer'

const rootReducer = combineReducers({ cardgame });

export default rootReducer;