import React, { Component } from 'react'
import { connect } from 'react-redux'
import { GetUserData } from '../../../data/helper';
import PlayerCard from './playercard'
import './index.css'
import { confirmAlert } from 'react-confirm-alert';
import 'react-confirm-alert/src/react-confirm-alert.css';

export class GamePlayer extends Component {
    constructor(props) {
        super(props);

        const { player, mycard, handleCardClickMaster } = this.props;

        this.state = {
            player, clicked: false
        }
        //this.player = player;
        this.mycard = mycard;


        this.handleCardClickMaster = handleCardClickMaster;

    }

    componentDidUpdate() {

        this.player = this.props.player;
    }

    componentWillReceiveProps(newProps) {

        this.setState({ player: newProps.player })
        // this.setState({
        //     location: newProps.location
        // })
    }



    handleCardClick = (cardid, clicked) => {
        //alert(cardid);
        clicked = !clicked;
        this.setState({ clicked: clicked, cardid: cardid });
        if (clicked) {
            confirmAlert({
                title: "Throw Card",
                message: "",
                buttons: [
                    {
                        label: "Yes",
                        onClick: () => {
                            this.handleCardClickMaster(cardid, this.player.playerid);
                            this.setState({ clicked: false })
                        }
                    },
                    {
                        label: "Cancel",
                        onClick: () => this.setState({ clicked: false })
                    }
                ]
            });
        }
    }


    render() {

        let player = this.state.player;
        let userData = GetUserData();
        let handClass = '';
        if (userData.userid === player.userid)
            handClass = 'mine';

        return (


            <div className={`player-container ${player.positionClass}`}>
                <div className="row">
                    {/* {
                        handClass.length > 0 && (
                            <div className={`hand-pile pile  ${this.player.deckclass} ${handClass}`}>
                                <span className="card-count">{this.player.discard_pile.length}</span>
                                <span className="title">hand </span>
                            </div>
                        )
                    } */}
                    {
                        handClass.length > 0 && (
                            <div className={`discard-pile pile  ${player.deckclass}`}>
                                <span className={`card-count ${player.deckclass}`}>{player.discard_pile_count}</span>
                                <span className="title">discard </span>
                            </div>
                        )
                    }

                    <div className={`player-data ${player.deckclass} ${player.hasturn ? 'playing' : ''}`}>
                        <span className={`card-count ${player.deckclass}`}>{player.health}</span>

                        <div className="player-container">
                            <span className="name-title">{player.name}</span>

                            {

                                player.hasturn === 1 && (
                                    <span className="playing-title">Playing...</span>
                                )}
                        </div>
                    </div>

                    {
                        handClass.length > 0 && (

                            <div className={`deck-pile pile ${player.deckclass}`}>
                                <span className={`card-count ${player.deckclass}`}>{player.deck_pile_count}</span>
                                <span className="title">Deck </span>
                            </div>
                        )
                    }


                </div>

                {handClass.length > 0 && (
                    <div className="row">
                        <div className={`hand-pile hand  ${player.deckclass} ${handClass}`}>
                            {
                            
                            player.hand_pile &&
                            
                                player.hand_pile.map((card, index) => {
                                    return (
                                        <PlayerCard
                                            key={card.cardid}
                                            card={card}
                                            deckclass={player.deckclass}
                                            clicked={this.state.cardid && this.state.cardid === card.cardid && this.state.clicked}
                                            handleCardClick={player.playcount > 0 ? this.handleCardClick : null} />
                                    )
                                })
                            }
                        </div>
                    </div>
                )}
            </div>


        )
    }
}

const mapStateToProps = (state) => { return state; }

const mapDispatchToProps = {

}

export default connect(mapStateToProps, mapDispatchToProps)(GamePlayer)
