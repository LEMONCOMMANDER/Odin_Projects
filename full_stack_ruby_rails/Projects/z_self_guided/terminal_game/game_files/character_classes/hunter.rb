class Hunter < Character

  attr_accessor :target_hits, :class
  attr_reader :weight_list

  WEIGHT_LIST = [4, 4, 5, 5, 4]

  def initialize(name)
    super(name)
    @class = "Hunter"
    @weight_list = WEIGHT_LIST

    self.speed = 6
    self.wisdom = 6
    self.strength = 4
    self.ability_points = 15

    self.abilities[:hunters_mark] = AbilityDefs::HUNTERS_MARK #all damage deals extra 10%
    self.abilities[:quick_shot] = AbilityDefs::QUICK_SHOT
  end

  def attack(target)
    attack_damage = super(target)

    unless attack_damage.nil?
      if target.check_marked?
        attack_damage = (attack_damage * 1.1).ceil.to_i
        # range is 1 to 6
        puts "target is marked for #{6 - target.marked_hits} more hits"
      end

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