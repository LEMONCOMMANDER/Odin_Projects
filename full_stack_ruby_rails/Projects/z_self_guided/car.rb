class Car
  attr_accessor :color, :model, :speed, :engine
  attr_reader :year
  def initialize (year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def start_car
    self.engine = "on"
    p 'chug chug chug chug ROOOOSH'
  end

  def stop_car
    self.engine = "off"
    self.speed = 0
    p 'sputter sputter sputter...'
  end

  def speed_up(speed = 5)
    self.speed += speed
    p "speeding up to #{self.speed} mph"
  end

  def break(speed = 5, stop: false)
    if stop == true
      self.speed = 0
      p "SCREEEEEECH"
    else
      self.speed -= speed
      p "slowing down to #{self.speed} mph"
    end
  end
  def drive_info
    if engine == "off"
      p "The engine is #{engine}"
    else
      p "the engine is #{engine} and driving #{speed} mph"
    end
  end


  def car_info
    p "the #{model} is a #{color} #{year} model"
  end

  def workshop(new_color=nil)
    if new_color
      self.color = new_color
    end
    car_info
  end
end


car = Car.new(2021, "red", "Toyota")
car.start_car
5.times do
  puts "Vroom Vroom"
  car.speed_up(10)
  puts ""
end

puts ""
car.drive_info

2.times do
  puts ""
  car.break
end

puts ""
car.drive_info

puts ""
car.break(stop: true)
car.drive_info

puts ""
car.stop_car
car.drive_info

puts ""
puts "WELCOME TO THE WORKSHOP"
car.car_info
puts ""
puts "lets get that changed"
puts ""
car.workshop("blue")
# car.car_info
