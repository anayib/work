require 'pry'

class Move
  attr_accessor :value
  VALUES = %w(rock paper scissors lizard spock).freeze


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

  def lizard?
    @value == 'lizard'
  end

  def spock?
    @value == 'spock'
  end


  def >(other_move)

    result = false

    decision_hash = {rock? => [other_move.scissors?, other_move.lizard?],
                     paper? => [other_move.rock?, other_move.spock?],
                     scissors? => [other_move.paper?, other_move.lizard?],
                     lizard? => [other_move.paper?, other_move.spock?],
                     spock? => [other_move.scissors?, other_move.rock?]}

    decision_hash.each do |k, v|
      result = true if k && v[0] || k && v[1]
    end

    return result

  end

  def <(other_move)

    result = false

    decision_hash = {rock? => [other_move.paper?, other_move.spock?],
                     paper? => [other_move.scissors?, other_move.lizard?],
                     scissors? => [other_move.rock?, other_move.spock?],
                     lizard? => [other_move.rock?, other_move.scissors?],
                     spock? => [other_move.lizard?, other_move.paper?]}

    decision_hash.each do |k, v|
      result = true if k && v[0] || k && v[1]
    end

    return result

  end

  def to_s
    @value
  end
end

# Player class that has a :name and a :move as attributes
class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
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
      puts 'Select rock, paper, scissors, lizard, spock'
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
  TOTAL_SCORE = 2

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def is_over?
    human.score == TOTAL_SCORE || computer.score == TOTAL_SCORE
  end

  def display_welcome_message
    puts 'Welcome to Rock, Paper, Scissors, Lizard, Spock'
  end

  def display_moves
    puts "#{human.name} choose #{human.move}."
    puts "#{computer.name} choose #{computer.move}"
  end


  def display_new_round_message
    puts "The first winning #{TOTAL_SCORE} times is the winner"
    puts "#{human.name} score is #{human.score}"
    puts "#{computer.name} score is #{computer.score}"
  end

  def update_winner_score(winner)
     winner.score += 1
  end


  def display_winner
    if human.move > computer.move
      puts "#{human.name} wins"
      update_winner_score(human)
    elsif human.move < computer.move
      puts "#{computer.name} wins"
      update_winner_score(computer)
    else
      puts "It's a tie"
    end
  end


  def display_goodbye_message
    puts 'Bye, thanks for playing'
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def display_final_winner
    if  human.score == TOTAL_SCORE
      puts "#{human.name} is the final winner!"
    else
      puts "#{computer.name} is the final winner"
    end
  end

  def play
    loop do
      display_welcome_message
      reset_scores
      loop do
        display_new_round_message
        human.choose
        computer.choose
        display_moves
        display_winner
        break if is_over?
      end

      display_final_winner
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
