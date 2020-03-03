import React, { Component } from 'react'
import { compose } from 'redux'
import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'
import Logo from '../../../logo.jpg';
import './index.css'
import { ROUTE_SITE_ROOT } from '../../../data/constants/routes';
export class Header extends Component {
    constructor(props) {
        super(props);
    }
    logoClick = () => {
        //debugger;
        //if (this.props.history.canGoBack)
            this.props.history.goBack();
        
    }
    render() {
        return (
            <div className="logo-wrapper flex">
                <div className="row">
                    <div className="col-8 logo-container">
                        <img
                            className="logo"
                            src={Logo}
                            onClick={this.logoClick}
                            alt="Dungeon Mayhem"
                        />

                    </div>
                </div>

            </div>
        )
    }
}

const mapStateToProps = (state) => {
    return state;
}


Header = compose(withRouter, connect(mapStateToProps))(Header);

export default Header;
