enum TarotCardType {
  theFool,
  theMagician,
  theHighPriestess,
  theEmpress,
  theEmperor,
  theHierophant,
  theLovers,
  theChariot,
  justice,
  theHermit,
  theWheelOfFortune,
  strength,
  theHangedMan,
  death,
  temperance,
  theDevil,
  theTower,
  theStar,
  theMoon,
  theSun,
  judgement,
  theWorld,
}

class TarotCard {
  const TarotCard({
    required this.type,
    required this.name,
    required this.description,
  });

  final TarotCardType type;
  final String name;
  final String description;

  static const int cost = 3;

  static const List<TarotCard> all = [
    TarotCard(
      type: TarotCardType.theFool,
      name: 'The Fool',
      description: 'Copies the last Tarot used',
    ),
    TarotCard(
      type: TarotCardType.theMagician,
      name: 'The Magician',
      description: 'Enhance 1 selected card to Lucky',
    ),
    TarotCard(
      type: TarotCardType.theHighPriestess,
      name: 'The High Priestess',
      description: 'Creates 2 Planet cards',
    ),
    TarotCard(
      type: TarotCardType.theEmpress,
      name: 'The Empress',
      description: 'Enhance 2 selected cards to Bonus (+30 chips)',
    ),
    TarotCard(
      type: TarotCardType.theEmperor,
      name: 'The Emperor',
      description: 'Creates 2 Tarot cards',
    ),
    TarotCard(
      type: TarotCardType.theHierophant,
      name: 'The Hierophant',
      description: 'Enhance 2 selected cards to Mult (+4 mult)',
    ),
    TarotCard(
      type: TarotCardType.theLovers,
      name: 'The Lovers',
      description: 'Enhance 1 selected card to Wild (any suit)',
    ),
    TarotCard(
      type: TarotCardType.theChariot,
      name: 'The Chariot',
      description: 'Enhance 1 selected card to Steel (×1.5 mult in hand)',
    ),
    TarotCard(
      type: TarotCardType.justice,
      name: 'Justice',
      description: 'Enhance 1 selected card to Glass (×2 mult, may break)',
    ),
    TarotCard(
      type: TarotCardType.theHermit,
      name: 'The Hermit',
      description: 'Double current money (max +\$20)',
    ),
    TarotCard(
      type: TarotCardType.theWheelOfFortune,
      name: 'The Wheel of Fortune',
      description: '1 in 4 chance: random Joker gains edition',
    ),
    TarotCard(
      type: TarotCardType.strength,
      name: 'Strength',
      description: 'Increase rank of 2 selected cards by 1',
    ),
    TarotCard(
      type: TarotCardType.theHangedMan,
      name: 'The Hanged Man',
      description: 'Destroy 2 selected cards',
    ),
    TarotCard(
      type: TarotCardType.death,
      name: 'Death',
      description: 'Convert first selected card to second',
    ),
    TarotCard(
      type: TarotCardType.temperance,
      name: 'Temperance',
      description: 'Gain total sell value of all Jokers (max \$50)',
    ),
    TarotCard(
      type: TarotCardType.theDevil,
      name: 'The Devil',
      description: 'Enhance 1 selected card to Gold (earn \$3 when scored)',
    ),
    TarotCard(
      type: TarotCardType.theTower,
      name: 'The Tower',
      description: 'Enhance 1 selected card to Stone (+25 chips)',
    ),
    TarotCard(
      type: TarotCardType.theStar,
      name: 'The Star',
      description: 'Convert 3 selected cards to Diamonds',
    ),
    TarotCard(
      type: TarotCardType.theMoon,
      name: 'The Moon',
      description: 'Convert 3 selected cards to Clubs',
    ),
    TarotCard(
      type: TarotCardType.theSun,
      name: 'The Sun',
      description: 'Convert 3 selected cards to Hearts',
    ),
    TarotCard(
      type: TarotCardType.judgement,
      name: 'Judgement',
      description: 'Creates a random Joker',
    ),
    TarotCard(
      type: TarotCardType.theWorld,
      name: 'The World',
      description: 'Convert 3 selected cards to Spades',
    ),
  ];
}
