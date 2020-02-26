module DbController
  def checkdeckdata
    decks = DeckDatum.all


    if decks.length == 0
      seed_effects()
      seed_piletypes()
      seed_deckdata()
    end

    #return true
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

  def seed_piletypes
    PileType.create(name:"deck")
    PileType.create(name:"hand")
    PileType.create(name:"active")
    PileType.create(name:"discard")
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
end
