=begin
ask the user to make a choise
Validate user's input to check if the input is either 'rock', 'paper', 'scissors'
capture the options in an array and invoke a method to aleatory pick one option (sample)
puts the users input and the computer output
calculate who wins
display who wins
ask the user if she wants to play again
SET the answer to answer variable
BReAK unless answer is yes
=end

VALID_CHOICES = %w(rock paper scissors)

def win?(first, second)
  (first == 'rock' && second == 'scissors') ||
    (first == 'paper' && second == 'rock') ||
    (first == 'scissors' && second == 'paper')
end

def display_result(player, computer)
  if win?(player, computer)
    prompt("you won!!!")
  elsif win?(computer, player)
    prompt("computer won :(")
  else
    prompt("it's a tie!")
  end
end

def prompt(message)
  Kernel.puts("=> #{message}")
end

loop do
  choice = ''
  loop do
    prompt("Chose one: #{VALID_CHOICES.join(', ')}")
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

  prompt('Do you want to play again?')
  answer = Kernel.gets().chomp()
  break unless answer.downcase.start_with?('y')
end

prompt('thank you for playing!. Good bye!')
