# PRINT insert number1
# GET number1
# SET number1 to number1 variable
# PRINT insert number2
# GET number2
# SET number2 to number2 variable
# SET number1 + number2 to result variable
# PRINT result

puts "first number"
number1 = gets().chomp()
puts "second number"
number2= gets().chomp()
result = (number1.to_i + number2.to_i)
print result
