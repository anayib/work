=begin
a method that takes an array of integers, and returns a new array with every other element

START PROGRAM
SET  A VARIABLE WITH AN ARRAY OF INTEGERS ARR
SET AN ITERATOR VARIABLE SET TO 1
SET A METHOD THAT  RECIEVE AN ARR AS A PARAM
SET AN EMPTU ARRAY TO A VARIABLE CALLED RESULT
SET A WHILE LOOP THAT ITERATES WHILE ITERATOR IS >0 TO THE ARRA.LENGTH
SET A VARIABLE - ELEMENT -  THAT SAVES  THE SLICE METHOD CALLED ON  THE ARRAY PASSING THE ITERATOR VALUE AS A PARAM
SET THE VALUE OF THE EMPTY ARRAY - NEW_ARRAY - PUSHING THE -ELEMENT VARIABLE TO THE NEW_ARRAY .
INCREASE THE VALUE OF THE ITERATOR EVERY LOOP LAP
PRINT THE NEW_ARRAY
=end

puts "Type your array of integers"
input = gets().chomp()
arr = eval(input)


def to_new_arr(arr)
  iterator = 0
  new_arr = []
  while iterator <= arr.length
    element = arr.slice(iterator)
    new_arr << element
    iterator += 2
  end
  puts new_arr
end

to_new_arr(arr)
