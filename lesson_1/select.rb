def select(array)
  counter = 0
  rtrn = []
  while counter < array.size do
    rtrn << array[counter] if yield(array[counter])
    counter += 1
  end

  rtrn
end

array = [1, 2, 3, 4, 5]

p select(array) { |num| num.odd? }      # => [1, 3, 5]
select(array) { |num| puts num }      # => [], because "puts num" returns nil and evaluates to false
p select(array) { |num| num + 1 }
