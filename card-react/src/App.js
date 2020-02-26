import React, { Suspense } from 'react';
import './App.css';
import { connect } from 'react-redux';
import { Switch, Route } from 'react-router-dom';
import Aux from './hoc/_Aux';
import LazyLoader from './components/controls/lazyloader'
import { ToastContainer } from 'react-toastify'
import 'react-toastify/dist/ReactToastify.css';


import Header from './components/controls/header'
import { defaultRoute, InternalRoutes } from './routes';
import InternalRoute from './components/controls/internalRoute/InternalRoute'



class App extends React.Component {
  render() {

    const dRoute = defaultRoute.map((route, index) => {
      return route.component ? (
        <Route
          key={index}
          path={route.path}
          exact={route.exact}
          name={route.name}
          render={props => <route.component {...props} />}
        />
      ) : null;
    });

    const iRoutes = InternalRoutes.map((route, index) => {
      return route.component ? (
        <InternalRoute
          key={index}
          path={route.path}
          exact={route.exact}
          name={route.name}
          component={route.component}
        />
      ) : null;
    });

    return (
      <Aux>
        <Suspense fallback={<LazyLoader />}>
          <Switch>
            <React.Fragment>
              <div className="container">
                <Header />
                
                {dRoute}
                {iRoutes}
                <ToastContainer />
              </div>
            </React.Fragment>
          </Switch>
        </Suspense>
      </Aux>
    );
  }
}

const mapStateToProps = state => {
  return {

  }
}

App = connect(mapStateToProps)(App);

export default App;
