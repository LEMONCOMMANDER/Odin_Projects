module Legs
  def equip_legs(robot, choice)
    # puts choice
    case choice
    when 'BPR-II' # bipedal
      robot.speed += 15
      robot.armor += 5
      robot.health += 5
      @ltxt = <<~TEXT
        The BPR-II from Striders Inc. are next-gen bipedal locomotion units designed for adaptable battlefield mobility.
        Featuring reinforced servo stabilizers and knee-actuated torque converters, the BPR-II provides balanced
        maneuverability and enhanced forward propulsion best suited for urban pacification units and rapid-response deployments.
      TEXT
      choice

    when 'Bastion Treads' # treds like a tank
      robot.speed += 5
      robot.armor += 10
      robot.health += 15
      robot.ap += 5
      @ltxt = <<~TEXT
        ROOK's 'Bastion Treads' are a industry staple in artillery grade mobility. What your promised with each unit
        is a heavy-grade traction module engineered for siege-class platforms and sustained front-line engagement. Equipped
        with modular armored skirts and adaptive torque dampers, the 'Bastion Treads' deliver unmatched ground stability,
        high payload capacity, and boosted power routing to support systems.
      TEXT
      choice

    when 'ACM-4' # quadrupedal or arachnid like legs
      robot.speed += 20
      robot.damage += 10
      robot.armor -= 5
      robot.health -= 5
      @ltxt = <<~TEXT
        The ACM-4 'Howlers' deploy a four-point low-profile gait, combining feral speed with impact-focused kinetic surges.
        Inspired by Greenrock's research into arachnid movement and backed by high-torque limb actuators, the ACM-4 is
        designed for forward-push assaults and blitz-based skirmishing. Reduced weight from minimal armor promotes raw
        offensive positioning power.
      TEXT
      choice

    when 'GH-057' #hovercraft but with some kind of appendages
      @regen = (@regen || 0) + 1
      robot.speed += 10
      robot.ap += 10
      robot.acc += 10
      @ltxt = <<~TEXT
        Ghost Holdings introduces the new GH-057 'Ghost Glide Array' - a hybrid propulsion system integrating vector-thrust
        hover pods with micro-articulated stabilizer arms for terrain interaction and evasive repositioning. Optimized for
        mobility-based targeting platforms, the GH-057 specializes in silent movement, unmatched positioning power, and precision.
      TEXT
      choice
    end
  end

  def choose_legs
    ['BPR-II', 'Bastion Treads', 'ACM-4', 'GH-057'].sample
  end

  def legs_details(txt)
    puts @ltxt if txt
  end
end