import React, { Component } from 'react'
import { connect } from 'react-redux'

export class Home extends Component {
    render() {
        return (
            <Aux>
                <div>
                    welcome to home
                </div>
            </Aux>

        )
    }
}

const mapStateToProps = (state) => ({

})

const mapDispatchToProps = {

}

export default connect(mapStateToProps, mapDispatchToProps)(Home)
