import React, { Component } from "react";
import { connect } from "react-redux";
import "./index.css";
import PubNubReact from "pubnub-react";
import Swal from "sweetalert2";
import shortid from "shortid";
import {
  PUBNUB_PUBLISH_KEY,
  PUBNUB_SUBSCRIBE_KEY
} from "../../../data/constants/pubnub";
import { gameactionlist } from "../../../data/actionlist";
import { GetRandom, GetUserData } from "../../../data/helper";
import {
  PUBNUB_JOIN,
  PUBNUB_DECKSELECT,
  PUBNUB_MESSAGE_BROADCAST,
  PUBNUB_DECKLEAVE,
  PUBNUB_GAMECLOSE
} from "../../../data/constants/pubnub_messagetype";
import { TOAST_SUCCESS } from "../../../data/constants/toastmessagetype";
import { ShowMessage } from "../../../data/message/showMessage";
import {
  Card_Lobby_Initials,
  Card_Game_Initials
} from "../../../data/constants/constants";

export class GameInit extends Component {
  constructor(props) {
    super(props);

    this.initPubNub();
    this.roomId = null;
    this.lobbyChannel = null;
    this.gameChannel = null;
    this.masterdeck = [];
    this.getDeckMasterList();
    //this.setState({masterdeck: []});
    //  this.state = { masterdeck: [] };
  }

  initPubNub = () => {
    this.pubnub = new PubNubReact({
      publishKey: PUBNUB_PUBLISH_KEY,
      subscribeKey: PUBNUB_SUBSCRIBE_KEY
    });
    this.state = {};
    this.pubnub.init(this);
  };

  componentWillUnmount() {
    this.unsubscribe();
  }

  componentDidUpdate() {
    if (this.lobbyChannel !== null) {
      this.pubnub.getMessage(this.lobbyChannel, msg => {
        this.handlePubNubMessage(msg.message);
      });
    }
  }

  unsubscribe = () => {
    this.pubnub.unsubscribe({
      channels: [this.lobbyChannel, this.gameChannel]
    });

    this.lobbyChannel = null;
    this.gameChannel = null;
  };

  subscribeChannel = channel => {
    this.pubnub.subscribe({
      channels: [channel],
      withPresence: true
    });
  };

  publishMessage = (channel, msg) => {
    this.pubnub.publish({
      message: msg,
      channel: channel
    });

    //this.setState({ publishMsg: true });
  };

  generateMessageObj = (type, msg) => {
    return {
      type,
      message: msg
    };
  };

  handlePubNubMessage = msg => {
    let message = null;
    if (msg.type) {
      switch (msg.type) {
        case PUBNUB_JOIN:
          this.gameChannel = Card_Game_Initials + this.roomId;
          this.subscribeChannel(this.gameChannel);
          break;
        case PUBNUB_DECKSELECT:
          this.displayRoomStatusModal(this.roomId, msg.isRoomCreator);
           message = this.generateMessageObj(PUBNUB_MESSAGE_BROADCAST, {
            data: "New Player Joined",
            type: TOAST_SUCCESS
          });
          this.publishMessage(this.lobbyChannel, message);
          break;

        case PUBNUB_DECKLEAVE:
           message = this.generateMessageObj(PUBNUB_MESSAGE_BROADCAST, {
            data: "One Player Left",
            type: TOAST_SUCCESS
          });

          this.publishMessage(this.lobbyChannel, message);
          this.displayRoomStatusModal(this.roomId, false);
          break;

        case PUBNUB_GAMECLOSE:
           message = this.generateMessageObj(PUBNUB_MESSAGE_BROADCAST, {
            data: "Sorry!! Game was closed by admin",
            type: TOAST_SUCCESS
          });

          this.publishMessage(this.lobbyChannel, message);

          Swal.close();
          this.unsubscribe();
          break;

        case PUBNUB_MESSAGE_BROADCAST:
          ShowMessage(msg.message.type, msg.message.data);
          break;
        default:
          break;
      }
    }
  };

