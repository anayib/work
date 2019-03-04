require 'pry'
CARDS = [['H', '2'], ['D', '2'], ['C', '2'], ['S', '2'],
         ['H', '3'], ['D', '3'], ['C', '3'], ['S', '3'],
         ['H', '4'], ['D', '4'], ['C', '4'], ['S', '4'],
         ['H', '5'], ['D', '5'], ['C', '5'], ['S', '5'],
         ['H', '6'], ['D', '6'], ['C', '6'], ['S', '6'],
         ['H', '7'], ['D', '7'], ['C', '7'], ['S', '7'],
         ['H', '8'], ['D', '8'], ['C', '8'], ['S', '8'],
         ['H', '9'], ['D', '9'], ['C', '9'], ['S', '9'],
         ['H', '10'], ['D', '10'], ['C', '10'], ['S', '10'],
         ['H', 'J'], ['D', 'J'], ['C', 'J'], ['S', 'J'],
         ['H', 'Q'], ['D', 'Q'], ['C', 'Q'], ['S', 'Q'],
         ['H', 'K'], ['D', 'K'], ['C', 'K'], ['S', 'K'],
         ['H', 'A'], ['D', 'A'], ['C', 'A'], ['S', 'A'],
        ]
def prompt(msg)
  puts "=> #{msg}"
end

def total(cards)
  total = 0
  cards.each do |card|
    case card[1]
    when "2" then total += 2
    when "3" then total += 3
    when "4" then total += 4
    when "5" then total += 5
    when "6" then total += 6
    when "7" then total += 7
    when "8" then total += 8
    when "9" then total += 9
    when "10" then total += 10
    when "J" then total += 10
    when "Q" then total += 10
    when "K" then total += 10
    when "A"
      if total <=10
        total += 11
      else
        total += 1
      end
    end
  end
  total
end

def valid_move?(player_move)
  answer = nil
  if player_move == "hit"
    "hit"
  elsif player_move == "stay"
    "stay"
  else
    loop do
      prompt <<~MSG
       Invalid answer.
       Please type hit/stay
      MSG
      answer = gets.chomp
      break if answer == "hit" || answer == "stay"
    end
    answer
  end
end

def player_busted?(total_cards)
  total_cards > 21
end

def play_again?(answer)
  if answer == "y"
    "y"
  elsif answer == "n"
    "n"
  else
    response = nil
    loop do
      prompt <<~MSG
        Invalid answer.
        Type y/n
      MSG
      response = gets.chomp
      break if ["y", "n"].include(response)
    end
    response
  end
end

def return_winner(player_total, dealer_total)
  if dealer_total > 21
    "player"
  elsif player_total > dealer_total
    "player"
  elsif dealer_total > player_total
    "dealer"
  else
    "tie"
  end
end

def score(player_total, dealer_total)
  <<~MSG
    Your total is  #{player_total}
    and the delar total is #{dealer_total}
  MSG
end

def display_winner(winner, score)
 if winner == "player"
   prompt("#{score} You are the winner!")
 elsif winner == "dealer"
   prompt("#{score} The dealer won!")
 else
   prompt("#{score} No winner. Its a tie")
 end
end

#player turn
prompt "Welcome to the 21 game. Let's start"

loop do
  cards = []
  card = nil
  player_total = 0
  loop do

    if player_total <= 21
      prompt <<~MSG
        Type hit or stay
      MSG
    end
    binding.pry
    player_move = gets.chomp
    answer = valid_move?(player_move)

    total_cards = total(cards)
    break if answer == "stay" || player_busted?(total_cards)
    card = CARDS.sample
    cards << card
    CARDS.slice!(CARDS.index(card))
    player_total = total(cards)
    if player_total <= 21
      prompt <<~MSG
        #{card}
        Your total is #{player_total}
      MSG
    end
  end

  if player_busted?(total(cards))
    prompt "Sorry. You busted"
    answer = nil
    loop do
      prompt "Do you want to play again?(y/n)"
      answer = gets.chomp
      answer = play_again?(answer)
      break if answer
    end
    break if  answer == "n"
    next
  end
  #dealer turn
  cards = []
  dealer_total = 0
  loop do
    break if total(cards) >= 17
    card = CARDS.sample
    cards << card
    CARDS.slice!(CARDS.index(card))
    dealer_total = total(cards)
  end

  winner = return_winner(player_total, dealer_total)
  score = score(player_total, dealer_total)
  display_winner(winner, score)

  prompt "Do you want to play again"
  answer = gets.chomp
  answer = play_again?(answer)
  break if  answer == "n"

end

prompt "Thanks for playing. See you soon!"
