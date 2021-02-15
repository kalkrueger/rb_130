def reduce(array, default = nil)
  counter = 0
  acc = default
  if acc.nil?
    acc = array[0]
    counter = 1
  end

  while counter < array.size
    acc = yield(acc, array[counter])
    counter += 1
  end

  acc
end

array = [1, 2, 3, 4, 5]


p reduce(['a', 'b', 'c']) { |acc, value| acc += value }     # => 'abc'
p reduce([[1, 2], ['a', 'b']]) { |acc, value| acc + value}
