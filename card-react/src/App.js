import React, { Suspense } from 'react';
import logo from './logo.svg';
import './App.css';
import { connect } from 'react-redux';
import { Switch, Route } from 'react-router-dom';
import Aux from './hoc/_Aux';
import LazyLoader from './components/controls/lazyloader'
import { ToastContainer } from 'react-toastify'

function App() {
  return (
    <Aux>
      <Suspense fallback={<LazyLoader />}>
        <Switch>
          <React.Fragment>
            <div className="container">
              <div class="logo-wrapper">
                <img src={logo} className="logo" alt="Dungeon Myehm" />
              </div>

              <ToastContainer />
            </div>
          </React.Fragment>
        </Switch>
      </Suspense>
    </Aux>
  );
}

export default App;
