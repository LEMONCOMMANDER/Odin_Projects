require_relative "./ability_type"
module Chassis
  def equip_chassis(robot, choice)
    # puts choice
    case choice
    when 'ART mk.4'
      robot.health += 30
      robot.armor += 12
      robot.speed -= 5
      robot.damage -= 2
      @ctxt = <<~TEXT
        The ART mk.4 represents Armitage Defense’s next-gen heavy chassis platform, integrating a reinforced
        7-layer hyper-titanium lamellar armor system. Engineered for high-threat environments, it delivers
        exceptional resilience and ballistic absorption. What you lose in speed, you make up for double in
        stability and defense.
      TEXT

      choice
    when 'LWDP 335'
      robot.health += 20
      robot.armor += 5
      robot.speed += 5
      @chassis_ability = {type: AbilityType::DEFENSIVE, ability: :evade} #10% chance to mitigate damage
      @ctxt = <<~TEXT
        Lightweight and maneuverable, Luthrex’s LWDP 335 chassis emphasizes tactical evasion.
        Optimized for rapid maneuver warfare, the LWDP 335 chassis utilizes micro-filament composite armor
        and enhanced servo-actuation arrays to boost evasive response protocols. The LWDP 335 offers a
        precise balance of defensive integrity  while maximizing kinematic agility under sustained engagement
        conditions.
      TEXT

      choice
    when 'Pelomatic Ballastic Impact'
      robot.health += 27
      robot.armor += 13
      robot.speed -= 3
      robot.damage -= 2
      @chassis_ability = {type: AbilityType::DEFENSIVE, ability: :discharge} #after ever 5th hit, deals damage to attacker
      @ctxt = <<~TEXT
        The Ballistic Impact unit from Pelomatic reinforces midline defense. The frame incorporates reactive
        impulse dispersion layers, capable of discharging retaliatory force after successive kinetic
        and ballistic impacts. Designed for mid-weight conflict theaters, it sacrifices minimal
        mobility for enhanced threat mitigation feedback
      TEXT

      choice
    when 'Sentinal c0r3'
      robot.health += 20
      robot.armor += 3
      robot.damage += 5
      robot.ap += 2
      @chassis_ability = {type: AbilityType::OFFENSIVE, ability: :rush} #10% chance to deal extra damage on attack
      @ctxt = <<~TEXT
        Built for aggressive maneuvers, the c0r3 chassis is equipped with 15 thermo-accelerators. The c0r3
        platform prioritizes aggressive tactical engagement, pairing adaptive micro-armor composites with
        boosted energy-transfer modules for quick bursts in acceleration.
      TEXT

      choice
    when 'Van 777'
      @regen = (@regen || 0) + 1
      robot.health += 17
      robot.armor += 8
      robot.speed += 6
      robot.damage += 4
      @ctxt = <<~TEXT
        Vanquara’s 777 series chassis leverages advanced poly-ceramic plating and distributed load-balancing
        servos to achieve equilibrium between armor resilience and high-velocity maneuverability.
        Designed for rapid-deployment strike units operating in variable threat environments, the 777 specializes
        in versatility without compromising durability nor speed.
      TEXT

      choice
    end

  end

  def choose_chassis
    ['ART mk.4', 'LWDP 335', 'Pelomatic Ballastic Impact', 'Sentinal c0r3', 'Van 777'].sample
  end

  def chassis_ability?
    @chassis_ability ? true : false
  end

  def chassis_details(txt)
    if chassis_ability?
      case @chassis_ability[:ability]
      when :discharge
        puts "\e[33mafter every 5th hit received, return 1/2 damage on the final hit to attacker\e[0m"
      when :rush
        puts "\e[33m10% chance to deal 3 extra damage on attack\e[0m"
      when :evade
        puts "\e[33m10% chance to mitigate damage by 1/2\e[0m"
      end
    end
    puts @ctxt if txt
  end

  def discharge(damage)
    @hits ||= 0
    @hits += 1

    if @hits == 5 && self.ap >= 3
      puts "\e[34mdischarge triggered\e[0m"
      self.ap -= 3
      @hits = 0
      bonus_d = (damage / 2).round
      bonus_d
    else
      0
    end
  end

  def rush
    bonus_damage = 0
    @hits ||= 0
    @hits += 1
    if @hits == 3 && self.ap >= 1
      puts "\e[34mrush triggered\e[0m"
      @hits = 0
      self.ap -= 1
      bonus_damage = 3
    end
    bonus_damage
  end

  def evade #reduces damage
    if rand(1..100) > 90
      puts "\e[34mevade triggered\e[0m"
      0.5
    else
      1
    end
  end
end