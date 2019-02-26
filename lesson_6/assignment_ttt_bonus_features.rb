#improve join
#Nayib Solution
=begin
ALGORITHM
Input data: array
Output data: String wich last element is preceeded by or, or and if the paramethers and if given
Expected output:
  joinor([1, 2])                   # => "1 or 2"
  joinor([1, 2, 3])                # => "1, 2, or 3"
  joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
  joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"

Iterar sobre cada elemento del array
Si el elemento es el último del array, mutelo para que se le agregue la palabra or o and
Si el elemento no es el último del array, separar por sep
Retornar la nueva string

=end
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

#Nayib second solution

def joinor(arr, sep=", ", word="or")
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(sep)
  end
end
arr = [1,2]
joinor(arr)

#ls Solution
def joinor(arr, delimiter=', ', word='or')
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(delimiter)
  end
end
