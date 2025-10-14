module TestMethods
  def force_level(level, weight_list)
    level.times do
      level_up(weight_list, false)
      check_for_new_abilities
    end
  end

  def attack_with_miss(target)
    attack_damage = nil
    puts "attack missed!"
  end

  def generate_crit
    random_number = rand((0 + self.level)..(9 + self.level))
    crit_chance = 1.5

    puts "no miss | crit is enabled in test method"

    attack_damage = ((self.strength + random_number) * crit_chance).ceil.to_i
    puts "attack: #{self.strength + random_number}: after crit #{attack_damage}" if crit_chance  == 1.5

    attack_damage
  end

  def attack_with_crit(target)
    attack_damage = generate_crit
    calculate_damage(attack_damage, target)
  end

  def attack_with_crit_and_lucky(target)
    get_damage = generate_crit
    luck_damage = apply_lucky(get_damage)
    puts "boosted damage from #{get_damage} to #{luck_damage} with lucky"
    calculate_damage(luck_damage, target)
  end

  def attack_with_crit_and_marked(target)
    get_damage = generate_crit
    if target.check_marked?
      marked_damage = apply_marked_damage(get_damage)
      puts "boosted damage from #{get_damage} to #{marked_damage} with marked"
      calculate_damage(marked_damage, target)
    else
      puts "target is not marked but on crit damage: #{get_damage}, marked damage would be: #{apply_marked_damage(get_damage)}"
    end
  end

  def set_marked(number)
    self.instance_variable_set(:@marked, true)
    self.instance_variable_set(:@marked_hits, number)
  end

  def remove_marked
    self.remove_instance_variable(:@marked) if self.instance_variable_defined?(:@marked)
    self.remove_instance_variable(:@marked_hits) if self.instance_variable_defined?(:@marked_hits)
  end

  def always_lucky?
    true if self.instance_variable_defined?(:@always_lucky)
  end

  def always_lucky
    @always_lucky = true
  end

  def reset_luck
    return unless self.instance_variable_defined?(:@always_lucky)
    self.remove_instance_variable(:@always_lucky)
  end

  def set_dodge
    self.instance_variable_set(:@dodge, true)
  end

  private

  def apply_lucky(damage)
    lucky_mod = self.level < 10 ? 0.5 : 1
    damage + (damage * lucky_mod).ceil.to_i
  end

  def apply_marked_damage(damage)
    (damage * 1.1).ceil.to_i
  end

  def calculate_damage(damage, target)
    target.health -= [(damage - target.defense), 1].max
    puts "#{target.name} health: #{target.health}"
    puts "damage dealt: #{[(damage - target.defense), 1].max}"
  end
end
