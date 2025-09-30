class Warrior < Character

  def initialize(name)
    super(name)

    self.health = 140
    self.max_health = 140

    self.strength = 8
    self.defense = 6
  end

end