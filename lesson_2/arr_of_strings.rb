=begin
START PROGRAM
PRINT call the method with an array of strings as argument
GET the method with the  array of strings as a param
SET the "arr" of strings to a variable
READ the arr of strings value and turn it into array
READ the array and call the join method on the array
SET the returned value of the arra.join to the variable result
PRINT the result variable
=end
puts "Type your array of strings"
arr = gets().chomp
array = eval(arr)
def one_string(array)
  array.join
end

puts one_string(array)
