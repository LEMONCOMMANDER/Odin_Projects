require_relative '../modules/climbing'


class Monkey < Mammal
  include Climbing

  def initialize(name, gender)
    super(name, gender)

    @upright = true
    @has_thumbs = true
    @is_human = false
  end
end