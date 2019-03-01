require 'pry'

INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
FIRST_MOVE = 5
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
               [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # colums
               [[1, 5, 9], [3, 5, 7]] # diagonals

FIRST_PLAYER = "computer" # "player"/"computer"/"choose"

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
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
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end


def define_first_player
    prompt "Who you want to go first ?(me/computer)"
    answer =  gets.chomp
    if answer == "me"
      FIRST_PLAYER.replace "player"
    elsif answer == "computer"
      FIRST_PLAYER.replace "computer"
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
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)

    prompt "Sorry. Your choice is not valid"
  end
  brd[square] = PLAYER_MARKER
end

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select{|k,v| line.include?(k) && v == INITIAL_MARKER}.keys.first
  else
    nil
  end
end

def find_square_five(line, board, marker)
  if line.include?(FIRST_MOVE) && board[FIRST_MOVE] == INITIAL_MARKER
    board[FIRST_MOVE] = marker
  else
    nil
  end
end

# iterar sobre las lineas
# encontrar si esa línea incluye el número 5 (la posición 5 del board)
  # determinar si el board en la posicion 5 no está seleccionado
    # No está seleccionado, Seleccionarlo
    # Si está seleccionado, retornar nil

def computer_places_piece!(brd)
  square = nil

  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, COMPUTER_MARKER )
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
  binding.pry
  if current_player == "player"
    current_player = "computer"
  elsif current_player == "computer"
    current_player = "player"
  end
end


=begin

MY SOLUTION WITH OTHER METHOD TO FIND SQUARE AT RISK
def find_square_at_risk(brd, line)
    if brd.values_at(*line).count(PLAYER_MARKER) == 2 && brd.values_at(*line).count(COMPUTER_MARKER) == 0
       brd.select {|k,v| line.include?(k) && v == " "}.keys.first
    else
      nil
    end
end

def computer_places_piece!(brd)
    square = nil
    WINNING_LINES.each do |line|
      square = find_square_at_risk(brd, line)
      break if square
    end

    if !square = nil
      square = empty_squares(brd).sample
    end
    brd[square] = COMPUTER_MARKER
end

MY SOLUTION, FIRST TRY
def computer_places_piece!(brd)
  lines = WINNING_LINES.select do |line|
            brd.values_at(*line).count(PLAYER_MARKER) == 2 && brd.values_at(*line).count(COMPUTER_MARKER) == 0
          end
  unless lines.empty?
    line = lines.first
    square = line[brd.values_at(*line).index(INITIAL_MARKER)]
  else
    square = empty_squares(brd).sample
  end
  brd[square] = COMPUTER_MARKER
end

identify if there is 2 squares mark in a row
  iterate each "line" of WINNING_LINES
  If there is 2 elements in board  marked in a row with PLAYER_MARKER at WINNIG_BOARD positions of line, array
   Place COMPUTER_MARKER in the third element of the line
Else, mark ramdom
=end



def someone_wins?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    # if brd[line[0]] == PLAYER_MARKER &&
    #    brd[line[1]] == PLAYER_MARKER &&
    #    brd[line[2]] == PLAYER_MARKER
    #   return 'Player'
    # elsif
    #    brd[line[0]] == COMPUTER_MARKER &&
    #    brd[line[1]] == COMPUTER_MARKER &&
    #    brd[line[2]] == COMPUTER_MARKER
    #   return 'Computer'
    # end
    #other solution
    # WINNIG_BOARD.each do |line|
    # if brd.values_at(*line).all? {|value| value == "X"}  # Splat operator * (*line) pass all the elements in a array, one by one, into the method
    #   return "Player wins"
    # elsif brd.values_at(*line).all? {|value| value == "O"}
    #   return "Computer wins"
    # end
    if brd.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 3
      return "Player"
    elsif brd.values_at(line[0], line[1], line[2]).count(COMPUTER_MARKER) == 3
      return "Computer"
    end
  end
  nil
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def joinor(array, sep = ", ", last_sep = " or ") # esta solucion no funciona por ..
  new_str = ""
  array.each do |elem|
    if elem == array[array.size-2]    #aquí si cualquier otro elemento es igual al último le va a agregar la palabra
      new_str += elem.to_s + last_sep
    else
      new_str += elem.to_s + sep
    end
  end
  new_str.chomp(', ')
end

loop do
  player_score = 0
  computer_score = 0
  define_first_player
  current_player = FIRST_PLAYER
  loop do
    board = initialize_board
    # who_goes_fist
    loop do
      display_board(board)
      prompt "let's play. Your score is #{player_score}, the computer's score is #{computer_score}. The first to win 5 times is the winner"
      place_piece!(board, current_player)
      current_player = alternate_player(current_player)
      break if someone_wins?(board) || board_full?(board)
    end

    if someone_wins?(board)
      if detect_winner(board) == "Player"
        player_score += 1
      elsif detect_winner(board) == "Computer"
        computer_score += 1
      end
    end
    display_board(board)
    break if player_score == 5 || computer_score == 5
  end
  if player_score == 5
    prompt "Player won!"
  elsif computer_score == 5
    prompt "Computer won!"
  else
    prompt "it's a tie"
  end
  prompt "Do you want to play again?(y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt "thanks for playing Tic Tac Toe. Bye!"