  showChooseDeckOption = async () => {
    const decks = await this.getDeckList(this.roomId);

    const deckHtmlArray = await decks.reduce(function (newDecks, deck) {
      if (!deck.isselected) {
        let deckHtml = `<div class='span-card-wrapper ${deck.deckclass}'><span class='spn-card-title'>${deck.name} </span></div>`;
        newDecks.push({ id: deck.id, deckHtml: deckHtml });
      }
      return newDecks;
    }, []);
    const firstDeck = GetRandom(deckHtmlArray);

    if (deckHtmlArray.length > 0) {
      const inputOptions = new Map();
      deckHtmlArray.forEach(item => inputOptions.set(item.id, item.deckHtml));
      let deckID = null;
      await Swal.fire({
        title: "<strong>Choose Your Deck</strong>",
        input: "radio",
        inputOptions: inputOptions,
        inputValue: firstDeck.id,
        inputValidator: function (value) {
          return new Promise(function (resolve, reject) {
            if (value !== "") {
              resolve();
            } else {
              resolve("You need to select a deck");
            }
          });
        },
        focusConfirm: false,
        confirmButtonText: "Select",
        showCancelButton: true
      }).then(result => {
        if (result.value) {
          deckID = result.value;
        } else if (result.dismiss === "cancel") {
          this.unsubscribe();
        }
      });
      if (deckID) {
        //this.displayRoomStatusModal(this.roomId, false);
        this.joinGame(this.roomId, deckID);

        this.setState({ isDeckSelcted: true, deckid: deckID });
      }
    }
  };

  displayRoomStatusModal = async (roomId, isRoomCreator) => {
    //let decks = data.decks;

    let decks = await this.getDeckList(roomId);
    let isSelectedCount = 0;
    let swalliData = "";
    //debugger;
    decks.map((deck, index) => {
      let extraClass = deck.isselected
        ? "fa fa-check success"
        : "fa fa-question pending";
        debugger;
      if (deck.isselected) isSelectedCount += 1;
      swalliData += `
                <li class='list-group-item ' key=${deck.id}>
                    <div class='game-status-list-item'>
                        <span> ${index + 1}. ${deck.name} </span>
                        <i class=' ${extraClass}'></i>
                    </div>
                </li> `;
    });

    let swalHtml = ` <div className="game-room">
                                <div className="row room-header">
                                    <span class='font-weight-bold'>Room ID: ${roomId}</span>
                                </div>
                                <div class="room-deck-container row">
                                    <span class="deck-title col-12 text-left">Decks: </span>
                                    <ul class='list-group list-group-flush text-left'>
                                       ${swalliData}
                                    </ul>
                                </div>
                            </div>`;

    Swal.fire({
      title: this.state.isRoomCreator
        ? `You have created a game.`
        : `You have joined the game`,
      icon: "success",
      html: swalHtml,
      text: roomId,
      position: "top-center",
      allowOutsideClick: false,
      showConfirmButton:
        this.state.isRoomCreator === true && isSelectedCount > 1,
      showCancelButton: true,
      cancelButtonText: this.state.isRoomCreator
        ? '<i class="fa fa-thumbs-down"></i>Close'
        : '<i class="fa fa-thumbs-down"></i> Leave',
      confirmButtonText: "Start Game",
      footer:
        this.state.isRoomCreator == true
          ? ""
          : "<span>Awaiting room creator confirmation</span>"
    }).then(result => {
      if (result.value) {
        //deckID = result.value;
        console.log(result.value);
      } else if (result.dismiss === "cancel") {
        if (this.state.isRoomCreator) {
          alert("close called");
          this.onGameClose(this.roomId);
        } else {
          alert("leave called");
          this.onGameLeave(this.roomId, this.state.deckid);
        }
      }
    });
  };

  getDeckMasterList = async () => {
    let paramObj = {};
    await gameactionlist.deckinit(paramObj, async result => {
      //if (result.success === true) {
      let deckList = result.deck;
      await this.setState({ masterdeck: deckList });
      //}
    });
  };

