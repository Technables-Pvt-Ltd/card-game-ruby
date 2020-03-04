import React, { Component } from 'react'

export default class GameInfo extends Component {
    render() {
        return (
            <div>
                <p> Here are some instructions/rules associated with the game.</p>
                <ul className="list-group card-instructions">
                    <li className="list-group-item">1. Create a game or Join a game that hasn't started</li>
                    <li className="list-group-item">2. As a player joins a Game, they select a Deck</li>
                    <li className="list-group-item">3. 4 players can participate in a game.</li>
                    <li className="list-group-item">4. Once player count is at least 2, user can start the game</li>
                    <li className="list-group-item">5. At the start of game:
                                        <ul className="list-group list-group-flush">
                            <li className="list-group-item">a. the players decks are shuffled and placed in the players "draw pile"</li>
                            <li className="list-group-item">b. 5 cards are pulled from the "draw pile" and placed in the Players "hand"</li>

                        </ul>
                    </li>
                    <li className="list-group-item">6. A random player in selected to take the first "turn"</li>
                    <li className="list-group-item">7. Each player will get 30 seconds for each turn</li>
                    <li className="list-group-item">8. As the player take his/her turn:
                                        <ul className="list-group list-group-flush">
                            <li className="list-group-item">a. A card is drawn from his/her "draw pile"</li>
                            <li className="list-group-item">b. A card from "hand" is played and each effect associated with card is executed

                                            <ul className="list-group list-group-flush">
                                    <li className="list-group-item list-group-item-flush">i. depending on the effects in the card, the player may need to select a target Player or Card</li>
                                    <li className="list-group-item list-group-item-flush">ii. depending on the card, the player may get to play again (i.e. choose another card from their hand to play)</li>


                                </ul>
                            </li>
                            <li className="list-group-item">c. Played card(s) is placed in the "discard" pile</li>
                        </ul>
                    </li>
                    <li className="list-group-item">9. Game moves to the next players "turn"</li>
                    <li className="list-group-item">10. Game is over when there is only one "awake" player.</li>


                </ul>

            </div>
        )
    }
}
