class Wizard < Character

  attr_accessor :class
  attr_reader :weight_list

  WEIGHT_LIST = [2, 3, 5, 8, 6]

  def initialize(name)
    super()
    @name = name
    @class = "Wizard"
    @weight_list = WEIGHT_LIST

    self.health = 80
    self.max_health = 80

    self.wisdom = 8
    self.ability_points = 20
    self.strength = 3

    self.abilities[:mend] = AbilityDefs::MEND
    self.abilities[:shock] = AbilityDefs::SHOCK
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