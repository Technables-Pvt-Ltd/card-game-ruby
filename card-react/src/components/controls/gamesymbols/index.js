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

        <div className="symbol-container">
          <div className="d-flex justify-content-between">
            <p> Here are some of game guides.</p>
          </div>
          <ul className="list-group card-instructions">
            <li className="list-group-item">
              <span class="title">1. Player Data</span>
              <ul className="list-group list-group-flush">
                <li className="list-group-item">1 (a). Player name</li>
                <li className="list-group-item">1 (b). Player Health</li>
              </ul>
            </li>
            <li className="list-group-item">
              <span class="title">2. Hand Pile</span>
              <ul className="list-group list-group-flush">
                <li className="list-group-item">2 (a). Hand Card</li>
                <li className="list-group-item">2 (b). Card effects</li>
              </ul>
            </li>
            <li className="list-group-item">
              <span class="title">3. Active Pile</span>
              <ul className="list-group list-group-flush">
                <li className="list-group-item">3 (a). Active/Defense Card</li>
              </ul>
            </li>
            <li className="list-group-item">
              <span class="title">4. Board</span>
              <ul className="list-group list-group-flush">
                <li className="list-group-item">4 (a). Thrown Card</li>
              </ul>
            </li>
            <li className="list-group-item">
              <span class="title">5. Draw Pile</span>
              <ul className="list-group list-group-flush">
                <li className="list-group-item">5 (a). Avaiable Card Count</li>
              </ul>
            </li>
            <li className="list-group-item">
              <span class="title">6. Discard Pile</span>
              <ul className="list-group list-group-flush">
                <li className="list-group-item">6 (a). Discarded card count</li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    );
  }
}

export default GameSymbols;
