require_relative './robot'

def hit?(attacker, defender)
  e_s_mod = defender.head_ability? && defender.head_ability[:ability] == :trajectory ? defender.trajectory : 0
  a_debuff = attacker.instance_variable_defined?(:@a_debuff) ? -10 : 0

  random = rand(1..100)
  hit = random + (attacker.acc - a_debuff + attacker.e_ac_mod) - (defender.speed + e_s_mod) > 60
  puts "robot #{attacker.id} attacked robot #{defender.id}, random is #{random} and hit?: #{hit}"
  return hit
end

def battle_round(attacker, defender, hit)
  if !hit #if miss, check retarget
    reatk = attacker.head_ability? && attacker.head_ability[:ability] == :retarget ? attacker.retarget(false, attacker.attack(c = false, defender)) : 0
    total = reatk - defender.armor
    minimum = attacker.head_ability? && attacker.head_ability[:ability] == :retarget ? 1 : 0
    puts "robot #{attacker.id} missed, but has 'retarget'." if attacker.head_ability? && attacker.head_ability[:ability] == :retarget

    defender.health -= total > 0 ? total : minimum
    puts "damage: #{total > 0 ? total : minimum}"
  elsif hit #no retarget, then:
    damage = attacker.attack(defender)

    total = (damage * defender.e_d_mod(damage)[0] * defender.e_d_mod(damage)[1]).round - defender.armor
    defender.health -= total > 0 ? total : 1 #mimimum damage of 1 on every hit
    puts "robot #{defender.id} recieved #{total > 0 ? total : 1} damage as the defender"

    attacker.health -= defender.discharge(damage) if defender.chassis_ability? && defender.chassis_ability[:ability] == :discharge
    puts "robot #{defender.id} has 'discharge': robot#{attacker.id} took #{defender.discharge(damage)} damage as the attacker" if defender.chassis_ability? && defender.chassis_ability[1] == :discharge
  else
    puts "\35[mELSE??? - battle round\e[0m"
  end
end

def reset(attacker, defender)
  atk = [:@a_buff, :@retarget]
  atk.each do |buff|
    if attacker.instance_variables.include?(buff)
      attacker.remove_instance_variable(buff)
      puts "\e[33mrobot #{attacker.id} removes: #{buff}\e[0m"
    end
  end

  dfn = [:@a_debuff, @d_buff, :@h_buff]
  dfn.each do |buff|
    if defender.instance_variables.include?(buff)
      defender.remove_instance_variable(buff)
      puts "\e[33mrobot #{defender.id} removes: #{buff}\e[0m"
    end
  end
end

def recharge_ap(attacker, defender)
  temp1 = attacker.ap
  ar = attacker.has_regen? ? (attacker.regen * 2) : 0
  attacker.ap += (8 + ar)
  attacker.ap = attacker.max_ap if attacker.ap > attacker.max_ap

  temp2 = defender.ap
  dr = defender.has_regen? ? (defender.regen * 2) : 0
  defender.ap += (8 + dr)
  defender.ap = defender.max_ap if defender.ap > defender.max_ap
  #
  # puts "robot #{attacker.id} regains #{attacker.ap - temp1} ap"
  # puts "robot #{defender.id} regains #{defender.ap - temp2} ap"
end

def battle(robot1, robot2)
  attacker = robot1.speed >= robot2.speed ? robot1 : robot2
  defender = attacker == robot1 ? robot2 : robot1

  while robot1.health >= 0 && robot2.health >= 0
    battle_round(attacker, defender, hit?(attacker, defender))
    reset(attacker, defender)
    recharge_ap(attacker, defender)

    puts "\e[31mROUND STATUS: robot1 hp:#{robot1.health} ap: #{robot1.ap}, robot2 hp:#{robot2.health} ap: #{robot2.ap}\e[0m"

    attacker, defender = defender, attacker
  end
end

robot1 = Robot.new
robot2 = Robot.new

robot1.display
robot2.display
robot1.details(txt = false)
robot2.details(txt = false)

battle(robot1, robot2)
