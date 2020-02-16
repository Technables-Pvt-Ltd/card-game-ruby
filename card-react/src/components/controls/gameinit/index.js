import React, { Component } from 'react'
import { connect } from 'react-redux';
import './index.css';
import PubNubReact from 'pubnub-react'
import Swal from 'sweetalert2'
import shortid from 'shortid'
import { PUBNUB_PUBLISH_KEY, PUBNUB_SUBSCRIBE_KEY } from '../../../data/constants/pubnub';
import { gameactionlist } from '../../../data/actionlist';

export class GameInit extends Component {

    constructor(props) {
        super(props);
        this.initPubNub();

    }

    initPubNub = () => {
        this.pubnub = new PubNubReact({
            publishKey: PUBNUB_PUBLISH_KEY,
            subscribeKey: PUBNUB_SUBSCRIBE_KEY
        });

        this.state = this.props.cardgame;
        this.pubnub.init(this);
    }

    onPressCreate = async (e) => {
        const roomId = shortid.generate().substring(0, 6);
        const lobbyChannel = 'dungeonmayhem-lobby--' + roomId;

        this.pubnub.subscribe({
            channels: [lobbyChannel],
            withPresence: true
        });

        //var response =
        //get available decks
        const items = [
            { id: 4, name: "<span class='spn-class'>chandra </span>" },
            { id: 10, name: "dave" },
            { id: 2, name: "zac" },
        ]

        const inputOptions = new Map
        items.forEach(item => inputOptions.set(item.id, item.name))

        let deckID = null;
        await Swal.fire({
            title: '<strong>Choose Your Deck</strong>',
            input: 'radio',
            inputOptions: inputOptions,
            inputValue: 10,
            inputValidator: function (value) {
                return new Promise(function (resolve, reject) {
                    if (value !== '') {
                        resolve();
                    } else {
                        resolve('You need to select a deck');
                    }
                });
            },
            focusConfirm: false,
            confirmButtonText:
                'Select',
            showCancelButton: false
        }).then((result) => {
            if (result.value) {
                // Swal.fire({
                //     type: 'success',
                //     html: 'you selected: ' + result.value
                // });

                deckID = result.value;
            }

        });

        if (deckID)
            Swal.fire({ type: 'success', html: "You have selected: " + deckID });


        const { dispatch } = this.props;


        dispatch(gameactionlist.pubnubint({
            roomId, lobbyChannel
        }));


    }

    render() {
        return (
            <div className="game-container">
                <span className="title h4">Let's Play</span>
                <div className='card-game-wrapper'>
                    <button className="btn btn-primary  btnSubmit" onClick={(e) => this.onPressCreate()}> Create Game</button>
                    <button className="btn btn-info btnSubmit" > Join Game</button>
                </div>
            </div>
        )
    }
}

const mapStateToProps = (state) => {
    return state;
};



export default connect(mapStateToProps)(GameInit)
