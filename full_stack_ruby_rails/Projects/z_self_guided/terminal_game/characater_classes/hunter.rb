class Hunter < Character

  attr_accessor :target_hits, :class

  def initialize(name)
    super()
    @name = name
    @class = "Hunter"

    @target_hits = 0 #once hits reach 5, the target should have the mark removed

    self.speed = 6
    self.wisdom = 6
    self.strength = 4
    self.ability_points = 15

    self.abilities[:hunters_mark] = AbilityDefs::HUNTERS_MARK #all damage deals extra 10%
    self.abilities[:quick_shot] = AbilityDefs::QUICK_SHOT
  end

  #may need a specific hunter ability to check on marked / hits
  ## otherwise, in character class
end