  getDeckList = async roomid => {
    let paramObj = { gameid: roomid };
    let decklist = await gameactionlist.decklist(paramObj);

    return decklist.data.deck;
  };

  getRandomDeck = async () => {
    const decks = this.state.masterdeck ? this.state.masterdeck : [];
    const firstDeck = GetRandom(decks);
    return firstDeck;
  };

  getDeckListHtml = async () => {
    const decks = this.state.masterdeck ? this.state.masterdeck : [];
    const cardHtmlArray = await decks.reduce(function (newCards, card) {
      let cardHtml = `<div class='span-card-wrapper ${card.deckclass}'><span class='spn-card-title'>${card.name} </span></div>`;
      newCards.push({ id: card.id, cardHtml: cardHtml });
      return newCards;
    }, []);

    const inputOptions = new Map();
    cardHtmlArray.forEach(item => inputOptions.set(item.id, item.cardHtml));
    return inputOptions;
  };

  onPressCreate = async e => {
    // await this.getDeckList();
    this.roomId = shortid.generate().substring(0, 6);
    this.lobbyChannel = Card_Lobby_Initials + this.roomId;

    this.subscribeChannel(this.lobbyChannel);
    const firstDeck = await this.getRandomDeck();
    let inputOptions = await this.getDeckListHtml();

    let deckID = null;
    await Swal.fire({
      title: "<strong>Choose Your Deck</strong>",
      input: "radio",
      inputOptions: inputOptions,
      inputValue: firstDeck.id,
      allowOutsideClick: false,
      inputValidator: function (value) {
        return new Promise(function (resolve, reject) {
          if (value !== "") {
            resolve();
          } else {
            resolve("You need to select a deck");
          }
        });
      },
      focusConfirm: false,
      confirmButtonText: "Select",
      showCancelButton: true
    }).then(result => {
      if (result.value) {
        deckID = result.value;
      }
    });

    if (deckID) {
      this.createGame(this.roomId, deckID);
    }

    // const { dispatch } = this.props;

    // dispatch(gameactionlist.pubnubint({
    //     roomId: this.roomId, lobbyChannel: this.lobbyChannel
    // }));
  };

  createGame = async (roomid, deckID) => {
    var userData = GetUserData();
    var userID = userData.userid;

    let paramObj = {
      userid: userID,
      gameid: roomid,
      deckid: deckID
    };

    await gameactionlist.gameinit(paramObj, async result => {
      let data = result.data;
      this.setState({ isRoomCreator: true, deckid: deckID });
      this.displayRoomStatusModal(this.roomId, true);
    });
  };

  joinGame = async (roomid, deckid) => {
    var userData = GetUserData();
    var userID = userData.userid;

    let paramObj = {
      userid: userID,
      gameid: roomid,
      deckid: deckid
    };

    let result = await gameactionlist.joingame(paramObj); //, async result => {
    let output = result.data.result;
    if (output.proceed === false) {
      Swal.fire({
        icon: "error",
        title: "Oops...",
        text: output.error
      });
    } else {
      let decks = output.decklist;
      this.setState({ isRoomCreator: false });
      this.displayRoomStatusModal(this.roomId, false);
      this.pubnub.publish(
        {
          message: {
            notRoomCreator: true,
            type: PUBNUB_DECKSELECT
          },
          channel: this.lobbyChannel
        },
        (status, response) => { }
      );
    }
    //});
  };

  onPressJoin = async e => {
    Swal.fire({
      title: "<strong>Join the game room</strong>",
      position: "top-center",
      input: "text",
      allowOutsideClick: false,
      inputPlaceholder: "enter the room id",
      showCancelButton: true,
      confirmButtonText: "JOIN",
      customClass: {
        heightAuto: false,
        popup: "popup-class",
        confirmButton: "join-button-class ",
        cancelButton: "join-button-class"
      }
    }).then(result => {
      // Check if the user typed a value in the input field
      if (result.value) {
        this.joinRoom(result.value);
      }
    });
  };

