import React, { Component } from 'react'
import { connect } from 'react-redux'
import { GetUserData } from '../../../data/helper';

export class GamePlayer extends Component {
    constructor(props) {
        super(props);
        const { player } = this.props;
        this.player = player;
    }
    render() {

        let userData = GetUserData();
        let handClass = '';
        if (userData.userid === this.player.userid)
            handClass = 'mine'

        return (


            <div className={`player-container ${this.player.position}`}>
                <div className="row">
                    {
                        handClass.length === 0 && (
                            <div className={`hand-pile pile  ${this.player.deckclass} ${handClass}`}>
                                <span className="card-count">{this.player.discard_pile.length}</span>
                                <span className="title">hand </span>
                            </div>
                        )
                    }
                    <div className={`discard-pile pile  ${this.player.deckclass}`}>
                        <span className="card-count">{this.player.discard_pile.length}</span>
                        <span className="title">discard </span>
                    </div>

                    <div className={`player-data `}>
                        <span className="title">{this.player.name}</span>
                    </div>

                    <div className={`deck-pile pile ${this.player.deckclass}`}>
                        <span className="card-count">{this.player.deck_pile.length}</span>
                        <span className="title">Deck </span>
                    </div>


                </div>

                {handClass.length > 0 && (
                    <div className="row">
                        <div className={`hand-pile hand  ${this.player.deckclass} ${handClass}`}>
                             <span className="title">hand </span>
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
