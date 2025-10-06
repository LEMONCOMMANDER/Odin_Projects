class Rouge < Character

  attr_accessor :class, :lucky
  attr_reader :weight_list

  WEIGHT_LIST = [3, 6, 8, 3, 3]

  def initialize(name)
    super()
    @name = name
    @class = "Rouge"
    @weight_list = WEIGHT_LIST
    @lucky = true

    self.health = 90
    self.max_health = 90

    self.defense = 3
    self.speed = 8
    self.ability_points = 15


    self.abilities[:lucky] = AbilityDefs::LUCKY
    self.abilities[:double_strike] = AbilityDefs::DOUBLE_STRIKE
  end

  def luck_check(damage)
    roll = rand(1..20)
    modifier = self.level < 6 ? 1 : 2

    if roll >= 20 - modifier
      puts "Lucky strike! Bonus 50% damage!"
      lucky_mod = self.level < 10 ? 0.5 : 1
      bonus_damage = (damage * lucky_mod).ceil.to_i
    else
      bonus_damage = 0
    end

    bonus_damage
  end

  def attack(target)
    attack_damage = super(target)

    unless attack_damage.nil?
      if self.always_lucky?
        puts "testing lucky"
        lucky_mod = self.level < 10 ? 0.5 : 1
        attack_damage = attack_damage(lucky_mod)
      else
        attack_damage += self.luck_check(attack_damage) unless attack_damage.nil?
      end

      target.health -= [(attack_damage - target.defense), 1].max

      puts "damage dealt: #{[(attack_damage - target.defense), 1].max}"
      puts "target health after damage: #{target.health}"
    end
    #no return value
  end

  def exp_gain(amount)
    need_to_level_up = super(amount)
    if need_to_level_up
      level_up(WEIGHT_LIST)
    end
  end

end