  joinRoom = async value => {
    this.roomId = value;

    this.lobbyChannel = Card_Lobby_Initials + this.roomId;

    // Check the number of people in the channel
    this.pubnub
      .hereNow({
        channels: [this.lobbyChannel]
      })
      .then(async response => {
        if (response.totalOccupancy < 4) {
          this.subscribeChannel(this.lobbyChannel);

          //   await  this.getDeckList(this.roomId);
          //   debugger;
          this.showChooseDeckOption();
        } else {
          // Game in progress
          Swal.fire({
            position: "top",
            allowOutsideClick: false,
            title: "Error",
            text: "Game in progress. Try another room.",
            width: 275,
            padding: "0.7em",
            customClass: {
              heightAuto: false,
              title: "title-class",
              popup: "popup-class",
              confirmButton: "button-class"
            }
          });
        }
      })
      .catch(error => {
        console.log(error);
      });
  };

  joinGame = async (roomid, deckid) => {
    var userData = GetUserData();
    var userID = userData.userid;

    let paramObj = {
      userid: userID,
      gameid: roomid,
      deckid: deckid
    };

    let result = await gameactionlist.joingame(paramObj); //, async result => {
    let output = result.data.result;
    if (output.proceed === false) {
      Swal.fire({
        icon: "error",
        title: "Oops...",
        text: output.error
      });
    } else {
      let decks = output.decklist;
      this.setState({ isRoomCreator: false });
      this.displayRoomStatusModal(this.roomId, false);
      this.pubnub.publish(
        {
          message: {
            notRoomCreator: true,
            type: PUBNUB_DECKSELECT
          },
          channel: this.lobbyChannel
        },
        (status, response) => { }
      );
    }
    //});
  };

  onGameLeave = async (roomId, deckid) => {
    alert(roomId, deckid);

    var userData = GetUserData();
    var userID = userData.userid;
    let paramObj = {
      userid: userID,
      gameid: roomId,
      deckid: deckid
    };

    let result = await gameactionlist.leavegame(paramObj); //, async result => {
    let output = result.data.result;
    if (output.proceed === false) {
      Swal.fire({
        icon: "error",
        title: "Oops...",
        text: output.error
      });

      this.displayRoomStatusModal(this.roomId, false);
    } else {
      this.setState({ deckid: "" });
      //this.displayRoomStatusModal(this.roomId, false);
      this.pubnub.publish(
        {
          message: {
            type: PUBNUB_DECKLEAVE
          },
          channel: this.lobbyChannel
        },
        (status, response) => {
          Swal.close();
          this.unsubscribe();
        }
      );
    }
    //this.unsubscribe();
  };

  onGameClose = async roomId => {
    var userData = GetUserData();
    var userID = userData.userid;
    let paramObj = {
      userid: userID,
      gameid: roomId
    };

    let result = await gameactionlist.closegame(paramObj); //, async result => {
    let output = result.data.result;
    if (output.proceed === false) {
      Swal.fire({
        icon: "error",
        title: "Oops...",
        text: output.error
      });
    } else {
      this.setState({ deckid: "" });
      //this.displayRoomStatusModal(this.roomId, false);
      this.pubnub.publish(
        {
          message: {
            type: PUBNUB_GAMECLOSE
          },
          channel: this.lobbyChannel
        },
        (status, response) => { }
      );
    }
  };

  render() {
    return (
      <div className="game-container">
        <span className="title h4">Let's Play</span>
        <div className="card-game-wrapper">
          <button
            className="btn btn-primary  btnSubmit"
            onClick={e => this.onPressCreate()}
          >
            {" "}
            Create Game
          </button>
          <button
            className="btn btn-info btnSubmit"
            onClick={e => this.onPressJoin()}
          >
            {" "}
            Join Game
          </button>
        </div>
      </div>
    );
  }
}

const mapStateToProps = state => {
  return state;
};

export default connect(mapStateToProps)(GameInit);
