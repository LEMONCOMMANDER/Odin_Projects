require_relative 'abilities/character_abilities'

class Character
  include CharacterAbilities

  attr_accessor :name, :level, :experience, :health, :max_health, :strength, :defense, :speed, :wisdom, :ability_points, :abilities

  def initialize(name)
    @name = name
    @level = 1
    @experience = 0

    @health = 100
    @max_health = 100

    @strength = 5
    @defense = 5
    @speed = 5
    @wisdom = 5

    @defense = 5
    @ability_points = 10
    @abilities = {}
  end
end

