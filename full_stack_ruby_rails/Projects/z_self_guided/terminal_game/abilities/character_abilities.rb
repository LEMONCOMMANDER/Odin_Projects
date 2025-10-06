require_relative 'ability_defs'

module CharacterAbilities
  #todo: create print statements for ability feedback in terminal
  module Magic
    def mend
      return unless self.abilities.has_key?(:heal)

      if self.ability_points >= 3
        base = 10 + self.level + self.wisdom
        range = rand(1..(6 + self.wisdom))
        self.health = [(self.health + base + range), self.max_health].min

        self.ability_points = [(self.ability_points - 3), 0].max
        #todo: print healing message | return nil
      end
    end

    def fireball
      return unless self.abilities.has_key?(:fireball)


      if self.ability_points >= 5
        base = 6 + self.level + self.wisdom
        range = rand(1..(8 + self.wisdom))
        ability_damage = base + range

        self.ability_points = [(self.ability_points - 5), 0].max
        ability_damage
      end
    end

    def shock
      return unless self.abilities.has_key?(:shock)

      if self.ability_points >= 4
        base = 6 + self.level + self.wisdom
        range = rand(1..(4 + self.wisdom))
        ability_damage = base + range

        self.ability_points = [(self.ability_points - 4), 0].max
        ability_damage
      end
    end
  end

  module Physical
    def pummel
      return unless self.abilities.has_key?(:pummel)

      if self.ability_points >= 5
        base = 8 + self.level + self.strength + self.rage
        range = rand(1..(8 + self.strength))
        ability_damage = base + range

        self.ability_points = [(self.ability_points - 5), 0].max
        ability_damage
      end
    end

    def quick_shot
      #will always go first
      return unless self.abilities.has_key?(:quick_shot)

      if self.ability_points >= 3
        base = 5 + self.level
        range = rand(1..10)
        ability_damage = base + range

        self.ability_points = [(self.ability_points - 3), 0].max
        ability_damage
      end
    end

    def double_strike
      return unless self.abilities.has_key?(:double_strike)

      if self.ability_points >= 6
        attacks = 2.times.map do
          base = 5 + self.level + self.strength
          range = rand(1..8)
          output = (base + range)
        end

        self.ability_points = [(self.ability_points - 6), 0].max
        attacks
        # returns a list of ability_damage values for proc chance of lucky
      end
    end

  end

  module Utility
    def rage
      return nil unless self.abilities.has_key?(:rage)

      if self.ability_points >= 1
        if self.rage_boost < 6
          self.rage_boost += 1
          self.ability_points = [(self.ability_points - 1), 0].max
          return nil
        else
          puts "You simply could not be any more angry..."
          return nil
        end
      end
    end

    def hunters_mark(target)
      return nil unless self.abilities.has_key?(:hunters_mark)

      if target.instance_variable_defined?(:@marked)
        puts "target is already marked"
        return nil
      else
        if self.ability_points >= 3
          target.instance_variable_set(:@marked, true)
          self.ability_points = [(self.ability_points - 3), 0].max
          return nil
        end
      end
    end

  end

  include Magic
  include Physical
  include Utility
end