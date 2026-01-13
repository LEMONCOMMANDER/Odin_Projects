=begin
  As mentioned in readme, this represents a parent class. Something like a user, and if you have different types of users,
  those could represent subclasses of user. For example, AdminUser < User, GuestUser < User, etc.

  in this example, we will be doing a class called mammal.

  @@ refer to class variables and @ refer to instance variables. Class mehtods (defined with self. in the method name) are
  called on the class itself - Mammal.mammal_count - while instance methods are called on instances of the class:
       mammal1 = Mammal.new('dog', 'male') --> mammal1.get_info

  We first start with the attr - this creates getter, setter, or both types of methods for the instance variables defined
  in the class. We start with an init function that is called automatically when a new class object is instantiated. We
  have required 2 arguments - a name and gender. We do some quick validation on gender to demonstrate init validation.

  Next we define some instance variables that are common to all mammals. These are set to default values in the init method.
  Then we have some methods that are included with all mammals.
=end

require_relative '../modules/gender_methods'

class Mammal

  # all Mammals will have access to the methods defined in GenderMethods module
  include GenderMethods

  attr_accessor :name, :gender, :alive
  attr_reader :warm_blooded, :breates_air, :appendages, :heart_chambers, :middle_ear_bones


  @@mammal_count = 0

  ## this is a class method - it is called on the class itself, not on an instance
  def self.mammal_count
    @@mammal_count
  end

  def self.class_info
    puts "this is a mammal class. Mammals are warm blooded creatures that breathe are. They have 4 appendages, and have fur or hair."
  end

  ## this init function is called whenever a new instance is created
  def initialize(name, gender)
    gender_options = ['male, female']
    raise ArgumentError unless gender_options.include?(gender.strip.downcase)

    @appendages = 4
    @breates_air = true
    @warm_blooded = true
    @heart_chambers = 4
    @middle_ear_bones = 3

    @alive = true
    @name = name
    @gender = gender

    @@mammal_count += 1
  end

  def get_info
    puts "Name: #{name}"
    puts "Gender: #{gender}"
    puts "Alive: #{alive}"
    puts "Warm Blooded: #{warm_blooded}"
    puts "Appendages: #{appendages}"
  end

  def is_alive?
    alive
  end

  def breathe
    if is_alive && breates_air
      puts "#{name} is breathing."
    else
      puts "#{name} cannot breathe."
    end
  end

  def death
    self.alive = false
    puts "#{name} has died."
  end

end