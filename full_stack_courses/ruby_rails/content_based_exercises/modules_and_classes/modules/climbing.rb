module Climbing

  def climb_up
    puts "i am going up"
  end

  def climb_down
    puts "i am going down"
  end

  def get_elivation
    num = rand(1..100)
    if num == 1
      puts "i am at ground level"
    else
      puts "i am at #{num} feet off the ground"
    end
  end
end