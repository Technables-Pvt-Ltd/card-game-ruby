import React, { Suspense } from 'react';
import './App.css';
import { connect } from 'react-redux';
import { Switch, Route } from 'react-router-dom';
import Aux from './hoc/_Aux';
import LazyLoader from './components/controls/lazyloader'
import { ToastContainer } from 'react-toastify'

import Header from './components/controls/header'
import { defaultRoute } from './routes';
import Sample from './components/controls/sample'



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
    })

    return (
      <Aux>
        <Suspense fallback={<LazyLoader />}>
          <Switch>
            <React.Fragment>
              <div className="container">
                <Header />
                <Sample/>
                {dRoute}
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
