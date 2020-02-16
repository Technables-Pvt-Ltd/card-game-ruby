import React, { Component } from 'react'
import { connect } from 'react-redux'

export class GameInit extends Component {
    render() {
        return (
            <div className="game-container">
                <span className="title h4">Let's Play</span>
                <div className='card-game-wrapper'>
                    <button className="btn btn-primary  btnSubmit"> Create Game</button>
                    <button className="btn btn-info btnSubmit"> Join Game</button>
                </div>
            </div>
        )
    }
}

const mapStateToProps = (state) => ({

})

const mapDispatchToProps = {

}

export default connect(mapStateToProps, mapDispatchToProps)(GameInit)
