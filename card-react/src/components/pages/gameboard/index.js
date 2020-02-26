import React, { Component } from 'react'
import { connect } from 'react-redux'

export class Board extends Component {
    render() {
        return (
            <div>
                Welcome to game board
            </div>
        )
    }
}

const mapStateToProps = (state) => ({
    
})

const mapDispatchToProps = {
    
}

export default connect(mapStateToProps, mapDispatchToProps)(Board)
