require 'pry'

class Participant
  attr_accessor :name, :cards
  attr_writer :total

  def initialize(name)
    @name = name
    @cards = []
    @total = 0
  end

  def hit(new_card)
    cards << new_card
  end

  def stay
    puts "#{name} stays!"
  end

  def busted?
    total > 21
  end

  def total
    total = 0
    cards.each do |card|
      if card.ace?
        total += 11
      elsif card.jack? || card.queen? || card.king?
        total += 10
      else
        total += card.value.to_i
      end
    end

    cards.select(&:ace?).count.times do
      break if total <= 21
      total -= 10
    end
    total
  end
end

class Player < Participant
end

class Dealer < Participant
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    Card::SUITS.each do |suit|
      Card::VALUES.each do |value|
        @cards << Card.new(suit, value)
      end
    end

    mix_cards!
  end

  def mix_cards!
    cards.shuffle!
  end

  def update_deck
    cards.pop
  end
end

class Card
  SUITS = ["H", "D", "S", "C"]
  VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "The #{value} of #{suit}"
  end

  def value
    case @value
    when 'J' then 'Jack'
    when 'Q' then 'Queen'
    when 'K' then 'King'
    when 'A' then 'Ace'
    else
      @value
    end
  end

  def suit
    case @suit
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    when 'S' then 'Spades'
    when 'C' then 'Clubs'
    end
  end

  def ace?
    value == 'Ace'
  end

  def king?
    value == 'King'
  end

  def queen?
    value == 'Queen'
  end

  def jack?
    value == 'Jack'
  end
end

module Hand
  def deal_cards
    2.times do
      player.cards << deck.update_deck
      dealer.cards << deck.update_deck
    end
  end

  def show_initial_cards
    puts "#{dealer.name} has: #{dealer.cards.first}"
    puts "#{player.name} has: #{player.cards.first} and #{player.cards.last} "
  end

  def player_turn
    loop do
      puts "Your total is: #{player.total}"
      puts "#{player.name}, do you want to hit or stay (h/s)?"
      answer = nil
      loop do
        answer = gets.chomp.downcase
        break if %w(h s).include? answer
        puts "Please hit(h),or stay (s)"
      end
      if answer == 's'
        player.stay
        break
      elsif player.busted?
        break
      else
        player.hit(deck.update_deck)
        break if player.busted?
      end
      show_player_card
    end
  end

  def dealer_turn
    loop do
      if dealer.total >= 17
        dealer.stay
      elsif dealer.total < 17
        dealer.hit(deck.update_deck)
      end
      break if dealer.total >= 17
    end
    puts "#{dealer.name} has #{dealer.total}"
  end

  def show_player_card
    puts "You got: #{player.cards.last}"
  end

  def show_result
    puts "#{dealer.name} has: #{dealer.total}"
    puts "#{dealer.name} busted!" if dealer.busted?
    puts "#{player.name} has: #{player.total}"
    puts "#{player.name} busted!" if player.busted?
  end

  def define_winner
    if dealer.busted? && !player.busted?
      puts "********"
      puts "You win!"
      puts "********"
    elsif player.busted? && !dealer.busted?
      puts "*******************"
      puts "#{dealer.name} wins"
      puts "*******************"
    elsif player.total > dealer.total
      puts "********"
      puts "You win!"
      puts "********"
    elsif player.total == dealer.total
      puts "***********"
      puts "It's a tie"
      puts "***********"
    else
      puts "********************"
      puts "#{dealer.name} wins"
      puts "********************"
    end
  end
end

class Game
  include Hand
  attr_accessor :player, :dealer, :deck

  def initialize
    @player = Player.new(name)
    @dealer = Dealer.new(name)
    @deck = Deck.new
  end

  def start
    set_dealer_name
    display_welcome_message
    set_player_name
    start_hand
    good_bye_message
  end

  def start_hand
    loop do
      deal_cards
      show_initial_cards
      player_turn
      dealer_turn
      define_winner
      show_result
      break unless play_again?
      clear
      reset
      next_hand_message
    end
  end

  private

  def clear
    system 'clear'
  end

  def display_welcome_message
    puts "Welcome to 21 game. My name is #{dealer.name}"
  end

  def set_dealer_name
    dealers = %w(R2D2 RUBOP SOBY)
    dealer.name = dealers.sample
  end

  def set_player_name
    puts "What is your name?"
    answer = nil
    loop do
      answer = gets.chomp
      break unless answer.empty?
      puts "Please type your name:"
    end
    puts "Let's start #{answer}"
    player.name = answer
  end

  def play_again?
    answer = nil
    puts "Do you want to play again? y/n"
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Please type y or n"
    end
    return true if answer == 'y'
    return false if answer == 'n'
  end

  def next_hand_message
    puts "*****************************"
    puts "Let's play another hand then!"
    puts "*****************************"
  end

  def reset
    player.cards = []
    dealer.cards = []
    self.deck = Deck.new
  end

  def good_bye_message
    puts "Thanks for playing"
  end
end

Game.new.start
