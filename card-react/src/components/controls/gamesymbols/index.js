import React, { Component } from "react";
import {
  faHeartbeat,
  faShieldAlt,
  faEject,
  faReply,
  faKhanda
} from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import "./index.css";

class GameSymbols extends Component {
  render() {
    return (
      <div className="d-flex flex-column align-items-left justify-content-center">
        <div className="symbol-container">
          <p> Here are symbols associated with the game.</p>
          <ul className="list-group card-instructions">
            <li className="list-group-item">
              <FontAwesomeIcon
                key={1}
                className="eff-icon"
                icon={faHeartbeat}
              />{" "}
              <span className="effect-title">Heal</span>
            </li>
            <li className="list-group-item">
              <FontAwesomeIcon
                key={2}
                className="eff-icon"
                icon={faShieldAlt}
              />{" "}
              <span className="effect-title">Defense</span>
            </li>
            <li className="list-group-item">
              <FontAwesomeIcon key={3} className="eff-icon" icon={faEject} />{" "}
              <span className="effect-title">Draw</span>
            </li>
            <li className="list-group-item">
              <FontAwesomeIcon key={4} className="eff-icon" icon={faReply} />{" "}
              <span className="effect-title">Play Again</span>
            </li>
            <li className="list-group-item">
              <FontAwesomeIcon key={5} className="eff-icon" icon={faKhanda} />{" "}
              <span className="effect-title">Attack</span>
            </li>
          </ul>
        </div>

      </div>
    );
  }
}

export default GameSymbols;
