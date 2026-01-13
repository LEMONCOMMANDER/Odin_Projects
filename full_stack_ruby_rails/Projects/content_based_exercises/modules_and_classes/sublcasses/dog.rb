require_relative '../modules/swimming'

class Dog < Mammal
  include Swimming

  attr_accessor :breed, :trained

  ## we will likely instantiate a dog rather than a mammal. we still want to do everything in the mammal initialize method,
  # so we call super to do that. After, we can add special dog related stuff
  def initialize(name, gender, breed)
    super(name, gender)
    @breed = breed
    @has_claws = true
    @trained = false
    @is_pet = false
  end


  ## we overwrite the get_info method from the parent class. When called on dog, it will reference the method defined here
  # instead of in the parent class. But we still want all the stuff from there so we use super again.
  def get_info
    puts "this is from a dog subclass"
    super
  end

  ## references instance variable from parent class - @alive. This bark method doesn't exist for Mammal but does only for Dog
  def bark
    if is_alive?
      puts "#{name} says Woof Woof!"
    else
      puts "#{name} cannot bark - it is not alive."
    end
  end

end