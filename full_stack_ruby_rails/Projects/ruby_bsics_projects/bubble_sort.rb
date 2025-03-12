=begin
NOTE: The return value are configured to give times, not to return the array output
those are just printed for now
=end

def random_array(size)
  unsorted_array = Array.new(size) { rand(1..1000) }
  return unsorted_array, size
end

def bubble_sort_reducer(array)
  stamp1 = Time.now
  output = array.reduce([]) do |a, value|
    if a == []
      a.push(value)
    else
      index = 0
      # bad practice to add items to an object WHILE iterating over it - but wanted to try this
      # with a reducer!
      a.each do |a_item|
        if value <= a_item
          a.insert(a.index(a_item), value)
          break #break needed to stop the loop from looking at a items as you add items - ONLY ADD ONE TIME
        else
          index += 1 #looks at the next item
          if index == a.size #only adds if at the end of the list
            a.push(value)
            break
          end
        end
      end # a.each
    end
    a
  end # reducer
  p output
  stamp2 = Time.now
  return "\e[31mReduce OP Time: #{(stamp2 - stamp1).round(2)} seconds\e[0m"
end

def bubble_sort(array)
  stamp1 = Time.now
  clone = array
  size = array.size
  iterations = 0
  change = false
  while iterations <= size
    print "\e[34m#{clone}\e[0m"
    puts ""
    clone.each_with_index do |value, index|
      unless index >= (size - 1)
          if value > array[index + 1]
            change = true
            placeholder = value
            clone[index] = array[index + 1]
            clone[index + 1] = placeholder
          end
      else
          if array[index + 1] == nil
            break
          end
      end# unless
    end# each.do

    iterations += 1
    size -= 1

  end # while
  p clone
  stamp2 = Time.now
  puts "-------------"
  return "\e[31mSort OP Time: #{(stamp2 - stamp1).round(2)} seconds\e[0m"
end

test_array1 = random_array(3000)


s = bubble_sort(test_array1[0])
r = bubble_sort_reducer(test_array1[0])

puts "\e[31mRESULTS:
    array size: #{test_array1[1]}
      #{s}
      #{r}
------------------------------------------------\e[0m"


