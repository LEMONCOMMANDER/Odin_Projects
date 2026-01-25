=begin
  this is a pretty dumb module but it shows some interesting things:
    1. a way to organize nested modules (not sure that this a common use case but i think its cool). requires including the
        submodules at the end of the parent module.
    2. both genders have a urinate method, and only 1 will trigger depending on self. This lets us categorize differences in methods
        in a different way. We could have built logic into a single method, or we can add it like this
    3. technically, all mammals will have access to all these methods but the early exit logic prevents males from using female
        methods and vice versa.
=end


module GenderMethods
  ## both sub modules should have this method
  def is_male?
    true if self.gender == 'male'
  end

  module Male
    def beard
      return unless self.is_male?
      puts "i traditionally have the ability to grow hair on my face"
      @beard ||= true
    end

    def shave
      return unless self.is_male?
      if @beard
        puts "i am shaving my beard"
        @beard = false
      else
        puts "i have no beard to shave"
      end
    end
  end

  module Female
    def breasts
      return if self.is_male?
      puts "my chest expands so that i may potentially produce milk for my offspring"
      @breasts ||= true
    end

    def can_have_babies?
      return if self.is_male?
      puts true
    end
  end

  module Shared
    def urinate
      statement = self.is_male? ? "i can stand when i pee" : "i usually sit when i pee"
      puts statement
    end
  end

  include Male
  include Female
  include Shared
end