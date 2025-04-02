#TODO: this will be the functions that are called that determins the outcome of the battle

require './character.rb'

def battle_setup
  fighter1 = Character.new
  fighter2 = Character.new

  fighter1.set_name('fighter', 'one')
  fighter2.set_name('fighter', 'two')

  5.times do
    fighter1.level_up(details: false)
    fighter2.level_up(details: false)
  end

  puts '----- fighters ------'
  fighter1.get_stats
  puts ''
  fighter2.get_stats
  puts '---------------------'
  puts ''


  initiatives = [fighter1, fighter2].map do |f|
      atr = case f.character_class
        when 'warrior' then f.strength
        when 'wizard' then f.wisdom
        when 'ranger' then f.dexterity
        when 'assassin' then f.stealth
      end

      ((atr / 2) + f.level + rand(1..6)).ceil
    end

  @attacker = initiatives[0] > initiatives[1] ? fighter1 : fighter2
  @defender = @attacker == fighter1 ? fighter2 : fighter1

end

def attack
  attacker = @attacker
  defender = @defender
  adv_mod = 0
  case attacker.character_class
  when 'warrior'
    adv_mod = 1 if defender.character_class == 'wizard'
      damage = (attacker.strength + rand(1..6) + adv_mod) - defender.strength
  when 'wizard'
    adv_mod = 1 if defender.character_class == 'ranger'
      damage = (attacker.wisdom + rand(1..6) + adv_mod) - defender.wisdom
  when 'ranger'
    adv_mod = 1 if defender.character_class == 'assassin'
      damage = (attacker.dexterity + rand(1..6) + adv_mod) - defender.dexterity
  when 'assassin'
    adv_mod = 1 if defender.character_class == 'warrior'
      damage = (attacker.stealth + rand(1..6) + adv_mod)- defender.stealth
  end

  damage = 1 if damage <= 0
  damage
end

def crit?
  crit_roll = rand(1..20)
  return false unless crit_roll == 20
  true
end


def battle
  attacker = @attacker
  defender = @defender
  battle_info = []

  count = 1
  while attacker.alive && defender.alive
    round = []
                    round.push("\e[33mon round #{count}, \e[0m#{attacker.name} \e[33mattacked\e[0m #{defender.name}")

    crit = crit?
    a = attack
    damage = crit == true ? (a * 2).ceil : a
    if crit == true
                    round.push(", landing a \e[35mcritical strike (+#{damage - a} damage\e[0m),")
    end
                    round.push(" for \e[35m#{damage} damage\e[0m!")

    defender.health -= damage
                    round.push(" #{defender.name} has \e[32m#{defender.health} health\e[0m left")


    attacker, defender = defender, attacker
    count += 1
    battle_info.push(round.join)

    if attacker.health <= 0 || defender.health <= 0
      @dead_fighter = attacker.health <= 0 ? attacker : defender
      @live_fighter = @dead_fighter == attacker ? defender : attacker

      dead_fighter = @dead_fighter
      live_fighter = @live_fighter

      dead_fighter.death
          battle_info.push("\e[31m#{dead_fighter.name} has died on round #{count}\e[0m")

      lu = live_fighter.level_up
          battle_info.push("\e[34m#{live_fighter.name}: #{lu}\e[0m")

      live_fighter.karma = dead_fighter.karma > live_fighter.karma ? live_fighter.karma - 1 : dead_fighter.karma < live_fighter.karma ? live_fighter.karma + 1 : live_fighter.karma
      live_fighter.karma = live_fighter.karma <= 0 ? 1 : live_fighter.karma >= 12 ? 11 : live_fighter.karma
      k = live_fighter.check_affinity
          battle_info.push("\e[34m#{live_fighter.name} affinity: #{k}\e[0m")
    end
  end

  puts "#{count} rounds:"
  puts battle_info
  battle_info
end



battle_setup
battle
puts ""
@live_fighter.get_stats
