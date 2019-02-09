=begin
ask the user to make a choise
Validate user's input to check if the input is either 'r', 'paper', 'scissors'
capture the options in an array and invoke a method to aleatory pick one option (sample)
puts the users input and the computer output
calculate who wins
display who wins
ask the user if she wants to play again
SET the answer to answer variable
Break unless answer is yes
r = rock
p = paper
sc = scissors
s = spock
=end

VALID_CHOICES = %w(r p sc l s)
player_score = []
computer_score = []
@@round_winner = ''

def win?(first, second)
  (first == 'r' && second == 'sc') ||
    (first == 'r' && second == 'l') ||
    (first == 'p' && second == 'r') ||
    (first == 'p' && second == 's') ||
    (first == 'sc' && second == 'p') ||
    (first == 'sc' && second == 'l') ||
    (first == 's' && second == 'sc') ||
    (first == 's' && second == 'r') ||
    (first == 'l' && second == 's') ||
    (first == 'l' && second == 'p')
end

def display_result(player, computer)
  if win?(player, computer)
    prompt("you won this round!!!")
    @@round_winner = "player"
  elsif win?(computer, player)
    prompt("computer won this round:(")
    @@round_winner = "computer"
  else
    prompt("it's a tie this round")
  end
end


def increase_score(player_score, computer_score)
  case @@round_winner
  when 'player'
    player_score << 1
  when 'computer'
    computer_score << 1
  end
end

def is_there_a_winner?(player_score, computer_score)
  if player_score.length == 5 && computer_score.length == 5
    prompt("IT'S A TIE")
  elsif player_score.length == 5 && computer_score.length < 5
    prompt(">>>>YOU WON !!!!!!<<<<<<<")
  elsif player_score.length < 5 && computer_score.length == 5
    prompt(">>>>>> YOU LOST - COMPUTER WON <<<<<<")
  else
    prompt("NO WINNERS YET")
  end
end

def prompt(message)
  Kernel.puts("=> #{message}")
end

loop do
  loop do
    choice = ''
    loop do
      prompt("Chose one (rock, paper, scissors, lizard, spoke) typing the initials: #{VALID_CHOICES.join(', ')}")
      choice = Kernel.gets().chomp()

      if VALID_CHOICES.include?(choice)
        break
      else
        prompt("That's not a valid choice. Please try again")
      end
    end

    computer_choice = VALID_CHOICES.sample()
    prompt("You chose= #{choice}, the computer chose: #{computer_choice}")

    display_result(choice, computer_choice)

    increase_score(player_score, computer_score)

    is_there_a_winner?(player_score, computer_score)
    prompt("you have #{player_score.length} points and the computer has #{computer_score.length}")

    if player_score.length == 5 || computer_score.length == 5
      break
    else
     prompt('Do you want to keep playing this round? (y/n)')
     response = Kernel.gets().chomp()
     break unless response.downcase.start_with?('y')
    end

  end

  player_score.clear
  computer_score.clear

  prompt('Do you want to play again?')
  answer = Kernel.gets().chomp()
  break unless answer.downcase.start_with?('y')

end

prompt('thank you for playing!. Good bye!')
