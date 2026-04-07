// Game constants used throughout Balatro Blast.

const int kHandSize = 8;
const int kMaxJokers = 5;
const int kMaxSelectedCards = 5;
const int kStartingHands = 4;
const int kStartingDiscards = 3;
const int kStartingMoney = 4;
const int kTotalAntes = 8;
const int kBlindsPerAnte = 3;

// Landscape viewport dimensions.
const double kViewportWidth = 800.0;
const double kViewportHeight = 480.0;

// Layout section heights.
const double kHudHeight = 70.0;
const double kJokerAreaHeight = 112.0;
const double kScoreFormulaHeight = 50.0;
const double kDeckAreaWidth = 90.0;

// Card dimensions on the game canvas (logical pixels).
const double kCardWidth = 72.0;
const double kCardHeight = 108.0;
const double kCardRadius = 8.0;
const double kCardSelectedOffset = 20.0;

// Joker slot dimensions.
const double kJokerWidth = 72.0;
const double kJokerHeight = 108.0;

// Shop item costs.
const int kJokerBaseCost = 6;
const int kJokerPremiumCost = 8;
const int kTarotCost = 3;
const int kPlanetCost = 4;
const int kShopRerollCost = 5;

// Money rewards.
const int kBlindWinReward = 3;
const int kHandRemainingReward = 1;
const int kInterestPer = 5; // $1 interest per $5 held
const int kMaxInterest = 5;

// Blind score targets per ante (index 0 = ante 1).
const List<List<int>> kBlindTargets = [
  [300, 450, 600],
  [800, 1200, 1600],
  [2000, 3000, 4000],
  [5000, 7500, 10000],
  [11000, 16500, 22000],
  [20000, 30000, 40000],
  [35000, 52500, 70000],
  [50000, 75000, 100000],
];

// Max spacing between card edges in hand layout.
const double kMaxCardSpacing = 12.0;

// Overlay keys used with Flame game.overlays.
const String kOverlayMainMenu = 'mainMenu';
const String kOverlayShop = 'shop';
const String kOverlayBlindSelect = 'blindSelect';
const String kOverlayGameOver = 'gameOver';
const String kOverlaySettings = 'settings';
