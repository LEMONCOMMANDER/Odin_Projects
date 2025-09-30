require_relative 'ability_defs'

module CharacterAbilities
  def heal
    if self.abilities.has_key?(:heal)
      if self.ability_points >= 3
        base = 10 + self.level + self.wisdom
        range = rand(1..(6 + self.wisdom))
        self.health = [(self.health + base + range), self.max_health].min

        self.ability_points = [(self.ability_points - 3), 0].max
      end
    end
  end

end