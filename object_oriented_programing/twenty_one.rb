=begin
T1 is a game played by a dealer and a player. The one getting closer to 21 in total value of the sum of their cards wins the hand. The game has a 52 cards deck
with 13 values (2-10, jack, queen, king, ace) and 4 suits (hearts, diamonds, clubs, spades)
The game starts by delivering 2 ramdom cards to the player and 2 for the DealerThe player can see her two cards but just one form the dealer's
The player can stay or hit on each turn. If the player goes over 21, the player busts. The player can stay when she wants
The dealer has to hit until her total value is 17 or more
THe one with a total value closer to 21 is the wnner.

rules:
- if the player busts, he loses. If he stays is the dealer turn
- if the dealer busts, the player wins. The dealer has to hit until his total >= 17
- If dealer busts, player wins, If both stay, the closes total value to  21 wins
- if both totals are equal, it's a tie

Nouns: Game, turn, player, dealer, deck, card, participant, suit, value, total
Verbs: start, compare, deal, stay, hit , bust


- Which nouns are not going to perform actions but are mostly a property?
  - suit
  - value
  - total
  - card
  - deck
  - turn

- Which verbs are not actions but states
  -  bust (a player get the stay bust but it is not an action to be perform )

Organize classes and verbs

Player
  hit
  stay
  busts?
  total
Dealer
  hit
  stay
  busts?
  total
  deal
Participant
Deck
  deal (here or in the dealer?)
Card
Game
 start

=end

def Player

  def initialize
    # what would be the properties/states of the player . cards?, name?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

def Dealer

  def initialize
    # properties/ states? cards?, name?
  end

  def hit
  end

  def stay
  end

  def busted?
  end

  def total
  end
end

class Participant
  # what goes in here? all the redundant behaviors from Player and Dealer?
end

class Deck
  def initialize
    # obviously, we need some data structure to keep track of cards
    # array, hash, something else?
  end

  def deal
    # does the dealer or the deck deal?
  end
end

class Card
  def initialize
    # what are the "states" of a card?  / the card is available or not from the deck ?
  end
end

class Game
  def start
    # what's the sequence of steps to execute the game play?
    =begin
    class Game
      def start
        deal_cards
        show_initial_cards
        player_turn
        dealer_turn
        show_result
      end
    end
    =end
  end
end

Game.new.start
