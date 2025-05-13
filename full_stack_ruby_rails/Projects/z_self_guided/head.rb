module Head
  def equip_head(robot, choice)
    choice
    case choice
    when 'Darmatech Bulwark'
      robot.health += 20
      robot.armor += 5
      robot.speed -= 5
      @head_ability = {type: AbilityType::DEFENSIVE, ability: :disperse} #one time use per battle - mitigates a hit that deals 15 damage
      @htxt = <<~TEXT
        Engineered by Darmatech, the 'Bulwark' cranial-unit integrates an active dispersion matrix that triggers upon
        high-impact threshold breach, by redistributing force to sacrificial reactive plates along the chassis. The
        'Bulwark' is designed to be the life raft in the sea of war. Outfitted with a dense cranial armor shell, this
        unit excels in forward-line suppression and stabilization.
      TEXT
      choice

    when 'VKT-3 RNR'
      robot.damage += 5
      robot.acc += 5
      robot.speed += 5
      robot.health += 5
      robot.armor += 5
      @htxt = <<~TEXT
        VKT-3 'Runner' is a streamlined command-grade head designed for skirmish-class recon bots. Developed by
        VektorMobility, it balances low-mass plating with combat-grade neural sync systems, delivering reliable boosts
        across all major performance vectors. A precision tool in the hands of a swift operator, the RNR is a trusted
        and consistent unit, true to the VektorMobility Labs name.
      TEXT
      choice

    when 'PRX ram'
      robot.damage += 10
      robot.acc += 15
      robot.ap += 5
      robot.armor -= 5
      @htxt = <<~TEXT
        The 'ram' is an aptly named, high-aggression command module unit, by Parallax Defense Initiative, engineered for
        targeted strikes. Stripped of restraint protocols, it features a hyper-aggressive targeting core paired with
        raw-output amplifiers. Sacrificing defense for unchecked offensive thrust, it is the weaponized brain for
        breach-and-burn units - designed to hit hard, fast, and without hesitation. Armor is optional; annihilation is not.
      TEXT
      choice

    when 'RAGN-IX B'
      robot.acc += 15
      robot.health += 5
      @head_ability = {type: AbilityType::ACCURACY, ability: :retarget} # a high ap cost ability that can turn a missed attack into one that hits with a small reduction in damage dealt
      @htxt = <<~TEXT
        From the labs of Ragnarok Integrated Systems comes the RAGN-IX B—a twin-core, battlefield cognition processor
        with unrivaled accuracy modulation. Its primary function, the Retarget Suite, allows for near-instantaneous 
        correction of failed strikes. With built-in predictive analytics and resource reallocation AI, No other unit can
        compare to the sheer aggressive offensive throughput.
      TEXT
      choice

    when 'V-SCS'
      robot.damage += 8
      robot.acc += 8
      robot.ap += 5
      @head_ability = {type: AbilityType::OFFENSIVE, ability: :scan} # adds damage to the next attack
      @htxt = <<~TEXT
        The HORIZON V-SCS, Sensor Command Suite is a hyperlinked tactical uplink hub designed for battlefield awareness.
        With its integrated Pre-Strike Scan Matrix, it boosts first-contact lethality by pinpointing weak points in armor
        topology. Used properly, it ensures the next strike doesn't just hit — it cripples.
      TEXT
      choice

    when 'Skyvault'
      robot.health += 10
      robot.ap += 10
      robot.speed += 5
      @head_ability = {type: AbilityType::DEFENSIVE, ability: :trajectory} # when defending, adds a bit to speed
      @htxt = <<~TEXT
        The NEOQUAD 'Skyvault' cranial array is a versatile support-oriented head unit designed for evasive defense and
        adaptive response. With high-speed data routing and trajectory prediction software, it excels in deflective
        maneuvers when under fire. For mobile defense bots and responsive strike units, Skyvault offers control under
        pressure and escape when outnumbered.
      TEXT
      choice
    end
  end

  def choose_head
    ['Darmatech Bulwark', 'VKT-3 RNR', 'PRX ram', 'RAGN-IX B', 'V-SCS', 'Skyvault'].sample
  end

  def head_ability?
    @head_ability ? true : false
  end

  def head_details(txt)
    if head_ability?
      case @head_ability[:ability]
      when :disperse
        puts "\e[33mone time use per battle - mitigates a hit that deals 15 damage\e[0m"
      when :retarget
        puts "\e[33ma high ap cost ability that can turn a missed attack into one that hits with a small reduction in damage dealt\e[0m"
      when :trajectory
        puts "\e[33ma low cost ability that when defending, adds a bit to speed\e[0m"
      when :scan
        puts "\e[33ma low cost ability that adds a bit of damage to the next attack\e[0m"
      end
    end
    puts @htxt if txt
  end

  def disperse(damage)
    return 1 unless self.health <= (self.max_health / 3).ceil || damage >= self.health

    if (damage > 15 || damage >= self.health) && !self.instance_variable_defined?(:@used)
      puts "\e[34mdisperse triggered\e[0m"
      @used = 1
      new = 0
      new
    else
      1
    end
  end

  def retarget(hit, damage)
    if self.ap >= 7 && hit == false
      puts "\e[34mretarget triggered\e[0m"
      self.ap -= 7
      damage - 5
    end
  end

  def trajectory
    if self.ap >= 2
      puts "\e[34mtrajectory triggered\e[0m"
      self.ap -= 2
      # self.instance_variable_set(:@h_buff)
      @h_buff = true
    end
    self.instance_variable_defined?(:@h_buff) ? 5 : 0
  end

  def scan
    bonus_damage = 0
    if ap >= 3
      puts "\e[34mscan triggered\e[0m"
      self.ap -= 3
      bonus_damage = 5
    end
    bonus_damage
  end

end