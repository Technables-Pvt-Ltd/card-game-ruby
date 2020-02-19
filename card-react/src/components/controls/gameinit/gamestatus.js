import React, { Component } from 'react'
import { connect } from 'react-redux';

let GameStatus = (props) => {

    //render() {
    return (

        <div className="game-room">
            <div className="row room-header">
                <span>Room ID: {this.props.roomID}</span>
            </div>
        </div>
    )
    //}
}

function mapStateToProps(state) {
    return { state };
}

GameStatus = connect(mapStateToProps)(GameStatus);

export default GameStatus;