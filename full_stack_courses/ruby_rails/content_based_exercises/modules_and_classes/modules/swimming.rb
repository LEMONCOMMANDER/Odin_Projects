module Swimming
  def swim_forward
    puts "i am swimming forward"
  end

  def swim_backward
    puts "i am swimming backward"
  end

  def dive
    depth = rand(1..10)
    puts "i am diving to a depth of #{depth} feet"
  end
end