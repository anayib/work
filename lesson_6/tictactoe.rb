INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
FIRST_MOVE = 5
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]

NUMBER_OF_MATCHES_TO_WIN = 5
FIRST_PLAYER = "choose"

def prompt(msg)
  puts "=> #{msg}"
end

def display_board(brd)
  system('clear') || system('cls')
  puts "You are the #{PLAYER_MARKER}, computer is #{COMPUTER_MARKER}"
  puts ''
  puts '     |     |'
  puts "   #{brd[1]} |  #{brd[2]}  |  #{brd[3]}  "
  puts '     |     |'
  puts '-----+-----+-----'
  puts '     |     |'
  puts "   #{brd[4]} |  #{brd[5]}  |  #{brd[6]}  "
  puts '     |     |'
  puts '-----+-----+-----'
  puts '     |     |'
  puts "   #{brd[7]} |  #{brd[8]}  |  #{brd[9]}  "
  puts '     |     |'
  puts ''
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def define_first_player
  loop do
    prompt "Who you want to go first ?(me/computer)"
    answer =  gets.chomp
    if answer == "me"
      return FIRST_PLAYER.replace "player"
    elsif answer == "computer"
      return FIRST_PLAYER.replace "computer"
    else
      prompt <<~MSG
        Type \"me\" if you want to go first
           Type \"computer\" if you want the computer to go first
      MSG
    end
  end
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def place_piece!(board, current_player)
  if current_player == "player"
    player_places_piece!(board)
  elsif current_player == "computer"
    computer_places_piece!(board)
  end
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp
    if square.size != 1 || !empty_squares(brd).include?(square.to_i)
      prompt "Sorry. Your choice is not valid"
    else
      square = square.to_i
    end
    break if empty_squares(brd).include?(square)
  end
  brd[square] = PLAYER_MARKER
end

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def find_square_five(line, board, marker)
  if line.include?(FIRST_MOVE) && board[FIRST_MOVE] == INITIAL_MARKER
    board[FIRST_MOVE] = marker
  end
end

def computer_places_piece!(brd)
  square = nil

  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, COMPUTER_MARKER)
    break if square
  end

  if !square
    WINNING_LINES.each do |line|
      square = find_at_risk_square(line, brd, PLAYER_MARKER)
      break if square
    end
  end

  if !square
    WINNING_LINES.each do |line|
      square = find_square_five(line, brd, COMPUTER_MARKER)
      break if square
    end
  end

  if !square
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end

def alternate_player(current_player)
  if current_player == "player"
    "computer"
  elsif current_player == "computer"
    "player"
  end
end

def someone_wins?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 3
      return "Player"
    elsif brd.values_at(line[0], line[1], line[2]).count(COMPUTER_MARKER) == 3
      return "Computer"
    end
  end
  nil
end

def player_won?(board)
  true if detect_winner(board) == "Player"
end

def computer_won?(board)
  true if detect_winner(board) == "Computer"
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def joinor(array, sep = ", ", last_sep = " or ")
  new_str = ""
  array.each do |elem|
    new_str = if array.size == 1
                new_str + elem.to_s
              elsif elem == array[array.size - 2]
                new_str + elem.to_s + last_sep
              else
                new_str + elem.to_s + sep
              end
  end
  new_str.chomp(", ")
end

def match_end?(board)
  someone_wins?(board) || board_full?(board)
end

def player_won_match?(player_score)
  player_score == NUMBER_OF_MATCHES_TO_WIN
end

def computer_won_match?(computer_score)
  computer_score == NUMBER_OF_MATCHES_TO_WIN
end

def display_match_winner_message(player_score, computer_score)
  if player_won_match?(player_score)
    prompt "You won the match!"
  elsif computer_won_match?(computer_score)
    prompt "Computer won the match!"
  else
    prompt "No winner for the match yet"
  end
end

def play_again?
  answer = ""
  loop do
    prompt <<~MSG
      Do you want to play another match?
         A match has #{NUMBER_OF_MATCHES_TO_WIN} games.(y or n)
    MSG
    answer = gets.chomp
    if answer.downcase == "y"
      return true
    elsif answer.downcase == "n"
      return false
    else
      prompt "Type \"y\" if you want to play again, \"n\" if you don't"
      next
    end
  end
end

loop do
  player_score = 0
  computer_score = 0
  define_first_player if FIRST_PLAYER == "choose"
  current_player = FIRST_PLAYER
  loop do
    board = initialize_board
    loop do
      display_board(board)
      prompt <<~MSG
        Let's play.
        Your score is #{player_score}, the computer's score is #{computer_score}.
        The first to win #{NUMBER_OF_MATCHES_TO_WIN} games is the winner of the match
      MSG
      place_piece!(board, current_player)
      current_player = alternate_player(current_player)
      break if match_end?(board)
    end

    if someone_wins?(board)
      if player_won?(board)
        player_score += 1
        prompt "You won this game"
      elsif computer_won?(board)
        computer_score += 1
        prompt "Computer won this game"
      end
      sleep(1)
    end
    display_match_winner_message(player_score, computer_score)
    sleep(1)
    display_board(board)
    break if player_score == NUMBER_OF_MATCHES_TO_WIN || computer_score == NUMBER_OF_MATCHES_TO_WIN
  end
  break unless play_again?
end

prompt "thanks for playing Tic Tac Toe. Bye!"
