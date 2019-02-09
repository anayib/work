# ask the user for two numbers
# ask the user for operational symbol
# execute the operational
# show the result
# gets()
# puts()
LANGUAGE = 'es'
require 'yaml'
MESSAGES = YAML.load_file("calculator_messages.yml")

def prompt(message)
  puts "=> #{message}"
end

def messages(lang='en', message)
  MESSAGES[lang][message]
end


def valid_number?(input)
  /^\d+$/.match(input) rescue "The number you entered is invalid. try again"
end

def valid_float?(input)
  /^\d*\.?\d*?/.math(input) rescue "The number you entered is invalid. try again"
end

def operator_to_message(operator)
  loading_message = case operator
                    when '1'
                      prompt(messages(LANGUAGE,'adding'))
                    when '2'
                      prompt(messages(LANGUAGE,'substracting'))
                    when '3'
                      prompt(messages(LANGUAGE, 'multiplying'))
                    when '4'
                      prompt(messages(LANGUAGE,'dividing'))
                    end
  loading_message
end

prompt(messages(LANGUAGE, "welcome"))

name = ''
loop do
  name = gets.chomp
  if name.empty?()
    prompt(messages(LANGUAGE,"valid_name"))
  else
    break
  end
end

prompt(messages(LANGUAGE,"greetings_user") + " #{name}")
loop do # main loop
  prompt(messages(LANGUAGE,"welcome_to_calculator"))
  number1 = ''
  loop do
    prompt(messages(LANGUAGE,"ask_for_first_number"))
    number1 = gets.chomp
    if valid_number?(number1)
      break
    else
      prompt(messages(LANGUAGE,"not_valid_input"))
    end
  end

  prompt(messages(LANGUAGE, 'first_number_is') + number1 + "!")

  number2 = ''
  loop do
    prompt(messages(LANGUAGE,"ask_for_second_number"))
    number2 = gets.chomp

    if valid_number?(number2)
      break
    else
      prompt(messages(LANGUAGE,"not_valid_input"))
    end
  end
  prompt(messages(LANGUAGE, 'second_number_is') + number2 + "!")

  prompt(messages(LANGUAGE,"select_operator"))

  operator = ''
  loop do
    operator = gets.chomp
    if %w(1 2 3 4).include?(operator)
      break
    else
      prompt(messages(LANGUAGE,"select_operator_rescue"))
    end
  end

  prompt(operator_to_message(operator))

  result = case operator
           when '1'
             number1.to_i() + number2.to_i()
           when '2'
             number1.to_i - number2.to_i
           when '3'
             number1.to_i * number2.to_i
           when '4'
             number1.to_f / number2.to_f
           end

  prompt(messages(LANGUAGE,"result") +  " #{result}")
  prompt(messages(LANGUAGE,"additionla_operation?"))
  answer = gets.chomp
  break unless answer.downcase().start_with?('y')
end

prompt(messages(LANGUAGE,"bye_message"))
