class Rouge < Character

  attr_accessor :class, :lucky

  def initialize(name)
    super()
    @name = name
    @class = "Rouge"
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
    if roll >= 19
      bonus_damage = (damage * 0.5).ceil.to_i
    else
      bonus_damage = 0
    end

    bonus_damage
  end
end