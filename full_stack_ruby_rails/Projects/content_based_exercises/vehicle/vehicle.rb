require_relative './orts.rb'
require_relative './ul.rb'
# vehicle class
class Vehicle

  attr_accessor :doors, :tires, :engine, :frame, :drive, :state, :rate, :sport, :noise, :haul, :towing

  @@vehicle_count = 0
  @@suv_count = 0

  def initialize(drive = 'Automatic')
    unless ['AUTOMATIC', 'MANUAL'].include? drive.upcase
      raise ArgumentError.new('"drive" must be either: automatic or manual')
    end
    self.state = false
    @@vehicle_count += 1
  end

  def self.get_count
    puts "Total vehicles: #{@@vehicle_count}"
  end

  def start_engine
    puts 'vroom vroom'
    self.state = true
  end

  def stop_engine
    puts 'sputter sputter sputter'
    self.state = false
  end

  def v_inspect
    puts <<~VEHICLE_CHECK
      \e{32m VEHICLE CHECK
      ___________________ DOORS:   #{self.doors}
      ___________________ TIRES:   #{self.tires}
      ___________________ ENGINE:  #{self.engine}
      ___________________ DRIVE:   #{self.drive}
      ___________________ FRAME:   #{self.frame}
      ___________________ STATE:   #{self.state ? 'ON' : 'OFF'}
      ___________________ Accel:   #{self.rate} / second
    VEHICLE_CHECK
  end

  #TODO: add drive abilities: left right, speed up, slow down

end

# a vehicle in the format of a truck
class Truck < Vehicle
  include Haul
  # Truck.haul

  attr_accessor :haul, :towing, :towed_obj

  @@truck_count = 0
  def initialize(drive = 'Automatic')
    super(drive)
    @@truck_count += 1

    @doors = 4
    @engine = 'V8'
    @tires = 4
    @drive = drive.downcase.capitalize
    @frame = 'Truck'
    @state = false
    @rate = 3
    self.big_car
  end
  def self.get_count
    puts "TRUCKS: #{@@truck_count}"
  end

  def v_inspect
    super()
    puts "___________________ HAUL:   #{self.haul}"
    puts "___________________ TOWING: #{self.towed_obj}" if towed_obj
  end
end

# a car can be a sedan or coup
class Car < Vehicle
  include Sports

  @@sedan_count = 0
  @@coupe_count = 0
  def initialize(drive = 'Automatic', type)
    unless ['COUP', 'SEDAN'].include? type.upcase
      raise ArgumentError.new('"type" must be: sedan or coup')
    end
    super(drive)

    def create_coup(drive)
      @@coupe_count += 1

      @doors = 2
      @engine = 'V4'
      @tires = 4
      @drive = drive.downcase.capitalize
      @frame = 'Coup'
      @state = false
      @rate = 5
    end

    def create_sedan(drive)
      @@sedan_count += 1

      @doors = 4
      @engine = 'V4'
      @tires = 4
      @drive = drive.downcase.capitalize
      @frame = 'Sedan'
      @state = false
      @rate = 5
    end

    if type.upcase == 'SEDAN'
      create_sedan(drive)
    else
      create_coup(drive)
    end
  end

  def v_inspect
    super()
    if self.sport
     puts <<~SPORT
        ___________________ SPORTS:   #{self.sport}
        ___________________ NOISY:   #{self.noise}
      SPORT
    end
  end

  def make_sports
    return if self.frame == "Sedan"
    super()
  end

  def self.get_count(type = 'all')
    puts "SEDANS: #{@@sedan_count}" unless type == 'coup'
    puts "COUPS: #{@@coupe_count}" unless type == 'sedan'
  end
end

# creates an suv
class Suv < Vehicle
  include Sports
  include Haul

  attr_accessor :haul, :towing, :towed_obj

  @@suv_count = 0
  def initialize(drive = "automatic")
    super(drive)

    @doors = 4
    @engine = 'V6'
    @tires = 4
    @drive = drive.downcase.capitalize
    @frame = 'SUV'
    @state = false
    @rate = 4
    self.big_car
  end

  def v_inspect
    super()
    if self.sport
    puts <<~SPORT
        ___________________ SPORTS:   #{self.sport}
        ___________________ NOISY:   #{self.noise}
      SPORT
    end
    if self.haul
      puts "___________________ HAUL:   #{self.haul}"
      puts "___________________ TOWING: #{self.towed_obj}" if towed_obj
    end
  end
end

truck = Truck.new('manual')
car = Car.new('manual', 'sedan')
car2 = Car.new('manual', 'coup')
truck2 = Truck.new('automatic')
suv = Suv.new('automatic')

suv.v_inspect
suv.make_sports
suv.v_inspect

suv.tow(car)
suv.v_inspect

suv.drop
suv.v_inspect

suv.tow(truck)
suv.v_inspect


# truck.v_inspect
#
# truck.tow(car)
# truck.drop





