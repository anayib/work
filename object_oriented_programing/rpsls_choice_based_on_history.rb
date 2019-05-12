class Move
  attr_accessor :value
  VALUES = %w(rock paper scissors lizard spock).freeze


  def initialize(value)
    @value = value
  end

  def to_s
    @value
  end
end

# Player class that has a :name and a :move as attributes
class Player
  attr_accessor :move, :name, :score, :moves_history
  COMBINATIONS = { 'rock' => ['scissors', 'lizard'],
                   'paper' => ['rock', 'spock'],
                   'scissors' => ['paper', 'lizard'],
                   'lizard' => ['spock', 'paper'],
                   'spock' => ['scissors', 'rock'] }
  def initialize
    set_name
    @score = 0
    @moves_history = []
  end

  def wins_against(other_player)
    COMBINATIONS.fetch(self.move.value).include?(other_player.move.value)
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
    moves_history << move.value
  end
end

# Computer class inheriting from player class
class Computer < Player

  AI_VALUES = %w(paper scissors lizard spock).freeze

  def set_name
    self.name = %w(Robo Huawei Sn).sample
  end

  def choose(human_move, human_score)
    if (%w(paper spock).include? human_move.value) && ((human_score + 1)/RPSGame::TOTAL_SCORE.to_f > 0.6)
      self.move = Move.new(Move::AI_VALUES.sample)
      moves_history << move.value
    else
      self.move = Move.new(Move::VALUES.sample)
      moves_history << move.value
    end
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

  def human_won?
    human.wins_against(computer)
  end

  def computer_won?
    computer.wins_against(human)
  end

  def display_winner
    if human_won?
      puts "#{human.name} wins"
      update_winner_score(human)
    elsif computer_won?
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

  def reset_moves_history
    human.moves_history = []
    computer.moves_history = []
  end

  def display_final_winner
    if  human.score == TOTAL_SCORE
      puts "#{human.name} is the final winner!"
    else
      puts "#{computer.name} is the final winner"
    end
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

  def play
    loop do
      display_welcome_message
      reset_scores
      reset_moves_history
      loop do
        display_new_round_message
        human.choose
        computer.choose(human.move, human.score)
        display_moves
        display_winner
        break if is_over?
      end

      display_final_winner
      puts "******************"
      display_history_of_moves
      break unless play_again?

    end
    display_goodbye_message
  end

  private

  def display_history_of_moves
    puts "#{human.name} moves are #{human.moves_history}"
    puts "#{computer.name} moves are #{computer.moves_history}"
  end

end

RPSGame.new.play
