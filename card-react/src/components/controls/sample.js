import React, { Component } from "react";
import { PUBNUB_PUBLISH_KEY, PUBNUB_SUBSCRIBE_KEY } from "../../data/constants/pubnub";

import PubNubReact from 'pubnub-react'

class Sample extends Component {
    constructor(props) {
        super(props);
        this.pubnub = new PubNubReact({
            publishKey: PUBNUB_PUBLISH_KEY,
            subscribeKey: PUBNUB_SUBSCRIBE_KEY
        });
        this.state = {}
        this.pubnub.init(this);

    }

    componentWillMount() {
        this.pubnub.subscribe({ channels: ['channel1'], withPresence: true });

        this.pubnub.hereNow({
            channels: ['channel1'],
        }).then((response) => {
            debugger;
            this.setState({ occupancy: response.totalOccupancy })
        });

        this.pubnub.getMessage('channel1', message => {
            alert(1);
            this.setState({ message: message.message })
        })

        this.pubnub.getStatus((st) => {
            this.pubnub.publish({ message: 'world', channel: 'channel1' });
        })
    }

    onButtonClick = () => {
        this.pubnub.publish({ message: 'namaste', channel: 'channel1' });
    }

    componentWillUnmount() {
        this.pubnub.unsubscribe({ channels: ['channel1'] })
    }

    render() {
        return (<div> <div className="title">Hello  {this.state.message}</div>
            <span className='btn btn-primary' onClick={this.onButtonClick} />
        </div>)
    }
}

export default Sample;