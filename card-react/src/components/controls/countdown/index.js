import React from "react";
import './index.css';

class CountDown extends React.Component {
  constructor(props) {
    super(props);
    this.state = { seconds: 30 }

    this.tick();
  }

  tick = () => {
    this.timeHandler = setInterval(async () => {
      //debugger;
      let seconds = this.state.seconds - 1;
      if (seconds < 0)
        seconds = 30;
      await this.setState({ seconds: seconds });

    }, 1000);
  }

  componentWillUnmount(){
    clearInterval(this.timeHandler);
  }


  render() {
    return (
      <div class='d-flex flex-column timer-wrapper'>
        <p className="h7">Time Remaining: {this.state.seconds} seconds</p>
        <span className="span-border-bottom"></span>
        <div className="hour-glass">
          <div className="glass"></div>
          <div className="sand-stream"></div>
          <div className="top-sand"></div>
          <div className="bottom-sand"></div>
        </div>

      </div>

    )
  }
};

export default CountDown;