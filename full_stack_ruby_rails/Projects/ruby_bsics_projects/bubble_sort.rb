=begin
NOTE: The return value are configured to give times, not to return the array output
those are just printed for now
=end

def random_array(size)
  unsorted_array = Array.new(size) { rand(1..1000) }
  return unsorted_array, "size: #{size}"
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
  # p output
  stamp2 = Time.now
  return output, "\e[31mReduce OP Time: #{(stamp2 - stamp1).round(2)} seconds\e[0m"
end

def bubble_sort(array)
  stamp1 = Time.now
  clone = array
  size = array.size
  iterations = 0
  change = false
  while iterations <= size
    print "\e[34m#{clone}\e[0m\n"
    clone.each_with_index do |value, index|
      change = false
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
          elsif
            change = false
            break
          end
      end# unless
    end# each.do

    iterations += 1
    size -= 1

  end # while
  p clone
  stamp2 = Time.now
  return clone, "\e[31mSort OP Time: #{(stamp2 - stamp1).round(2)} seconds\e[0m"
end

# test_array1 = random_array(100)
# # puts ""
# # p "test array 1"
# # p test_array1
#
# #
# s = bubble_sort([133, 370, 684, 412, 699, 66, 411, 584, 360, 517, 190, 801, 242, 925, 299, 536, 211, 425, 841, 665, 280, 757, 75, 563, 384, 764, 627, 823, 257, 335, 533, 54, 772, 688, 533, 662, 915, 249, 70, 482, 7, 943, 892, 420, 257, 64, 936, 363, 986, 213, 716, 890, 717, 62, 643, 845, 899, 100, 979, 415, 328, 649, 83, 639, 607, 616, 448, 135, 533, 224, 411, 704, 427, 843, 10, 378, 817, 483, 508, 142, 286, 674, 948, 539, 701, 471, 75, 353, 358, 836, 593, 941, 917, 635, 343, 712, 937, 979, 261, 126])[0]
# if s == [7, 10, 54, 62, 64, 66, 70, 75, 75, 83, 100, 126, 133, 135, 142, 190, 211, 213, 224, 242, 249, 257, 257, 261, 280, 286, 299, 328, 335, 343, 353, 358, 360, 363, 370, 378, 384, 411, 411, 412, 415, 420, 425, 427, 448, 471, 482, 483, 508, 517, 533, 533, 533, 536, 539, 563, 584, 593, 607, 616, 627, 635, 639, 643, 649, 662, 665, 674, 684, 688, 699, 701, 704, 712, 716, 717, 757, 764, 772, 801, 817, 823, 836, 841, 843, 845, 890, 892, 899, 915, 917, 925, 936, 937, 941, 943, 948, 979, 979, 986]
#   puts "Bubble Sort: PASSED"
# else
#   puts "Bubble Sort: FAILED"
# end
ta2 = random_array(15)[0]
bubble_sort(ta2)[0]

  # r = bubble_sort_reducer(test_array1[0])
#
# puts "\e[31mRESULTS:
#     array size: #{test_array1[1]}
#       #{s[1]}
#       #{r[1]}
# ------------------------------------------------\e[0m"
#
#
# puts "test_array1: #{test_array1[0]}"


