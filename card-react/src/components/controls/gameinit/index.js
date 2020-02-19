import React, { Component } from 'react'
import { connect } from 'react-redux';
import './index.css';
import PubNubReact from 'pubnub-react'
import Swal from 'sweetalert2'
import shortid from 'shortid'
import { PUBNUB_PUBLISH_KEY, PUBNUB_SUBSCRIBE_KEY } from '../../../data/constants/pubnub';
import { gameactionlist } from '../../../data/actionlist';
import { GetRandom } from '../../../data/helper';
import GameStatus from './gamestatus'

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

        this.setState({ cardgame: this.props.cardgame });
        this.pubnub.init(this);
    }

    onPressCreate = async (e) => {
        const roomId = shortid.generate().substring(0, 6);
        const lobbyChannel = 'dungeonmayhem-lobby--' + roomId;

        this.pubnub.subscribe({
            channels: [lobbyChannel],
            withPresence: true
        });

        const decks = [
            { id: 1, name: "Barbarian" },
            { id: 2, name: "Paladin" },
            { id: 3, name: "Rogue" },
            { id: 4, name: "Wizard" },

        ]

        const firstDeck = GetRandom(decks);

        //var response =
        //get available decks

        const cardHtmlArray = decks.reduce(function (newCards, card) {
            let cardHtml = `<div class='span-card-wrapper'><span class='spn-card-title'>${card.name} </span></div>`
            newCards.push({ id: card.id, cardHtml: cardHtml });
            return newCards;
        }, []);


        const inputOptions = new Map
        cardHtmlArray.forEach(item => inputOptions.set(item.id, item.cardHtml));
        let deckID = null;
        await Swal.fire({
            title: '<strong>Choose Your Deck</strong>',
            input: 'radio',
            inputOptions: inputOptions,
            inputValue: firstDeck.id,
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

                deckID = result.value;

            }

        });

        if (deckID) {
            //set roomid to reducer
            //set deckid
            //show confirmation form

            let swalHtml = ` <div className="game-room">
                                <div className="row room-header">
                                    <span>Room ID: ${roomId}</span>
                                </div>
                                <div class="room-deck-container>
                                    <span class="deck-title">Decks: </span>
                                    <ul class='list-group>
                                        <li class='list-group-item>1. </li>
                                    </ul>
                                </div>
                            </div>`;


            Swal.fire({
                title: `Your game room is created.`,
                icon: 'success',
                html: swalHtml,
                text: roomId,
                position: 'top-center',
                allowOutsideClick: false,
                showConfirmButton: false,

            });
        }


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
