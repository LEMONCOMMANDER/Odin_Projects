class Warrior < Character

  attr_accessor :rage , :rage_boost, :class
  attr_reader :weight_list

  WEIGHT_LIST = [6, 8, 5, 2, 2]

  def initialize(name)
    super()
    @name = name
    @class = "Warrior"
    @weight_list = WEIGHT_LIST

    self.health = 140
    self.max_health = 140
    @rage = 0
    @rage_boost = 0 #needs to reset to 0 at each battle

    self.strength = 8
    self.defense = 6
    self.speed = 4
    self.wisdom = 3

    self.abilities[:pummel] = AbilityDefs::PUMMEL
    self.abilities[:rage] = AbilityDefs::RAGE
  end

  def reset_boost
    @rage_boost = 0
  end

  def check_rage
    ninety = (self.max_health * 0.9)
    seventy_five = (self.max_health * 0.75)
    fifty = (self.max_health * 0.5)
    twenty_five = (self.max_health * 0.25)

    if self.health > seventy_five && self.health <= ninety
      @rage = 1 + self.rage_boost
    elsif self.health > fifty && self.health <= seventy_five
      @rage = 2 + self.rage_boost
    elsif self.health > twenty_five && self.health <= fifty
      @rage = 3 + self.rage_boost
    elsif self.health <= twenty_five
      @rage = 4 + self.rage_boost
    end
  end

  def attack(target)
    attack_damage = super(target)

    unless attack_damage.nil?
      target.health -= [(attack_damage - target.defense), 1].max
      puts "target health after damage: #{target.health}"
    end
  end

  def exp_gain(amount)
    need_to_level_up = super(amount)
    if need_to_level_up
      level_up(WEIGHT_LIST)
    end
  end

end