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
import GameHint from '../../../GameHint.png';

class GameGuides extends Component {
    render() {
        return (
            <div className="d-flex flex-column align-items-left justify-content-center comp-gameguide">


                <div className="symbol-container">
                    <div className="d-flex justify-content-between flex-column ">
                        <p> Here are some of game hint.</p>
                        <small className='text-muted'>Click on the image to enlarge</small>
                    </div>
                    <div className="hint-container col-12">
                        <a  href={GameHint} target="_blank"><img
                            className="game-hint"
                            src={GameHint}
                            alt="Game Hint"
                        />
                        </a>
                    </div>
                </div>
            </div>
        );
    }
}

export default GameGuides;
