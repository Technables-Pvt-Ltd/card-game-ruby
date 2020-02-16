import React, { Component } from 'react'
import { compose } from 'redux'
import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'
import Logo from '../../../logo.jpg';
import './index.css'
export class Header extends Component {
    render() {
        return (
            <div className="logo-wrapper flex">
                <div className="row">
                    <div className="col-8 logo-container">
                        <img
                            className="logo"
                            src={Logo}
                            alt="Dungeon Mayhem"
                        />
                      
                    </div>
                </div>

            </div>
        )
    }
}

const mapStateToProps = (state) => ({

})


Header = compose(withRouter, connect(mapStateToProps))(Header);

export default Header;
