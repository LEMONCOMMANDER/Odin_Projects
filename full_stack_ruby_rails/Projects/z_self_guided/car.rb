class Car
  attr_accessor :color, :model, :speed, :is_on
  attr_reader :year
  def initialize (year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
  end


  def start_car
    self.is_on = true
    p 'chug chug chug chug ROOOOSH'
  end

  def stop_car
    self.is_on = false
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
      p "The engine is #{is_on ? "on and driving #{speed} mph" : 'off'}"
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

  def self.fuel(car)
    puts "the #{car.year} #{car.model} has a fuel efficiency of #{rand(20..60)} miles per gallon"
  end

  def to_s
    puts "I am a vehicle with the following information:"
    self.car_info
    Car.fuel(self)

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

# puts ""
# puts "Let's check the car's metrics:"
# Car.fuel(car)

puts ""
car.to_s
