class Slime < Character
  def initialize(name: "Slime", type: nil)
    super()
    variance(type)
    @name = "#{@type} #{name}"
  end

  def variance(type)
    @type = type || %w[Blue Orange Red Green].sample

    case @type
      when "Blue"
        self.health = 70
        self.max_health = 70
        self.strength = 6
        self.defense = 3
        self.speed = 3
        self.wisdom = 2
      when "Orange"
        self.health = 60
        self.max_health = 60
        self.strength = 3
        self.defense = 3
        self.speed = 5
        self.wisdom = 2
      when "Red"
        self.health = 50
        self.max_health = 50
        self.strength = 2
        self.defense = 2
        self.speed = 3
        self.wisdom = 6
        self.ability_points = 15
        self.abilities[:fireball] = AbilityDefs::FIREBALL
      when "Green"
        self.health = 100
        self.max_health = 100
        self.strength = 4
        self.defense = 4
        self.speed = 2
        self.wisdom = 1
        self.ability_points = 6
        self.abilities[:mend] = AbilityDefs::MEND
      else
        puts "Error in Slime variance"
    end

  end
end