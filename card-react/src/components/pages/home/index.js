import React, { Component } from 'react'
import { connect } from 'react-redux'
import Aux from '../../../hoc/_Aux';
import './index.css'
import GameInit from '../../controls/gameinit'
import GameInfo from '../../controls/gameinfo'
import GameGuides from '../../controls/gamesymbols/gameguides'


export class Home extends Component {

    render() {
        return (
            <Aux>
                <div className="vh-100 primary-color sfFormWrapper">
                    <div className="info-container">
                       
                        <div className="card-info">
                            <p>
                                Dungeon Mayhem™ is a free-for-all battle for two to four players. Be the last player left standing and you win!
                            </p>
                            <p>
                                Play as one of four brave, quirky Sutha, Azzan, Lia, or Oriax —battling it out in a dungeon full of treasure!  Each character’s tricks, gear, and skills are represented by a deck of cards.
                            </p>

                        </div>
                        <div className="row">

                            <div className="col-8">
                                <GameInfo />
                            </div>
                            <div className="col-4 d-flex flex-column ">
                                <GameInit history={this.props.history} />
                                <GameGuides />
                            </div>
                        </div>
                    </div>
                </div>
            </Aux>

        )
    }
}

const mapStateToProps = (state) => {
    return state;
}


export default connect(mapStateToProps)(Home)
