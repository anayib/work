class Board
  attr_reader :squares

  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]
  BEST_SQUARE = 5

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def ai_decision_marker
    if computer_offensive_move != nil
      return computer_offensive_move
    elsif computer_defensive_move != nil
      return computer_defensive_move
    elsif computer_choose_best_square != nil
      return computer_choose_best_square
    else
      return false
    end
  end

  def two_human_markers?(squares)
    (squares.select(&:human_marked?).size == 2) && (squares.select(&:unmarked?).size == 1) ? true : false
  end

  def human_unmarked_square(line)
    threatening_lines = {}
    line.each { |e| threatening_lines[e] = squares[e]}
    threatening_lines.select { |_,v | v.marker == " " }.keys.first
  end

  def two_computer_markers?(squares)
    (squares.select(&:computer_marked?).size == 2) && (squares.select(&:unmarked?).size == 1) ? true : false
  end

  def computer_unmarked_square(line)
    threatening_lines = {}
    line.each { |e| threatening_lines[e] = squares[e]}
    threatening_lines.select { |_,v | v.marker == " " }.keys.first
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def best_square_unmarked?
    unmarked_keys.include?(BEST_SQUARE)
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def reset
    (1..9).each { |k, _| @squares[k] = Square.new() }
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts ''
    puts '     |     |'
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}  "
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts " #{@squares[4]}   |  #{@squares[5]}  |  #{@squares[6]}  "
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts " #{@squares[7]}   |  #{@squares[8]}  |  #{@squares[9]}  "
    puts '     |     |'
    puts ''
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end

  def computer_choose_best_square
    return BEST_SQUARE if best_square_unmarked?
    nil
  end

  def computer_offensive_move
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      return computer_unmarked_square(line) if two_computer_markers?(squares)
    end
    nil
  end

  def computer_defensive_move
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      return human_unmarked_square(line) if two_human_markers?(squares)
    end
    nil
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def human_marked?
    marker == TTTGame::HUMAN_MARKER
  end

  def computer_marked?
    marker == TTTGame::COMPUTER_MARKER
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = 'x'
  COMPUTER_MARKER = 'o'

  attr_reader :board, :human, :computer, :human_wins, :computer_wins
  attr_accessor  :first_to_move, :computer_name, :human_name

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = nil
    @human_wins = 0
    @computer_wins = 0
    @first_to_move = nil
    @computer_name = 'Computer'
    @human_name = 'Human'
  end

  def play
    clear
    display_welcome_message
    set_human_name
    set_computer_name
    display_computer_name

    loop do
      loop do
        choose_marker
        choose_first_player
        display_board
        loop do
          current_player_moves
          break if board.someone_won? || board.full?
          clear_screen_and_display_board if human_turn?
        end

        display_result
        sleep(2)
        break if [human_wins, computer_wins].include? 5
        reset_board
      end
      break unless play_again?
      reset_board
      reset_match_scores
      display_play_again_messages
    end
    display_goodbye_message
  end

  private

  def display_welcome_message
    puts "Hello welcome to TTT Game. Let's play"
  end

  def set_human_name
    answer = nil
    loop do
      puts "What is your name?"
      answer = gets.chomp
      break unless answer.size == 0
      puts "Please type your name"
    end
    human_name = answer
  end

  def set_computer_name
    self.computer_name = %w(R2D2 SONY HUAWEI).sample
  end

  def display_computer_name
    puts "You are playing against #{computer_name}"
  end

  def choose_first_player
    puts "Who do you want to go first, you(type me), computer(type computer):"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ["me", "computer"].include? answer
      puts "You need to type 'me' or 'computer' depending on who you want to go first."
      puts "You(type me), computer(type computer):"
    end
    @current_marker = (answer == "me" ? first_to_move = HUMAN_MARKER : first_to_move = COMPUTER_MARKER)
  end

  def choose_marker
    puts "What marker do you want to play with ('x' or 'o')"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if ["x", "o"].include? answer
      puts "You need to choose between 'x' and 'o'"
    end
    HUMAN_MARKER.replace(answer)
    HUMAN_MARKER == 'x' ? COMPUTER_MARKER.replace("o") : COMPUTER_MARKER.replace('x')
  end

  def display_goodbye_message
    puts "Bye. Thanks for playing. TTT Game"
  end

  def display_board
    puts "You're a #{human.marker}. #{computer_name} is #{computer.marker}"
    board.draw
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def joinor(squares, separator=',', last_separator='or')
     squares.size == 2 ? squares.join(last_separator) : squares.join(separator)
  end

  def human_moves
    puts "Choose a square: (#{joinor(board.unmarked_keys)})"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, invalid input. Try again."
    end
    board[square] = human.marker
  end

  def computer_moves
    if board.ai_decision_marker
       board[board.ai_decision_marker] = computer.marker
    else
       board[board.unmarked_keys.sample] = computer.marker
    end
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def display_result
    display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
      update_general_score(human)
    when computer.marker
      puts "#{computer_name} won"
      update_general_score(computer)
    else
      puts "It's a tie"
    end
  end

  def update_general_score(winner)
    winner == @human ? @human_wins += 1 : @computer_wins += 1
  end

  def clear
    system 'clear'
  end

  def play_again?
    answer = nil
    loop do
      puts "Do you want to play again (y/n)?"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, you need to choose y or n"
    end

    answer == "y"
  end

  def reset_board
    board.reset
    @current_marker = first_to_move
    clear
  end

  def reset_match_scores
    @human_wins = 0
    @computer_wins = 0
  end

  def display_play_again_messages
    puts "Let's play again"
    puts ''
  end
end

game = TTTGame.new
game.play
