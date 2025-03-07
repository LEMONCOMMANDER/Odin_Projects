def bubble_sort(array)
  switch = 0
  p array
  output = array.each_with_index.map do |value, index|
    unless (index + 1) > (array.length - 1)
      if value > array[index + 1]
        switch = 1
        backcheck = 0
        while switch == 1
          clone = array[index - backcheck] # clones current value
          p "clone: #{clone}"
          value = array[(index - backcheck) + 1] # replaces current value with lower value of next index
          p "value: #{value}"
          array[(index - backcheck) + 1] = clone # replaces next index with current value
          p "-------------"


          if index == 0
            switch = 0
          else
            backcheck += 1
            unless array[index - backcheck] < array[(index - backcheck) + 1]
              switch = 0
            end
          end

        end # while
      end # if - compare
    end # unless - array length
    value
  end # each_with_index
  p output
end

bubble_sort([4,3,78,2,0,2])