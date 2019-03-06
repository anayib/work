SUITS = ['H', 'D', 'S', 'C']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
NUMBRE_OF_ROUNDS = 5
DEALER_LIMIT = 17
HAND_LIMIT = 21

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0 # J, Q, K
      sum += 10
    else
      sum += value.to_i
    end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > HAND_LIMIT
  end

  sum
end

def busted?(total)
  total > HAND_LIMIT
end

# :tie, :dealer, :player, :dealer_busted, :player_busted
def detect_result(dealer_cards, player_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > HAND_LIMIT
    :player_busted
  elsif dealer_total > HAND_LIMIT
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def display_result(dealer_cards, player_cards)
  result = detect_result(dealer_cards, player_cards)

  case result
  when :player_busted
    prompt "You busted! Dealer wins this match!"
  when :dealer_busted
    prompt "Dealer busted! You win this match!"
  when :player
    prompt "You win this match!"
  when :dealer
    prompt "Dealer wins this match!"
  when :tie
    prompt "It's a tie!"
  end
end

def player_won?(dealer_cards, player_cards)
  true if detect_result(dealer_cards, player_cards) == :player ||
          detect_result(dealer_cards, player_cards) == :dealer_busted
end

def dealer_won?(dealer_cards, player_cards)
  true if detect_result(dealer_cards, player_cards) == :dealer ||
          detect_result(dealer_cards, player_cards) == :player_busted
end

def display_final_result(player_score, dealer_score)
  if player_score == NUMBRE_OF_ROUNDS && dealer_score == NUMBRE_OF_ROUNDS
    prompt "It's a tie"
  elsif player_score == NUMBRE_OF_ROUNDS
    prompt "You win the game!"
  elsif dealer_score == NUMBRE_OF_ROUNDS
    prompt "Dealer wins the game!"
  else
    prompt "No winner yet"
  end
end

def display_match_winner_message(player_score, dealer_score)
  prompt <<~MSG
    You won #{player_score} rounds
    The dealer won #{dealer_score} rounds
  MSG
end

def winner?
  true if player_score == NUMBRE_OF_ROUNDS ||
          dealer_score == NUMBRE_OF_ROUNDS
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

loop do
  player_score = 0
  dealer_score = 0
  prompt <<~MSG
    Welcome to Twenty-One!
        The one winnig 5 rounds first, it's the winner!
  MSG
  loop do
    break if winner?

    prompt "Let's start a new round"
    # initialize vars
    deck = initialize_deck
    player_cards = []
    dealer_cards = []

    # initial deal
    2.times do
      player_cards << deck.pop
      dealer_cards << deck.pop
    end

    player_total = total(player_cards)
    dealer_total = total(dealer_cards)

    prompt "Dealer has #{dealer_cards[0]} and ?"
    prompt <<~MSG
      You have: #{player_cards[0]} and #{player_cards[1]},
      for a total of #{player_total}.
    MSG

    # player turn
    loop do
      player_turn = nil
      loop do
        prompt "Would you like to (h)it or (s)tay?"
        player_turn = gets.chomp.downcase
        break if ['h', 's'].include?(player_turn)

        prompt "Sorry, must enter 'h' or 's'."
      end

      if player_turn == 'h'
        player_cards << deck.pop
        prompt "You chose to hit!"
        prompt "Your cards are now: #{player_cards}"
        player_total = total(player_cards)
        prompt "Your total is now: #{player_total}"
      end
      break if player_turn == 's' || busted?(player_total)
    end

    if busted?(player_total)
      display_result(dealer_cards, player_cards)
      if player_won?(dealer_cards, player_cards)
        player_score += 1
      elsif dealer_won?(dealer_cards, player_cards)
        dealer_score += 1
      end
      display_match_winner_message(player_score, dealer_score)
      next
    else
      prompt "You stayed at #{player_total}"
    end

    # dealer turn
    prompt "Dealer turn..."
    sleep(1)

    loop do
      break if dealer_total >= DEALER_LIMIT

      prompt "Dealer hits!"
      sleep(1)
      dealer_cards << deck.pop
      dealer_total = total(dealer_cards)
      prompt "Dealer's cards are now: #{dealer_total}"
      sleep(1)
    end

    if busted?(dealer_total)
      prompt "Dealer total is now: #{dealer_total}"
      display_result(dealer_cards, player_cards)

      if player_won?(dealer_cards, player_cards)
        player_score += 1
      elsif dealer_won?(dealer_cards, player_cards)
        dealer_score += 1
      end

      display_match_winner_message(player_score, dealer_score)
      sleep(1)
      next

    else
      prompt "Dealer stays at #{dealer_total}"
    end

    sleep(1)

    puts "=============="
    prompt "Dealer has #{dealer_cards}, for a total of: #{dealer_total}"
    sleep(1)
    prompt "Player has #{player_cards}, for a total of: #{player_total}"
    sleep(1)
    puts "=============="

    display_result(dealer_cards, player_cards)

    if player_won?(dealer_cards, player_cards)
      player_score += 1
    elsif dealer_won?(dealer_cards, player_cards)
      dealer_score += 1
    end

    display_match_winner_message(player_score, dealer_score)
    sleep(1)
  end

  prompt "Thank you for playing Twenty-One!"
  final_result = display_final_result(player_score, dealer_score)
  sleep(1)
  prompt final_result
  sleep(1)

  break unless play_again?
end
prompt "Thank you for playing Twenty-One. See you!"
