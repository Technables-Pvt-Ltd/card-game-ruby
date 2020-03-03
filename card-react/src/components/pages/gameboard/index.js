import React, { Component } from "react";
import { connect } from "react-redux";
import { gameactionlist } from "../../../data/actionlist";
import Swal from "sweetalert2";
import Aux from "../../../hoc/_Aux";
import { GetUserData, GetRandom } from "../../../data/helper";
import "./index.css";
import GamePlayer from "../../controls/gameplayer";
import PlayerCard from "../../controls/gameplayer/playercard";
import { Card_Game_Initials } from "../../../data/constants/constants";
import PubNubReact from "pubnub-react";
import {
  PUBNUB_PUBLISH_KEY,
  PUBNUB_SUBSCRIBE_KEY
} from "../../../data/constants/pubnub";
import {
  PUBNUB_MESSAGE_BROADCAST,
  PUBNUB_THROW_CARD,
  PUBNUB_APPLY_CARD
} from "../../../data/constants/pubnub_messagetype";
import { ShowMessage } from "../../../data/message/showMessage";

export class Board extends Component {
  constructor(props) {
    super(props);

    this.initPubNub();
    const { match } = this.props;
    const { gamecode } = match.params;
    this.roomId = gamecode;
    this.player = null;
    this.gameChannel = Card_Game_Initials + gamecode;
    this.subscribeChannel(this.gameChannel);
  }

  initPubNub = () => {
    this.pubnub = new PubNubReact({
      publishKey: PUBNUB_PUBLISH_KEY,
      subscribeKey: PUBNUB_SUBSCRIBE_KEY
    });
    this.state = {};
    this.pubnub.init(this);
  };

  handleCardClick = async (cardid, playerid) => {
    let paramObj = {
      cardid: cardid,
      playerid: playerid
    };

    let result = await gameactionlist.throwcard(paramObj);
    let response = result.data.result;

    if (response.updated === true) {
      this.pubnub.publish(
        {
          message: {
            type: PUBNUB_THROW_CARD,
            data: { updated: response.updated }
          },
          channel: this.gameChannel
        },
        (status, response) => {}
      );

      this.timeout = setTimeout(() => {
       
       }, 3000);

      if (response.can_attack === true) {
        ////show opponents
        const opponents = response.opponent_data;
        const opponentHtmlArray = await opponents.reduce(function(
          newOpponents,
          opponent
        ) {
          let opponentHtml = `<div class='span-card-wrapper ${opponent.deckclass} d-flex flex-column align-items-center justify-content-between'>
                                           
                                           <span class='spn-card-title'>${opponent.name} </span>
                                           <div> <span class='health-title'>Health: ${opponent.health}</span>
                                            <span class='health-title'>Defense: ${opponent.card_health}</span></div>
                                            
                                        </div>`;
          newOpponents.push({
            id: opponent.playerid,
            opponentHtml: opponentHtml
          });
          return newOpponents;
        },
        []);

        const inputOptions = new Map();
        opponentHtmlArray.forEach(item =>
          inputOptions.set(item.id, item.opponentHtml)
        );

        const randomSelected = GetRandom(opponentHtmlArray);

        let targetid = null;
        await Swal.fire({
          title: "<strong>Choose Your Target</strong>",
          input: "radio",
          inputOptions: inputOptions,
          allowOutsideClick: false,
          inputValue: randomSelected.id,
          inputValidator: function(value) {
            return new Promise(function(resolve, reject) {
              if (value !== "") {
                resolve();
              } else {
                resolve("You need to select a target");
              }
            });
          },
          focusConfirm: false,
          confirmButtonText: "Select"
        }).then(result => {
          if (result.value) {
            targetid = result.value;
          }
        });

        if (targetid) {
          let requestObj = {
            cardid: cardid,
            playerid: playerid,
            targetid: targetid
          };

          this.applycardeffect(requestObj, cardid);
        }
      } else {
        let requestObj = {
          cardid: cardid,
          playerid: playerid,
          targetid: null
        };
        this.applycardeffect(requestObj, cardid);
      }

      clearTimeout(this.timeout);
    }
  };

