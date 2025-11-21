require_relative './abilities/character_abilities'
require_relative './test_methods'

class Character
  include CharacterAbilities
  include TestMethods

  attr_accessor :name, :level, :experience
  attr_accessor :health, :max_health, :strength, :defense, :speed, :wisdom
  attr_accessor :ability_points, :abilities, :marked_hits, :gold
  attr_accessor :head, :chest, :arms, :legs, :weapon, :shield, :accessory


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

    @ability_points = 10
    @abilities = {}

    @gold = 5

    @head = nil
    @chest = nil
    @arms = nil
    @legs = nil
    @weapon = nil
    @shield = nil
    @accessory = nil
  end

  #hiding instance variables from equipment
  def inspect
    head_name = @head ? @head.name : nil
    chest_name = @chest ? @chest.name : nil
    arms_name = @arms ? @arms.name : nil
    legs_name = @legs ? @legs.name : nil
    weapon_name = @weapon ? @weapon.name : nil
    shield_name = @shield ? @shield.name : nil
    accessory_name = @accessory ? @accessory.name : nil
    puts "CHARACTER: #{@name}, LVL: #{@level}, EXP: #{@experience}, HP: #{@health}/#{@max_health}, STR: #{@strength}, DEF: #{@defense}, SPD: #{@speed}, WIS: #{@wisdom}, AP: #{@ability_points}, GOLD: #{@gold}, head: #{head_name}, chest: #{chest_name}, arms: #{arms_name}, legs: #{legs_name}, weapon: #{weapon_name}, shield: #{shield_name}, accessory: #{accessory_name}, abilities: #{@abilities}"
  end

  def equip(item)
    item_type = item.type

    if self.send(item_type)
      old_item = self.send(item_type)
      self.unequip(old_item)
    end

    self.send("#{item_type}=", item)
    update_stats(item)
  end

  def unequip(old_item)
    old_item_type = old_item.type
    self.send("#{old_item_type}=", nil) if self.send(old_item_type) #set nil if item slot is used || leave nil
    update_stats(old_item)
  end

  def update_stats(item)
    item_info = item.return_item_info

    if self.send(item.type) #if item slot is not nil
      item_info[:stats].each do |stat, value|
        new_owner_stat = (self.send(stat) + value)
        self.send("#{stat}=", new_owner_stat ) #health will in/decrease with item equip unless stat == :health
        self.max_health += value if stat == :health
      end

      if item_info[:item_abilities]
        item_info[:item_abilities].each do |ability, info|
          owner_abilities = self.abilities
          unless owner_abilities[ability] #won't add an ability if the user already has it
            owner_abilities[ability] = info
            info[:native] = false #add native:false tag to mark for delete on unequip
          end
        end
      end
    else #no item equipped
      item_info[:stats].each do |stat, value|
        new_owner_stat = (self.send(stat) - value)
        self.send("#{stat}=", new_owner_stat )
        self.max_health -= value if stat == :health
      end

      if item_info[:item_abilities]
        item_info[:item_abilities].each do |ability, info|
          owner_abilities = self.abilities
          owner_abilities.delete(ability.to_sym) if owner_abilities[ability][:native] == false
        end
      end
    end

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

  def attack(target)
    if target.calculate_miss?
      attack_damage = nil
      puts "attack missed!"
    else
      if target.instance_variable_defined?(:@dodge)
        target.remove_instance_variable(:@dodge)
        attack_damage = nil
        puts "#{target.name} dodged the attack!"
        return attack_damage
      end

      random_number = rand((0 + self.level)..(9 + self.level))
      lethal_mods = self.instance_variable_defined?(:@lethal) ? [19, 2.0] : [20, 1.5]
      crit_chance = rand(1..20) >= lethal_mods[0] ? lethal_mods[1] : 1.0
      #                              19 or 20         2.0 or 1.5

      puts "crit!" if crit_chance >= 1.5

      attack_damage = ((self.strength + random_number) * crit_chance).ceil.to_i
      puts "attack: #{self.strength + random_number}: after crit #{attack_damage}" if crit_chance  == 1.5
    end

    attack_damage
  end

  def use_ability(ability_name, target=nil)
    if target.instance_variable_defined?(:@dodge)
      puts "#{target.name} dodged the attack!"
      return
    end

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
           target.health -= [(attack - target.defense), 1].max
           return
        end
      else
          target.health -= [(ability_output - target.defense), 1].max
          return
      end

      puts "target health after damage: #{target.health}"
    end
  end

  def exp_gain(amount)
    self.experience += amount

    if self.experience >= 100 + ((self.level - 1) * 10)
      self.experience -= 100
      self.experience = 0 if self.level == 10
      return true
    else
      next_level =  "#{self.name} gained #{amount} experience points. #{(100 + ((self.level - 1) * 10)) - self.experience} until level up."
      max_level = "#{self.name} is at max level."
      puts self.level < 10 ? next_level : max_level
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
