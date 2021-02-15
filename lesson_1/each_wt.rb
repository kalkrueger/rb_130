def each(array)
  counter = 0
  while counter < array.size do
    yield(array[counter])
    counter += 1
  end

  array
end

each([1, 2, 3, 4, 5]) do |num|
  puts num + 1
end
