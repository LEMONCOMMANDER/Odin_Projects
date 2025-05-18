# require_relative './robot'
module Arms

  attr_reader :armor

  def equip_arms(robot, choice)
    case choice
    when 'FC-ovw'
      # mounted turrets
      robot.damage += 20
      robot.ap += 15
      @arms_ability = {type: AbilityType::OFFENSIVE, ability: :barrage} #stores charges and then unleashes them
      @atxt = <<~TEXT
        FerroCore Heavyworks' FC-ovw, 'Overwatch Cannons', are dual-mounted autocannon arrays designed for sustained
        suppressive output and tactical barrage saturation. Using an internal rotary ammo loader synced to a charge-based
        fire directive, the system stores energy and kinetic payloads until full-cycle discharge, overwhelming enemy
        positions in calculated bursts. Deployed primarily on siege-class mechs, it transforms forward lines into pressure
        cookers of shrapnel and thunder.
      TEXT
      choice

    when 'TAiv'
      #claws - 4 arms
      robot.damage += 15
      robot.ap += 10
      robot.speed += 10
      robot.health += 5
      @arms_ability = {type: AbilityType::OFFENSIVE, ability: :lacerate} #successful hits ignore 5% armor
      @atxt = <<~TEXT
        Thorne-Axon’s TAiv 'Talon Array' features four independent servo-linked claw limbs outfitted with reinforced
        rippers and armor-fracture points. Designed for systematic dismantling of enemy plating, the Talons use
        high-torque impact cycling and edge micro-serration to shear through composite and reactive armor layers.
        Ideal for breach-class interceptors that favor attrition over finesse.
      TEXT
      choice

    when 'MIR3xb'
      #blades - 2 arms
      robot.damage += 10
      robot.armor += 5
      robot.speed += 5
      robot.health += 10
      robot.ap += 10
      @arms_ability = {type: AbilityType::OFFENSIVE, ability: :double_strike} #2nd attack can deal 3-8 true damage if hit
      @atxt = <<~TEXT
        The MIR3xb 'Blade Doctrine Kit' by Valkra Forge Systems delivers a refined close-combat solution optimized for fast,
        successive strikes in high-pressure environments. Each blade features a full tang monosteel core, triple-balanced
        for low-mass handling and enhanced inertia control during rapid directional shifts. Ideal for pilots favoring
        strike-and-clear engagements, these blades excel in neutralizing lightly-armored targets and exploiting structural
        gaps at close quarters. Its lightweight design reduces fatigue on servos and increases action economy across engagements.
      TEXT
      choice

    when 'KON-27'
      #guns - 2 arms
      robot.damage += 20
      robot.acc += 10
      robot.speed += 10
      @arms_ability = {type: AbilityType::ACCURACY, ability: :suppress} #adds 10 acc to self and reduces target acc by 10
      @atxt = <<~TEXT
        The KON-27 are twin-barrel smartguns developed by Helix Arms Division for precision combat across
        mid-to-short range. Outfitted with integrated targeting matrices and recoil-compensators, the KON-27 rifle
        specialize in suppression fire, locking down vectors while boosting offensive precision. Designed for mech
        gunners who live by the rule: shoot fast, aim faster.
      TEXT
      choice

    when 'AE-Xi'
      #energy (plasma electricity etc) - no arms
      robot.damage += 10
      robot.ap += 10
      robot.health += 15
      robot.acc += 5
      @arms_ability = {type: AbilityType::OFFENSIVE, ability: :charge} #adds 1/3 missing hp to damage
      @atxt = <<~TEXT
        The AE-Xi 'Ion Phasing Core' is a modular energy-emission platform created by OrdoTek Arc Systems, favoring
        waveform disruption over traditional limb-mounted firepower. It utilizes phased plasma injection coils and adaptive
        overcharge regulators to convert reactor bleed into raw offensive energy. The more energy stored in the core, the
        higher the voltage yield.
      TEXT
      choice

    when "silencer"
      #hacking relays - 6 arms
      robot.damage += 10
      robot.ap += 10
      robot.health += 10
      robot.acc += 10
      @arms_ability = {type: AbilityType::ACCURACY, ability: :hack} #disables target attack abilities for 4 turns - 8 turn cooldown
      @atxt = <<~TEXT
        Blackvault’s Silencer comprises six cybernetic relays equipped with counter-command uplinks, hardline signal
        disruptors, and modular neural decoders. Designed for digital warfare, it disables enemy attack protocols and
        isolates battlefield control nodes via precision injection of logic scramblers. Once locked on, targets enter
        tactical blackout—unable to issue fire commands or activate abilities for critical windows.
      TEXT
      choice
    end
  end

  def choose_arms
    ['FC-ovw', 'TAiv', 'MIR3xb', 'KON-27', 'AE-Xi', 'silencer'].sample
  end

  def arms_ability?
    @arms_ability ? true : false
  end

  def arms_details(txt)
    case @arms_ability[:ability]
    when :barrage
      puts "\e[33mstores charges and then unleashes them for extra damage\e[0m"
    when :lacerate
      puts "\e[33msuccessful hits ignore 5% armor\e[0m"
    when :evade
      puts "\e[33m10% chance to mitigate damage by 1/2\e[0m"
    when :double_strike
      puts "\e[33m2nd attack can deal 3-8 true damage if hit\e[0m"
    when :suppress
      puts "\e[33madds 10 acc to self and reduces target acc by 10\e[0m"
    when :charge
      puts "\e[33madds 1/3 missing hp to damage\e[0m"
    when :hack
      puts "\e[33mdisables target attack abilities for 4 turns - 8 turn cooldown\e[0m"
    end
    puts @atxt if txt
  end

  def barrage
    puts "\e[34mbarrage called\e[0m"

    @regen = (@regen || 0) + 1

    @charges ||= 0
    @cost ||= 0
    @extra_damage ||= 0

    unless @charges == 8
      @charges += 1
      puts "BARRAGE CHARGES: #{@charges}"
      @cost += 2
      @extra_damage += 1
    end

    return 0 unless @charges >= 3

    if rand(1..10) >= 9 && self.ap >= @cost #early trigger
      puts "\e[34mbarrage activated\e[0m"
      @charges = 0
      self.ap -= @cost
      return @extra_damage
    elsif @charges == 8 && self.ap >= @cost #full charge
      puts "\e[34mFULL barrage activated\e[0m"
      @charges = 0
      self.ap -= @cost
      return @extra_damage
    else
      return 0
    end
  end

  def lacerate(target)
    puts "\e[34mlacerate activated\e[0m"
    (target.armor * 0.05).ceil
  end

  def double_strike(target)
    return 0 unless self.ap >= 5

    puts "\e[34mdouble strike activated\e[0m"
    self.ap -= 5
    second_attack = rand(1..100) + self.acc - target.speed > 60 ? rand(3..8) : 0
    second_attack
  end

  # a_buff, a_debuff
  def surpress(target)
    return 0 unless self.ap >= 7

    puts "\e[34msuppress activated\e[0m"
    self.ap -= 7
    target.instance_variable_set(:@a_debuff)

    self.instance_variable_set(:@a_buff)
    bonus_acc = 10
    bonus_acc
  end

  def charge
    puts "\e[34mcharge activated\e[0m"
    bonus_damage = ((self.max_health - self.health) * 0.33).round
    bonus_damage
  end

  # hacked
  def hack(target)
    @cooldown ||= 0
    @cooldown -= 1 if @cooldown > 0

    unless target.instance_variables.include?(:@hacked) && @cooldown == 0 && self.ap >= 10
      puts "\e[34mhack activated\e[0m"
      @cooldown = 8
      self.ap -= 10
      target.instance_variable_set(:@hacked, 4)
    end

    if target.instance_variable_get(:@hacked) == 0
      puts "\e[34mhack complete\e[0m"
      target.remove_instance_variable(:@hacked)
    end

    if target.instance_variables.include(:@hacked)
      target.instance_variable_set(:@hacked, (@hacked - 1))
      new_damage = target.e_att_mod = 0 if target.e_att_mod > 0
      new_damage
    end
  end
end