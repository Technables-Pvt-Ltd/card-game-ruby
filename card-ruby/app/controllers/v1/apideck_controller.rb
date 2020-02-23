class V1::ApideckController < ApplicationController
  def index
    message = MSG_API_WELCOME
    success = true
    data = {
      :deck => MSG_API_VERSION,
    }

    response_data = ApiResponse.new(message, success, data)
    render json: response_data, status: STATUS_OK
  end

  def checkdeckdata
    decks = DeckDatum.all

    #DeckDatum.

    if decks.length == 0
      seed_effects()
      seed_deckdata()
    end
  end

  def seed_deckdata
    deck = DeckDatum.create(name: "Sutha: The Skull Crusher", deckclass: "deck-sutha")
    seed_deck_cards?(deck.id, deck.deckclass)
    deck = DeckDatum.create(name: "Azzan: The Mystic", deckclass: "deck-azzan")
    seed_deck_cards?(deck.id, deck.deckclass)
    deck = DeckDatum.create(name: "Lia: The Radiant", deckclass: "deck-lia")
    seed_deck_cards?(deck.id, deck.deckclass)
    deck = DeckDatum.create(name: "Oriax: The Clever", deckclass: "deck-oriax")
    seed_deck_cards?(deck.id, deck.deckclass)
  end

  def seed_effects
    effect = CardEffect.create(name: "play_again", effectclass: "eff-play-again")
    effect = CardEffect.create(name: "draw", effectclass: "eff-draw")
    effect = CardEffect.create(name: "attack", effectclass: "eff-attack")
    effect = CardEffect.create(name: "defense", effectclass: "eff-defense")
    effect = CardEffect.create(name: "heal", effectclass: "eff-heal")
  end

  def seed_deck_cards?(deckid, decktype)
    case decktype
    when "deck-sutha"
      seed_sutha_cards?(deckid)
    when "deck-azzan"
      seed_azzan_cards?(deckid)
    when "deck-lia"
      seed_lia_cards?(deckid)
    when "deck-oriax"
      seed_oriax_cards?(deckid)
    end
  end

  def seed_sutha_cards?(deckid)
    play_again = CardEffect.find_by(name: "play_again")
    draw = CardEffect.find_by(name: "draw")
    attack = CardEffect.find_by(name: "attack")
    defense = CardEffect.find_by(name: "defense")
    heal = CardEffect.find_by(name: "heal")

    card = DeckCard.create(deckid: deckid, name: "Battle Roar")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Battle Roar")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Mighty Toss")
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Mighty Toss")
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Big Axe is Best Axe")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Big Axe is Best Axe")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Big Axe is Best Axe")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Big Axe is Best Axe")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Big Axe is Best Axe")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Burtal Punch")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Burtal Punch")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Head Butt")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Head Butt")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Rage!")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 4)

    card = DeckCard.create(deckid: deckid, name: "Rage!")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 4)

    card = DeckCard.create(deckid: deckid, name: "Riff")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Raff")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Spiked Shield!")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Bag Of Rats")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Open The Armory!")
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Open The Armory!")
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Snack Time")
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Flex!")
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Flex!")
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Two Axes Are Better Than One")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Two Axes Are Better Than One")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 2)
  end

  def seed_azzan_cards?(deckid)
    play_again = CardEffect.find_by(name: "play_again")
    draw = CardEffect.find_by(name: "draw")
    attack = CardEffect.find_by(name: "attack")
    defense = CardEffect.find_by(name: "defense")
    heal = CardEffect.find_by(name: "heal")

    card = DeckCard.create(deckid: deckid, name: "Lighting Bolt")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Lighting Bolt")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Lighting Bolt")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Lighting Bolt")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Burning Hands")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Burning Hands")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Burning Hands")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Magic Missile")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Magic Missile")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Magic Missile")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Mirror Image")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Stoneskin")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Shield")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Shield")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Knowledge is Power")
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Knowledge is Power")
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Knowledge is Power")
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Speed of Thought")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Speed of Thought")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Speed of Thought")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Evil Sneer")
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Evil Sneer")
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)
  end

  def seed_lia_cards?(deckid)
    play_again = CardEffect.find_by(name: "play_again")
    draw = CardEffect.find_by(name: "draw")
    attack = CardEffect.find_by(name: "attack")
    defense = CardEffect.find_by(name: "defense")
    heal = CardEffect.find_by(name: "heal")

    card = DeckCard.create(deckid: deckid, name: "Divine Inspiration")
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Divine Inspiration")
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Banishing Smite")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Divine Smite")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Divine Smite")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Divine Smite")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "For The Most Justice!")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "For The Most Justice!")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Fighting Words")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Fighting Words")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Fighting Words")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "For Even More Justice!")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "For Even More Justice!")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "For Even More Justice!")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "For Even More Justice!")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "For Justice!")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "For Justice!")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "For Justice!")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Divine Shield")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Divine Shield")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Fluffy")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Spinning Parry")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Spinning Parry")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Cure Wounds")
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 2)
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "High Charisma")
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "High Charisma")
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Finger-Wag Of Judgement")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Finger-Wag Of Judgement")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 2)
  end

  def seed_oriax_cards?(deckid)
    play_again = CardEffect.find_by(name: "play_again")
    draw = CardEffect.find_by(name: "draw")
    attack = CardEffect.find_by(name: "attack")
    defense = CardEffect.find_by(name: "defense")
    heal = CardEffect.find_by(name: "heal")

    card = DeckCard.create(deckid: deckid, name: "Sneak Attack!")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Sneak Attack!")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "All The Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "All The Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "All The Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "Two Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Two Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Two Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Two Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "One Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "One Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "One Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "One Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "One Thrown Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: attack.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "My Little Friend")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 3)

    card = DeckCard.create(deckid: deckid, name: "The Goon Squad")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "The Goon Squad")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Winged Serpent")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Winged Serpent")
    CardEffectsMap.create(cardid: card.id, effectid: defense.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Stolen Potion")
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Stolen Potion")
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Even More Daggers")
    CardEffectsMap.create(cardid: card.id, effectid: draw.id, count: 2)
    CardEffectsMap.create(cardid: card.id, effectid: heal.id, count: 1)

    card = DeckCard.create(deckid: deckid, name: "Cunning Action")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 2)

    card = DeckCard.create(deckid: deckid, name: "Cunning Action")
    CardEffectsMap.create(cardid: card.id, effectid: play_again.id, count: 2)
  end

  # def addGameDeck
  #   #truncatetable?('deck_data')
  #   checkdeckdata()
  #   decks = DeckDatum.select(:id, :name, :deckclass).all

  #   resultDecks = []

  #   decks.each do |deck|
  #     cards = DeckCard.select(:id, :deckid, :name).where(deckid: deck.id)

  #     resultCards = []

  #     cards.each do |card|
  #       effects = CardEffectsMap.select('card_effects_maps.id, eff.name, eff.effectclass, card_effects_maps.count,card_effects_maps.cardid').joins('Inner Join card_effects eff on eff.id = card_effects_maps.effectid')#.where(cardid: card.id)
  #       resultCards<< {card: card ,effects: effects};
  #     end

  #     resultDecks << { deck: deck, cards: resultCards }
  #   end

    
  #   message = MSG_DECK_INITIATED
  #   status = STATUS_OK
  #   success = true
  #   data = {
  #     :deck => resultDecks,
      
  #   }

  #   response_data = ApiResponse.new(message, success, data)
  #   render json: response_data, status: STATUS_OK
  # end

  def init
    checkdeckdata()
    decks = DeckDatum.select(:id, :name, :deckclass).all
    message = MSG_DECK_INITIATED
    status = STATUS_OK
    success = true
    data = {
      :deck => decks,
    }

    response_data = ApiResponse.new(message, success, data)
    render json: response_data, status: STATUS_OK
  end

  def initgame
    gameid = params[:gameid]
    deckid = params[:deckid]
    userid = params[:userid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gameid].present? || !params[:deckid].present? || !params[:userid].present?) || gameid.nil? || deckid.nil? || userid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      message = MSG_DECK_INITIATED
      success = true
      data = {
        :data => { gameid: gameid, deckid: deckid, userid: userid },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: STATUS_OK
  end

  def getgamedeck
    gameid = params[:gameid]
    proceed = true
    status = STATUS_OK
    err_msg = ""

    if !params[:gameid].ispresent? || gameid.nil?
      proceed = false
      status = STATUS_NOT_FOUND
      err_msg = MSG_PARAM_MISSING
    end

    if proceed
      message = MSG_DECK_INITIATED
      success = true
      data = {
        :data => { gameid: gameid, deckid: deckid, userid: userid },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: STATUS_OK
  end

  def addplayer
    gameid = params[:gameid]
    deckid = params[:deckid]
    userid = params[:userid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gameid].present? || !params[:deckid].present? || !params[:userid].present?) || gameid.nil? || deckid.nil? || userid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      message = MSG_DECK_INITIATED
      success = true
      data = {
        :data => { gameid: gameid, deckid: deckid, userid: userid },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: STATUS_OK
  end

  def removeplayer
    gameid = params[:gameid]
    userid = params[:userid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gameid].present? || !params[:userid].present?) || gameid.nil? || userid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      message = MSG_DECK_INITIATED
      success = true
      data = {
        :data => { gameid: gameid, userid: userid },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: STATUS_OK
  end

  def startgame
    gameid = params[:gameid]
    userid = params[:userid]

    status = STATUS_OK
    proceed = true
    err_msg = ""
    if (!params[:gameid].present? || !params[:userid].present?) || gameid.nil? || userid.nil?
      proceed = false
      err_msg = MSG_PARAM_MISSING
      status = STATUS_NOT_FOUND
    end

    if proceed
      message = MSG_DECK_INITIATED
      success = true
      data = {
        :data => { gameid: gameid, userid: userid },
      }

      response_data = ApiResponse.new(message, success, data)
    else
      response_data = ApiResponse.new(err_msg, proceed, nil)
    end
    render json: response_data, status: STATUS_OK
  end
end
