import React, { Component } from 'react'
import { compose } from 'redux'
import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'
import Logo from '../../../logo.jpg';
import './index.css'
import { ROUTE_SITE_ROOT } from '../../../data/constants/routes';
export class Header extends Component {

    logoClick = () => {
        this.props.history.push(ROUTE_SITE_ROOT);

    }
    render() {
        return (
            <div className="logo-wrapper d-flex">
                <div className="row d-flex flex-row">
                    <div className="logo-container col-3">
                        <img
                            className="logo"
                            src={Logo}
                            onClick={this.logoClick}
                            alt="Dungeon Mayhem"
                        />
                        
                    </div>
                    <div className=" col-9">
                            <p className="h3">Dungeon Mayhem</p>
                            {/* <small className="text-muted">Play the popular Dragon game built with react and ruby on rails</small> */}

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
