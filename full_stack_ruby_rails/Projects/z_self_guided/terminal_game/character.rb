require_relative 'abilities/character_abilities'
require_relative 'test_methods'

class Character
  include CharacterAbilities
  include TestMethods

  attr_accessor :name, :level, :experience
  attr_accessor :health, :max_health, :strength, :defense, :speed, :wisdom
  attr_accessor :ability_points, :abilities, :marked_hits, :gold

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

    @gold = 5
  end

  def check_marked?
    state = false
    if self.instance_variable_defined?(:@marked)
      state = true

      @marked_hits ||= 0
      @marked_hits += 1

      if @marked_hits > 5
        puts "hunter's mark was worn off #{self.name}"
        state = false
        self.remove_instance_variable(:@marked)
        self.remove_instance_variable(:@marked_hits)
      end
    end

    state
  end

  def calculate_miss?
    random_number = rand(1..20)
    speed_modifier = (self.speed * 0.2).ceil.to_i

    return true if random_number == 20
    return true if random_number + speed_modifier > (20 + ((self.level / 2).floor))

    false
  end

  ## TODO: not sure that i actually need any return value from attack or use ability
  # leaving for now but return nil may be ok

  #could also return attack value and create a new method in each class, called the same,
  # that takes super and then calculates the damage via class specific logic <--
  def attack(target)
    if target.calculate_miss?
      attack_damage = nil
      puts "attack missed!"
    else
      random_number = rand((0 + self.level)..(9 + self.level))
      crit_chance = rand(1..20) == 20 ? 1.5 : 1.0

      puts "crit!" if crit_chance  == 1.5

      attack_damage = ((self.strength + random_number) * crit_chance).ceil.to_i
      puts "attack: #{self.strength + random_number}: after crit #{attack_damage}" if crit_chance  == 1.5
    end

    attack_damage
  end

  def use_ability(ability_name, target=nil)
    ability_output = self.send(ability_name.to_sym)

    puts "ability outputs: #{ability_output}"
    p "target: #{target.name}"

    if target && !ability_output.nil?
      if ability_output.is_a?(Array) && self.class == "Rouge"
        ability_output[0] += self.luck_check(ability_output[0])
        ability_output[1] += self.luck_check(ability_output[1])
      end

      if self.class == "Hunter" && target.check_marked?
        ability_output = (ability_output * 1.1).ceil.to_i
      end

      if ability_output.is_a?(Array)
        ability_output.each do |attack|
          return target.health -= [(attack - target.defense), 1].max
        end
      else
        return target.health -= [(ability_output - target.defense), 1].max
      end

      puts "target health after damage: #{target.health}"
    end
  end

  def exp_gain(amount)
    self.experience += amount

    if self.experience >= 100 + ((self.level - 1) * 10)
      self.experience -= 100
      return true
    else
      puts "#{self.name} gained #{amount} experience points. #{(100 + ((self.level - 1) * 10)) - self.experience} until level up."
    end

    false
  end

  def set_level(level, weight_list)
    return if %w[Warrior Rouge Hunter Wizard].include(self.class)
    level.times {self.level_up(weight_list, print=false) }
  end

  def level_up(weight_list, print=true)
    wl = weight_list

    self.level += 1
    puts "level increased from #{self.level - 1} to #{self.level}" if print

    health_boost = rand(1..(6 + wl[0]))
    self.health += health_boost
    self.max_health += health_boost
    puts "\e[32mhealth\e[0m increased by \e[92m#{health_boost}\e[0m to \e[32m#{self.health}\e[0m" if print

    str_boost = rand(1..10) >= (10 - wl[1]) ? 2 : 1
    self.strength += str_boost
    puts "\e[31mstrength\e[0m increased by \e[91m#{str_boost}\e[0m to \e[31m#{self.strength}\e[0m" if print

    spd_boost = rand(1..10) >= (10 - wl[2]) ? 2 : 1
    self.speed += spd_boost
    puts "\e[33mspeed\e[0m increased by \e[93m#{spd_boost}\e[0m to \e[33m#{self.speed}\e[0m" if print

    wis_boost = rand(1..10) >= (10 - wl[3]) ? 2 : 1
    self.wisdom += wis_boost
    puts "\e[34mwisdom\e[0m increased by \e[94m#{wis_boost}\e[0m to \e[34m#{self.wisdom}\e[0m" if print

    self.ability_points += (2 + wl[4])
    puts "\e[35mability points\e[0m increased by \e[95m#{2 + wl[4]}\e[0m to \e[35m#{self.ability_points}\e[0m" if print
  end

end

