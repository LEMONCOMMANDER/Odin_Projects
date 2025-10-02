require_relative 'abilities/character_abilities'

class Character
  include CharacterAbilities

  attr_accessor :name, :level, :experience, :health, :max_health, :strength, :defense, :speed, :wisdom, :ability_points, :abilities

  def initialize
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

  def check_marked
    if self.instance_variable_defined?(:@marked)
      @marked_hits = 0
      #todo: when battle is determined, use this to track hits and remove IVs on 5th hit
    end
  end

  def calculate_miss?
    random_number = rand(1..20)
    speed_modifier = (self.speed * 0.2).ceil.to_i

    return true if random_number == 20
    return true if random_number + speed_modifier > (20 + ((self.level / 2).floor))

    false
  end

  def attack(target)
    if target.calculate_miss?
      attack_damage = nil
    else
      random_number = rand((0 + self.level)..(9 + self.level))
      crit_chance = rand(1..20) == 20 ? 1.5 : 1.0
      attack_damage = [((self.strength + random_number) * crit_chance).ceil.to_i - target.defense, 1].max
    end

    if self.class == "Rouge"
      attack_damage += self.luck_check(attack_damage) unless attack_damage.nil?
    end

    attack_damage
  end

  def use_ability(ability_name, target=nil)
    if target
      ability_output = self.send(ability_name.to_sym, target)
    else
      ability_output = self.send(ability_name.to_sym)
    end

    if target && !ability_output.nil?
      if ability_output.is_a?(Array) && self.class == "Rouge"
        ability_output[0] += self.luck_check(ability_output[0])
        ability_output[1] += self.luck_check(ability_output[1])
      end

      if ability_output.is_a?(Array)
        ability_output.each do |attack|
          target.health -= [(attack - target.defense), 1].max
        end
      else
        target.health -= [(ability_output - target.defense), 1].max
      end

    end
  end

end

