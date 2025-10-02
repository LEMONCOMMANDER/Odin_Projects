class Wizard < Character

  attr_accessor :class

  def initialize(name)
    super()
    @name = name
    @class = "Wizard"

    self.health = 80
    self.max_health = 80

    self.wisdom = 8
    self.ability_points = 20
    self.strength = 3

    self.abilities[:mend] = AbilityDefs::MEND
    self.abilities[:shock] = AbilityDefs::SHOCK
  end
end