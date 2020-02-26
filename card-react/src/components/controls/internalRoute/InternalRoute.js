import React from 'react'
import { Route, Redirect } from 'react-router-dom'

import { ROUTE_SITE_ROOT } from '../../../data/constants/routes'
import { GetUserData } from '../../../data/helper';

function InternalRoute({ component: Component, ...rest }) {
    const userData = GetUserData()
    return (
        <Route
            {...rest}
            render={props =>
                userData && userData.userid && userData.userid.length > 0 ? (
                    <Component {...props} />
                ) : (
                        <Redirect
                            to={{
                                pathname: ROUTE_SITE_ROOT,
                                state: {
                                    from: props.location
                                },
                                children: props.children
                            }}
                        />
                    )
            }
        />
    );
}

export default InternalRoute;