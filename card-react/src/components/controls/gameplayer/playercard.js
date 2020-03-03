import React, { Component } from 'react'
import { connect } from 'react-redux'
import { faHeartbeat, faShieldAlt, faEject, faReply, faKhanda } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

const PlayerCard = props => {

    const { card, deckclass, clicked, handleCardClick, activecard } = props;

    return (
        <div className={`deck-card ${deckclass} ${clicked ? 'clicked' : ''}`} key={card.cardid} onClick={handleCardClick && handleCardClick.bind(this, card.cardid, clicked)}>
            <div className='effect' key={card.cardid}>
                {



                    card.effects.map((effect, index) => {

                        let effectHtml = ''

                        let count = effect.count;
                        if (activecard && effect.effectclass === 'eff-defense')
                            count = card.card_health

                        effectHtml = Array.from({ length: count }, (item, index) => {
                            switch (effect.effectclass) {
                                case 'eff-heal':
                                    return <FontAwesomeIcon key={index} className="eff-icon" icon={faHeartbeat} />
                                case 'eff-defense':
                                    return <FontAwesomeIcon key={index} className="eff-icon" icon={faShieldAlt} />
                                case 'eff-draw':
                                    return <FontAwesomeIcon key={index} className="eff-icon" icon={faEject} />
                                case 'eff-play-again':
                                    return <FontAwesomeIcon key={index} className="eff-icon" icon={faReply} />
                                case 'eff-attack':
                                    return <FontAwesomeIcon key={index} className="eff-icon" icon={faKhanda} />
                                //  break;
                                default:
                                    return <span className={`card-effect ${effect.effectclass}`} key={card.cardid + '_' + effect.id + '_' + index}>{effect.name.substring(0, 2)}</span>;
                            }
                        }
                            // <span className={`card-effect ${effect.effectclass}`} key={card.cardid + '_' + effect.id + '_' + index}>{effect.name.substring(0,2)}</span>
                        );

                        return (<div key={index} className="effect-wrapper">{effectHtml}</div>)
                    })
                }
            </div>
            <span className='card-name'>{card.name}</span>
        </div>
    )

}

const mapStateToProps = (state) => ({

})

const mapDispatchToProps = {

}

export default connect(mapStateToProps, mapDispatchToProps)(PlayerCard)
