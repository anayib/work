# A move belongs to a player
require 'pry-byebug'

class Move
  attr_accessor :value
  VALUES = %w(rock paper scissors).freeze

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @value
  end
end

# Player class that has a :name and a :move as attributes
class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

# Human class that inherits from player class
class Human < Player
  def set_name
    n = nil
    loop do
      puts "What's your name"
      n = gets.chomp
      break unless n.empty?
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts 'Select rock, paper, scissors'
      choice = gets.chomp
      break if Move::VALUES.include? choice
      puts 'You input an invalid option. Plese choose: rock, paper or scissors'
    end
    self.move = Move.new(choice)
  end
end

# Computer class inheriting from player class
class Computer < Player
  def set_name
    self.name = %w(Robo Huawei Sn).sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

# class to initialize the game
class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors'
  end

  def display_moves
    puts "#{human.name} choose #{human.move}."
    puts "#{computer.name} choose #{computer.move}"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} wins"
    elsif human.move < computer.move
      puts "#{computer.name} wins"
    else
      puts "It's a tie"
    end
  end

  def display_goodbye_message
    puts 'Bye, thanks for playing'
  end

  def play
    loop do
      display_welcome_message
      human.choose
      computer.choose
      display_moves
      display_winner
      break unless play_again?
    end
    display_goodbye_message
  end

  def play_again?
    answer = nil
    loop do
      puts 'Do you want to play again [y/n] ?'
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts 'You need to answer either y or n'
    end

    return false if answer.downcase == 'n'
    return true if answer.downcase == 'y'
  end
end

RPSGame.new.play
