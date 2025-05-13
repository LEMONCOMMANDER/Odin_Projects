require_relative './chassis'
require_relative './head'
require_relative './legs'
require_relative './arms'
require_relative './robot_mods'
require_relative 'ability_type'

#ability types are defensive (takes a damage), offensive (happens during any attack), or accuracy based (triggers on miss and is fed a "hit" boolean)
class Robot
  include Chassis
  include Head
  include Legs
  include Arms
  include RobotMods

  def reset
    @@robot_count = 0
  end
  @@robot_count = 0

  attr_accessor :id, :head, :chassis, :arms, :legs, :mod1, :mod2, :mod3, :health, :acc, :damage, :armor, :speed, :ap
  attr_reader :max_health, :max_acc, :max_damage, :max_speed, :max_armor, :max_ap
  attr_reader :head_ability, :chassis_ability, :legs_ability, :arms_ability, :used, :regen

  def initialize
    @@robot_count ||= 0
    @@robot_count += 1

    @health = 12
    @acc = 10
    @damage = 5
    @armor = 5
    @speed = 5
    @ap = 5


    @id = @@robot_count
    @head =  self.equip_head(self, self.choose_head)
    @chassis = self.equip_chassis(self, self.choose_chassis)
    @arms = self.equip_arms(self, self.choose_arms)
    @legs = self.equip_legs(self, self.choose_legs)
    @mod1 = self.equip_mod(self, self.choose_mod(1), self.set_rarity)
    @mod2 = self.equip_mod(self, self.choose_mod(2), self.set_rarity)
    @mod3 = self.equip_mod3(self)

    self.finalize
  end

  def finalize
    @max_health = self.health
    @max_acc = self.acc
    @max_damage = self.damage
    @max_speed = self.speed
    @max_armor = self.armor
    @max_ap = self.ap
  end

  def display(gear = false, stats = false)
    if gear == false && stats == false
      gear = true
      stats = true
    end

    if gear
      puts <<~GEAR
        ____________EQUIPMENT_____________
        \e[31m          ID:       #{self.id}\e[0m
                  Head:     \e[32m#{self.head}\e[0m
                  Chasis:   \e[32m#{self.chassis}\e[0m
                  Arms:     \e[32m#{self.arms}\e[0m
                  Legs:     \e[32m#{self.legs}\e[0m
                  Mod1:     \e[32m#{self.mod1}\e[0m
                  Mod2:     \e[32m#{self.mod2}\e[0m
                  Mod3:     \e[32m#{self.mod3}\e[0m
        _________________________________
      GEAR
      end

    if stats
      puts <<~STATS
        ____________STATS________________
                Health:     \e[34m#{self.health}\e[0m
                Acc:        \e[34m#{self.acc}\e[0m
                Damage:     \e[34m#{self.damage}\e[0m
                Armor:      \e[34m#{self.armor}\e[0m
                Speed:      \e[34m#{self.speed}\e[0m
                AP:         \e[34m#{self.ap}\e[0m
        _________________________________
      STATS
    end
  end

  def has_regen?
    return false unless @regen
  end

  def details(txt = true)
    puts "\e[31m----------- HEAD ------------\e[0m"
    self.head_details(txt)
    puts "\e[31m-----------------------------\e[0m"

    puts "\e[31m---------- CHASSIS ----------\e[0m"
    self.chassis_details(txt)
    puts "\e[31m-----------------------------\e[0m"

    puts "\e[31m----------- LEGS ------------\e[0m"
    self.legs_details(txt)
    puts "\e[31m-----------------------------\e[0m"

    puts "\e[31m----------- ARMS ------------\e[0m"
    self.arms_details(txt)
    puts "\e[31m-----------------------------\e[0m"
  end

  def e_att_mod(*target)
    total_damage = 0
    iv = self.instance_variables
    puts "\e[31mHacked\e[0m" if iv.include?(:@hacked)
    return 0 if iv.include?(:@hacked)

    [:@head_ability, :@arms_ability, :@chassis_ability].shuffle.each do |v|
      next unless self.head_ability?
      next unless self.chassis_ability?

      ability = self.instance_variable_get(v)[:ability]
      if v == @head_ability && self.head_ability? && self.instance_variable_get(v)[:type] == AbilityType::OFFENSIVE
        total_damage += self.method(ability).call
      end

      if v == @chassis_ability && self.chassis_ability? && self.instance_variable_get(v)[:type] == AbilityType::OFFENSIVE
        total_damage += self.method(ability).call
      end

      if v == :@arms_ability && self.instance_variable_get(v)[:type] == AbilityType::OFFENSIVE
        total_damage += self.method(ability).arity == 1 ? self.method(ability).call(target.first) : self.method(ability).call
      end
    end
    total_damage
  end

  def e_d_mod(damage)
    output = []
    if self.instance_variable_defined?(:@head_ability) || self.instance_variable_defined?(:@chassis_ability)
      if self.head_ability? && self.head_ability[:type] == AbilityType::DEFENSIVE && self.head_ability[:ability] == :disperse
        output << self.method(head_ability[:ability]).call(damage) # resolves 0
      else
        output << 1
      end

      return [0, 1] if output[0] == 0

      if self.chassis_ability? && self.chassis_ability[:type] == AbilityType::DEFENSIVE && self.chassis_ability[:ability] == :evade
        output << self.method(chassis_ability[:ability]).call #resolves 0.5
      else
        output << 1
      end
    else
      2.times { output << 1 }
    end

    output
  end


  def e_ac_mod
    #ONLY NEEDS TO CHECK IV FOR BUFFS!!

    #if self has any debuff, (attribute - (temp var = debuff amount))
    # if self has any buff, (attribute + (temp var = buff amount))
    return 0 unless self.instance_variable_defined?(:@a_buff)

    self.send(arms_ability[:ability]) if self.arms_ability[:type] == :ACCURACY
  end


  def attack(c = true, defender)
    # puts defender
    crit = rand(1..20) == 20 ? true : false
    crit = false if c == false
    puts "crit true" if crit
    #                                      target
    (rand(1..6) + self.damage + e_att_mod(defender)) * (crit ? 2 : 1)
  end
end


