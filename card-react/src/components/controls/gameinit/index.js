import React, { Component } from 'react'
import { connect } from 'react-redux';
import './index.css';
import PubNubReact from 'pubnub-react'
import Swal from 'sweetalert2'
import shortid from 'shortid'
import { PUBNUB_PUBLISH_KEY, PUBNUB_SUBSCRIBE_KEY } from '../../../data/constants/pubnub';
import { gameactionlist } from '../../../data/actionlist';
import { GetRandom } from '../../../data/helper';
import { PUBNUB_JOIN, PUBNUB_DECKSELECT } from '../../../data/constants/pubnub_messagetype';

export class GameInit extends Component {

    constructor(props) {
        super(props);

        this.initPubNub();
        this.roomId = null;
        this.lobbyChannel = null;

        this.gameChannel = null;

        // this.state = { cardgame: this.props.cardgame };



    }

    initPubNub = () => {
        this.pubnub = new PubNubReact({
            publishKey: PUBNUB_PUBLISH_KEY,
            subscribeKey: PUBNUB_SUBSCRIBE_KEY
        });
        this.state = {

        }
        this.pubnub.init(this);
    }

    componentWillUnmount() {
        this.pubnub.unsubscribe({
            channels: [this.lobbyChannel, this.gameChannel]
        });
    }

    componentDidUpdate() {
        //this.pubnub.subscribe({ channels: [this.lobbyChannel], withPresence: true });
        //debugger;
        if (this.lobbyChannel !== null) {
            this.pubnub.hereNow({
                channels: [this.lobbyChannel]
            }).then((response) => {
                console.log(response);
            });

            this.pubnub.getMessage(this.lobbyChannel, msg => {
                this.pubnub.hereNow({
                    channels: [this.lobbyChannel]
                }).then((response) => {
                    alert(response.totalOccupancy);
                });
                this.handlePubNubMessage(msg.message);
            });
        }


    }


    handlePubNubMessage = (msg) => {
        switch (msg.type) {
            case PUBNUB_JOIN:
                this.gameChannel = 'dungeonmayhem-game--' + this.roomId;

                this.pubnub.subscribe({
                    channels: [this.gameChannel]

                });
                break;
            case PUBNUB_DECKSELECT:
                this.displayRoomStatusModal(this.roomId, msg.isRoomCreator);
                break;
            default:
                break;
        }
    }

    onPressCreate = async (e) => {

        this.roomId = shortid.generate().substring(0, 6);
        this.lobbyChannel = 'dungeonmayhem-lobby--' + this.roomId;


        this.pubnub.subscribe({
            channels: [this.lobbyChannel],
            withPresence: true
        });

        //this.pubnub.publish({message: 'namaste',channel: this.lobbyChannel});

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


        const inputOptions = new Map()
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
            debugger;
            this.pubnub.publish({
                message: {
                    notRoomCreator: false,
                    type: PUBNUB_JOIN
                },
                channel: this.lobbyChannel
            });
            this.setState({ isRoomCreator: true })
            this.displayRoomStatusModal(this.roomId, true);

        }


        const { dispatch } = this.props;


        dispatch(gameactionlist.pubnubint({
            roomId: this.roomId, lobbyChannel: this.lobbyChannel
        }));

    }

    onPressJoin = async (e) => {
        Swal.fire({
            title: '<strong>Join the game room</strong>',
            position: 'top-center',
            input: 'text',
            allowOutsideClick: false,
            inputPlaceholder: 'enter the room id',
            showCancelButton: true,
            confirmButtonText: 'JOIN',
            customClass: {
                heightAuto: false,
                popup: 'popup-class',
                confirmButton: 'join-button-class ',
                cancelButton: 'join-button-class'
            }
        }).then((result) => {
            // Check if the user typed a value in the input field
            if (result.value) {
                this.joinRoom(result.value);
            }
        })
    }

    subscribeChannel = (channel) => {
        this.pubnub.subscribe({
            channels: [channel],
            withPresence: true
        });
    }

    joinRoom = async (value) => {
        this.roomId = value;


        this.lobbyChannel = 'dungeonmayhem-lobby--' + this.roomId;



        // Check the number of people in the channel
        this.pubnub.hereNow({
            channels: [this.lobbyChannel],
        }).then((response) => {
            if (response.totalOccupancy < 4) {

                this.subscribeChannel(this.lobbyChannel);


                this.showChooseDeckOption();
                this.setState({ isRoomCreator: false })
                this.pubnub.publish({
                    message: {
                        notRoomCreator: true,
                        type: PUBNUB_JOIN
                    },
                    channel: this.lobbyChannel
                });
            }
            else {
                // Game in progress
                Swal.fire({
                    position: 'top',
                    allowOutsideClick: false,
                    title: 'Error',
                    text: 'Game in progress. Try another room.',
                    width: 275,
                    padding: '0.7em',
                    customClass: {
                        heightAuto: false,
                        title: 'title-class',
                        popup: 'popup-class',
                        confirmButton: 'button-class'
                    }
                })
            }
        }).catch((error) => {
            debugger;
            console.log(error);
        });
    }

    showChooseDeckOption = async () => {
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


        const inputOptions = new Map()
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
            this.displayRoomStatusModal(this.roomId, false);
            this.pubnub.publish({
                message: {
                    notRoomCreator: true,
                    type: PUBNUB_DECKSELECT
                },
                channel: this.lobbyChannel
            },
                (status, response) => {
                    debugger;
                });
                this.setState({ isDeckSelcted: true })
        }
    }


    displayRoomStatusModal = (roomId, isRoomCreator) => {

        let swalHtml = ` <div className="game-room">
                                <div className="row room-header">
                                    <span class='font-weight-bold'>Room ID: ${roomId}</span>
                                </div>
                                <div class="room-deck-container row">
                                    <span class="deck-title col-12 text-left">Decks: </span>
                                    <ul class='list-group list-group-flush text-left'>
                                        <li class='list-group-item '>
                                            <div class='game-status-list-item'>
                                                <span> 1. Barbariain </span>
                                                <i class="fa fa-check success"></i>
                                            </div>
                                        </li>
                                        <li class='list-group-item '>
                                            <div class='game-status-list-item'>
                                                <span> 2. Paladin </span>
                                                <i class="fa fa-question ${isRoomCreator === true ? 'pending' : 'success'}"></i>
                                            </div>
                                        </li>
                                        <li class='list-group-item '>
                                            <div class='game-status-list-item'>
                                                <span> 3. Rogue </span>
                                                <i class="fa fa-question pending"></i>
                                            </div>
                                        </li>
                                        <li class='list-group-item '>
                                            <div class='game-status-list-item'>
                                                <span> 4. Wizard </span>
                                                <i class="fa fa-question pending"></i>
                                            </div>
                                        </li>
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

    render() {
        return (
            <div className="game-container">
                <span className="title h4">Let's Play</span>
                <div className='card-game-wrapper'>
                    <button className="btn btn-primary  btnSubmit" onClick={(e) => this.onPressCreate()}> Create Game</button>
                    <button className="btn btn-info btnSubmit" onClick={(e) => this.onPressJoin()}> Join Game</button>
                </div>
            </div>
        )
    }
}

const mapStateToProps = (state) => {
    return state;
};



export default connect(mapStateToProps)(GameInit)