  applycardeffect = async (paramobj, cardid) => {
    let applyResult = await gameactionlist.applycardeffect(paramobj);
    let applyResponse = applyResult.data.result;
    if (applyResponse.updated === true) {
      this.pubnub.publish(
        {
          message: {
            type: PUBNUB_APPLY_CARD,
            data: { updated: applyResponse.updated }
          },
          channel: this.gameChannel
        },
        (status, response) => {}
      );
      this.setState({ cardid: cardid });
    } else {
      Swal.fire({
        icon: "error",
        title: "Oops...",
        text: applyResponse.error
      });
    }
  };

  subscribeChannel = channel => {
    this.pubnub.subscribe({
      channels: [channel],
      withPresence: true
    });
  };

  componentDidUpdate() {
    if (this.gameChannel !== null) {
      this.pubnub.getMessage(this.gameChannel, msg => {
        this.handlePubNubMessage(msg.message);
      });
    }
  }

  handlePubNubMessage = msg => {
    if (msg.type) {
      switch (msg.type) {
        case PUBNUB_THROW_CARD:
          this.throwcard(msg.data.updated);
          break;
        case PUBNUB_APPLY_CARD:
          this.throwcard(msg.data.updated);
          break;

        case PUBNUB_MESSAGE_BROADCAST:
          ShowMessage(msg.message.type, msg.message.data);
          break;
        default:
          break;
      }
    }
  };

  throwcard = async updated => {
    if (updated === true) {
      await this.getGameData(false);
      //this.setState({ cardthrown: true });
    }
  };

  componentDidMount = async () => {
    // if (this.gameChannel !== null) {
    //     this.pubnub.getMessage(this.gameChannel, msg => {
    //         this.handlePubNubMessage(msg.message);
    //     });
    // }
    await this.getGameData(true);
  };

  getGameData = async isFirstLoad => {
    let paramObj = {
      gamecode: this.roomId,
      isFirstLoad: isFirstLoad
    };
    let result = await gameactionlist.getgamedata(paramObj);
    let gameObj = result.gamedata;
    let proceed = gameObj.proceed;
    this.setState({ complete: gameObj.complete });
    if (!proceed) {
      Swal.fire({
        icon: "error",
        title: "Oops...",
        text: gameObj.error
      }).then(result => {
        if (result.value) {
          this.props.history.goBack();
        }
      });
    } else {
      if (gameObj.complete) {
        this.setState({ winnerdata: gameObj.data });
      } else {
        this.setState({
          tempPile: gameObj.temp_pile,
          players: gameObj.players
        });

        let players = gameObj.players;

        let topPlayer = null;
        let bottomPlayer = null;
        let rightPlayer = null;
        let leftPlayer = null;
        let currentPlayerIndex = 0;

        const userData = GetUserData();
        let userid = userData.userid;

        players.map((player, index) => {
          if (player.userid === userid) {
            currentPlayerIndex = index;
            this.player = player;
          }
        });

        let i = 0;
        while (i < players.length) {
          let player = players[(i + currentPlayerIndex) % players.length];
          debugger;
          switch (i) {
            case 0:
              bottomPlayer = player;
              bottomPlayer.positionClass = "bottom";
              break;
            case 2:
              topPlayer = player;
              topPlayer.positionClass = "top";
              break;
            case 3:
              rightPlayer = player;
              rightPlayer.positionClass = "right";
              break;
            case 1:
              leftPlayer = player;
              leftPlayer.positionClass = "left";
              break;
            default:
              break;
          }
          i++;
        }

        this.props.dispatch(
          gameactionlist.dispatchPlayerdata({
            roomId: this.roomId,
            lobbyChannel: this.lobbyChannel,
            isPlaying: true,
            isDisabled: true,
            topPlayer: topPlayer,
            bottomPlayer: bottomPlayer,
            leftPlayer: leftPlayer,
            rightPlayer: rightPlayer
          })
        );

        // this.setState({ isPlaying: true })
      }
    }
  };

  getPlayerCard = async playerid => {
    let paramObj = {
      playerid: playerid
    };
  };

  onHomeClick = () => {
    this.props.history.goBack();
  };

