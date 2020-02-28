import React, { Component } from 'react'
import { connect } from 'react-redux'
import { gameactionlist } from "../../../data/actionlist";
import Swal from "sweetalert2";
import Aux from '../../../hoc/_Aux';
import { GetUserData } from '../../../data/helper';
import './index.css'
import GamePlayer from '../../controls/gameplayer'

export class Board extends Component {
    constructor(props) {
        super(props);
        const { match } = this.props;
        const { gamecode } = match.params;
        this.state = {
            gamecode,
            players: []
        }
        this.getGameData();
    }

    getGameData = async () => {
        let paramObj = {
            gamecode: this.state.gamecode
        }
        let result = await gameactionlist.getgamedata(paramObj);
        let gameObj = result.gamedata;
        let proceed = gameObj.proceed;

        if (!proceed) {
            Swal.fire({
                icon: "error",
                title: "Oops...",
                text: gameObj.error
            });
        }
        else {
            this.setState({
                players: gameObj.players
            })
        }


    }
    render() {
        let players = this.state.players

        let topPlayer = null;
        let bottomPlayer = null;
        let rightPlayer = null;
        let leftPlayer = null;
        let currentPlayerIndex = 0;

        const userData = GetUserData();
        let userid = userData.userid;

        players.map((player, index) => {
            switch (player.position) {
                case 'top': topPlayer = player; break;
                case 'bottom': bottomPlayer = player; break;
                case 'right': rightPlayer = player; break;
                case 'left': leftPlayer = player; break;
                default: break;
            }

            if (player.userid === userid)
                currentPlayerIndex = index;

        });

        

        return (
            <Aux>
                <div className="row player-row">
                    <div className="col-3"></div>
                    <div className="col-6 text-center">
                        {topPlayer && (<GamePlayer player={topPlayer} />)}
                    </div>
                    <div className="col-3"></div>
                </div>

                <div className="row player-row">
                    <div className="col-3 text-right">
                        {leftPlayer && (<GamePlayer player={leftPlayer} />)}
                    </div>
                    <div className="col-6 text-center">
                        <div className="game-board"></div>
                    </div>
                    <div className="col-3 text-left">
                        {rightPlayer && (<GamePlayer player={rightPlayer} />)}
                    </div>
                </div>

                <div className="row player-row">
                    <div className="col-3"></div>
                    <div className="col-6 text-center">
                        {bottomPlayer && (<GamePlayer player={bottomPlayer} />)}
                    </div>
                    <div className="col-3"></div>
                </div>

            </Aux>
        )
    }
}

const mapStateToProps = (state) => {
    return state;
}

const mapDispatchToProps = {

}

export default connect(mapStateToProps, mapDispatchToProps)(Board)
