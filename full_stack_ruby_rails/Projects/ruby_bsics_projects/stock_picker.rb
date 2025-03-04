=begin
  Implement a method #stock_picker that takes in an array of stock prices, one for each hypothetical day.
  It should return a pair of days representing the best day to buy and the best day to sell. Days start at 0.

  > stock_picker([17,3,6,9,15,8,6,1,10])
  => [1,4]  # for a profit of $15 - $3 == $12

=end

def error_text(message)
  #assignment  condition   if     true=            or         false=
  message = message.empty? ? "no error text given" : "\e[31m#{message}\e[0m"
  message
end

def stock_picker(prices)
  if prices.all? {|data| data.class == Array}
    stack = []

    prices.each_with_index do |price, index|
      if index > 6
        index = 0
      end
      stack.append([index, price.max])
    end

    #max_by is an enumerable that iterates through each item (defined in the block) and returns the max value
    output = stack.max_by {|data| data[1]}
    p "multiple days: #{output}"
    output

  elsif prices.all? {|data| data.class == Integer}
    output = [0, prices.max]
    p "single day: #{output}"
    output
  else
    #ANSI escape code for red text
    raise error_text("ERROR -- All children items need to either be all arrays or all integers:\nENTRY: #{prices}")
  end
end


stock_picker([17,3,6,9,15,8,6,1,10])
stock_picker([[17,3,6,9,15,8,6,1,10], [17,3,6,9,15,8,6,1,10], [18,3,6,9,15,8,6,1,10]])
stock_picker([[17,3,6,9,15,8,6,1,10], 45, [17,3,6,9,15,8,6,1,10]])