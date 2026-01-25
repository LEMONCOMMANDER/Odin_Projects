require_relative '../modules/swimming'
require_relative '../modules/climbing'


class Human < Mammal
  include Climbing
  include Swimming
  def initialize(name, gender)
    super(name, gender)

    @upright = true
    @has_thumbs = true
    @is_human = true
  end
end