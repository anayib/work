# the loan amount
# Anual percentage rate APR
# The loan duration
# What is the montlhy interest rate
# What is the loan duration
# m = p * (j / (1 - (1 + j)**(-n)))
=begin
START PROGRAM
SET the APR to a constant APR in float number
READ ARP to validate that ARP is a valid float number
READ the APR and turn it into MPR
SET MPR to a variable MPR
PRINT insert your loan amount
GET the loan amount
SET loan amount to a variable p
READ the loan amount p to validate that p  is a valid integer number
PRINT your load amount is p
GET the loan duration in months
SET the loan duration to the variable n
PRINT your loan duration is n months
CALCULATE montlhy payment with a mehtod monthly payment that receive 3 arguments -
          loan amount, montlhy interest rate, loan duration in months
SET the returned value to a varibale m (montlhy payment)
READ the m value
PRINT  the m value along with the n value
=end

require 'yaml'

MESSAGES = YAML.load_file("mortgage_messages.yml")
puts MESSAGES.inspect

APR = 0.10
j=''
n=''
p=''

def validate_float(input)
  /^\d*\.?\d*$/.match(String(input))
  input
end

def validate_amount(p)
  /^\d+$/.match(p)
end

def validate_loan_length(n)
  /^([1-9])$/.match(n)
end

def calculate_monthly_payment(p,n,mpr)
  p = Float(p)
  mpr = Float(mpr)
  n = Float(n)
  m = p * (mpr / (1 - (1 + mpr)**(-n)))
  puts m.round(2)
  m = String(m)
end

def prompt(message, variable= nil)
  puts(format(MESSAGES[message]), variable)
end


validate_float(APR)
mpr = APR/12

prompt('welcome_message')

loop do #main loop

  loop do
    #Validate loan amount input
    prompt('how_much')
    p = gets.chomp
    if validate_amount(p)
      prompt('requested_amount_confirmation')
      break
    else
      prompt("incorrect_imput")
    end
  end

  prompt("number_of_months_invitation")

  loop do
    prompt("number_of_months_input")
    n = gets.chomp
    if validate_loan_length(n)
      prompt format('loan_number_of_months', :n => n)
      break
    else
      prompt('wrong_input_number_of_months')
    end
  end

  montlhy_payment = calculate_monthly_payment(p,n,mpr)
  prompt format('mortgage_result', montlhy_payment)
  response = gets.chomp
  break unless response.downcase().start_with?('y')
end

prompt("bye_message")

#FALTA
=begin
Pasar los mensajes a un ymal
Poner calculadora multi Language
Que se pudan  prestamos hasta 36 meses
Limitar el número de decimales a 2 -> round
=end
