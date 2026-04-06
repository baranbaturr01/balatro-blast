import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/models/joker_card.dart';
import 'package:balatro_blast/models/blind.dart';
import 'package:balatro_blast/utils/constants.dart';

enum GamePhase { mainMenu, blindSelect, playing, shop, gameOver, victory }

class GameState {
  GameState({
    this.ante = 1,
    this.blindIndex = 0,
    this.handsLeft = kStartingHands,
    this.discardsLeft = kStartingDiscards,
    this.money = kStartingMoney,
    this.runningScore = 0,
    List<PlayingCard>? deck,
    List<PlayingCard>? hand,
    List<PlayingCard>? selectedCards,
    List<JokerCard>? jokers,
    this.phase = GamePhase.mainMenu,
    Blind? currentBlind,
    Map<String, int>? handLevels,
  })  : deck = deck ?? [],
        hand = hand ?? [],
        selectedCards = selectedCards ?? [],
        jokers = jokers ?? [],
        currentBlind = currentBlind ??
            Blind.forAnte(1, BlindType.small),
        handLevels = handLevels ?? {};

  int ante;
  int blindIndex; // 0=small, 1=big, 2=boss
  int handsLeft;
  int discardsLeft;
  int money;
  int runningScore;
  List<PlayingCard> deck;
  List<PlayingCard> hand;
  List<PlayingCard> selectedCards;
  List<JokerCard> jokers;
  GamePhase phase;
  Blind currentBlind;

  /// Upgrade level per hand type (for planet cards). Key = HandType.name.
  Map<String, int> handLevels;

  int get currentBlindTarget => currentBlind.targetScore;

  bool get isBlindDefeated => runningScore >= currentBlindTarget;

  bool get isGameOver => handsLeft <= 0 && !isBlindDefeated;

  bool get isVictory => ante > kTotalAntes;

  bool get canPlay => selectedCards.isNotEmpty && handsLeft > 0;

  bool get canDiscard =>
      selectedCards.isNotEmpty && discardsLeft > 0;

  int get deckCount => deck.length;

  BlindType get currentBlindType {
    switch (blindIndex) {
      case 0:
        return BlindType.small;
      case 1:
        return BlindType.big;
      default:
        return BlindType.boss;
    }
  }

  /// Returns a fresh copy of game state for a new run.
  factory GameState.newRun() {
    final state = GameState(
      ante: 1,
      blindIndex: 0,
      handsLeft: kStartingHands,
      discardsLeft: kStartingDiscards,
      money: kStartingMoney,
      runningScore: 0,
      phase: GamePhase.blindSelect,
    );
    state.deck = PlayingCard.fullDeck()..shuffle();
    state.currentBlind = Blind.forAnte(1, BlindType.small);
    return state;
  }
}