  render() {
    const winnerdata = this.state.winnerdata;
    const {
      topPlayer,
      bottomPlayer,
      leftPlayer,
      rightPlayer
    } = this.props.cardgame;
    let tempPile = this.state.tempPile;
    //if (this.props.cardgame.bottomPlayer) alert(this.props.cardgame.bottomPlayer.hand_pile.length);
    return (
      <Aux>
        {this.state.complete && winnerdata && (
          <div className="container d-flex justify-content-center">
            <div className="card col-4 align-self-center text-center">
              <div className="card-header ">
                <h5 className="my-0">Game: {this.roomId}</h5>
                <small className="text-muted">This game has ended</small>
              </div>
              <div className="card-body col-12">
                <h5 className="my-0 text-uppercase">Winner</h5>
                <div className={`${winnerdata.winner.deckclass} winner-card `}>
                  <span>{winnerdata.winner.name}</span>
                </div>

                <span
                  className="btn  btn-block btn-primary"
                  onClick={this.onHomeClick}
                >
                  Go to Home
                </span>
              </div>
            </div>
          </div>
        )}
        {!this.state.complete && bottomPlayer && (
          <div>
            <div className="row player-row">
              <div className="col-3"></div>
              <div className="col-6 text-center">
                {topPlayer && <GamePlayer player={topPlayer} />}
              </div>
              <div className="col-3"></div>
            </div>

            <div className="row player-row">
              <div className="col-3 text-right">
                {leftPlayer && <GamePlayer player={leftPlayer} />}
              </div>
              <div className="col-6 text-center">
                <div className="game-board">
                  <div className="row align-items-center">
                    <div className="col-4 ">
                      <div className="board-container left">
                        {leftPlayer && (
                          <div className={`temp-pile `}>
                            {leftPlayer.active_pile.map((card, index) => {
                              return (
                                <PlayerCard
                                  key={card.cardid}
                                  card={card}
                                  activecard={true}
                                  deckclass={card.deckclass}
                                  clicked={false}
                                  handleCardClick={null}
                                />
                              );
                            })}
                          </div>
                        )}
                      </div>
                    </div>
                    <div className="col-4 d-flex flex-column align-items-center ">
                      <div className="">
                        <div className="board-container top">
                          {topPlayer && (
                            <div className={`temp-pile `}>
                              {topPlayer.active_pile.map((card, index) => {
                                return (
                                  <PlayerCard
                                    key={card.cardid}
                                    card={card}
                                    activecard={true}
                                    deckclass={card.deckclass}
                                    clicked={false}
                                    handleCardClick={null}
                                  />
                                );
                              })}
                            </div>
                          )}
                        </div>
                      </div>
                      <div className="board-container center">
                        {tempPile && (
                          <div className={`temp-pile `}>
                            {tempPile.map((card, index) => {
                              return (
                                <PlayerCard
                                  key={card.cardid}
                                  card={card}
                                  deckclass={card.deckclass}
                                  clicked={false}
                                  handleCardClick={null}
                                />
                              );
                            })}
                          </div>
                        )}
                      </div>
                      <div className=" ">
                        <div className="board-container bottom">
                          {bottomPlayer && (
                            <div className={`temp-pile `}>
                              {bottomPlayer.active_pile.map((card, index) => {
                                return (
                                  <PlayerCard
                                    key={card.cardid}
                                    card={card}
                                    activecard={true}
                                    deckclass={card.deckclass}
                                    clicked={false}
                                    handleCardClick={null}
                                  />
                                );
                              })}
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                    <div className="col-4 d-flex justify-content-end">
                      <div className="board-container right">
                        {rightPlayer && (
                          <div className={`temp-pile `}>
                            {rightPlayer.active_pile.map((card, index) => {
                              return (
                                <PlayerCard
                                  key={card.cardid}
                                  card={card}
                                  activecard={true}
                                  deckclass={card.deckclass}
                                  clicked={false}
                                  handleCardClick={null}
                                />
                              );
                            })}
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div className="col-3 text-left">
                {rightPlayer && <GamePlayer player={rightPlayer} />}
              </div>
            </div>

            <div className="row player-row">
              <div className="col-3"></div>
              <div className="col-6 text-center">
                {bottomPlayer && (
                  <GamePlayer
                    player={bottomPlayer}
                    gamecode={this.props.cardgame.roomId}
                    handleCardClickMaster={this.handleCardClick}
                  />
                )}
              </div>
              <div className="col-3"></div>
            </div>
          </div>
        )}
      </Aux>
    );
  }
}

const mapStateToProps = state => {
  return state;
};

export default connect(mapStateToProps)(Board);
