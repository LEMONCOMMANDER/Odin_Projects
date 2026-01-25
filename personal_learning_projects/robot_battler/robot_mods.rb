module RobotMods
  def equip_mod(robot, choice, set_rarity) #survive
    case choice
      when 'Core Reinforcement Module'
        robot.health += rand(1..15) + set_rarity
      when 'Impact Absorption Plates'
        robot.armor += rand(1..10) + set_rarity
      when 'Micro Thermal-Boosters'
        robot.speed += rand(1..10) + set_rarity
      when 'Strike Power Unit'
        robot.damage += rand(1..10) + set_rarity
      when 'Targeting Sync System'
        robot.acc += rand(1..10) + set_rarity
      when 'Core Overclock Kit'
        robot.ap += rand(1..10) + set_rarity
    end

    "#{@rarity} Grade #{choice}"
  end

  def equip_mod3(robot) #mix
    one = %w[@health @armor @speed].sample
    two = %w[@damage @acc @ap].sample
    three = %w[@health @damage].sample
    four = %w[@armor @acc].sample
    five = %w[@speed @ap].sample

    robot.instance_variable_set(one.to_s, (robot.instance_variable_get(one.to_s) + rand(1..5)))
    robot.instance_variable_set(two.to_s, (robot.instance_variable_get(two.to_s) + rand(1..5)))
    robot.instance_variable_set(three.to_s, (robot.instance_variable_get(three.to_s) + rand(1..3)))
    robot.instance_variable_set(four.to_s, (robot.instance_variable_get(four.to_s) + rand(1..3)))
    robot.instance_variable_set(five.to_s, (robot.instance_variable_get(five.to_s) + rand(1..3)))

    '--- unique build and design ---'
  end

  def choose_mod(mod)
    raise ArgumentError, "choose(mod) requires 1 or 2 only" unless (1..2).include?(mod)

    case mod
      when 1 then ['Core Reinforcement Module', 'Impact Absorption Plates', 'Micro Thermal-Boosters'].sample
      when 2 then ['Strike Power Unit', 'Targeting Sync System', 'Core Overclock Kit'].sample
    end
  end

  def set_rarity
    @rarity = case rand(1..10)
      when 1..3 then 'Civilian'
      when 4..8 then 'Military'
      when 9..10 then 'Strike-force'
    end

    return 1 if @rarity == 'Civilian'
    return 2 if @rarity == 'Military'
    return 3 if @rarity == 'Strike-force'
  end

end
