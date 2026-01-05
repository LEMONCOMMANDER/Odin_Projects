require_relative './character'
require_relative './character_classes/warrior'
require_relative './character_classes/wizard'
require_relative './character_classes/hunter'
require_relative './character_classes/rouge'
require_relative './monster_classes/slime'
require_relative './equipment/equipment.rb'
require_relative './db_connect.rb'

guy = Character.new("guy")
warrior = Warrior.new("Conan")
slime = Slime.new(type: 'Red')
wizard = Wizard.new("Gandalf")
rouge = Rouge.new('Shadow')
hunter = Hunter.new('Legolas')
helmet = Equipment.new({
                         name: "Iron Helmet",
                         type: "head",
                         rarity: "Common",
                         color: "Gray",
                         stats: {health: 10, defense: 5},
                         item_abilities: {mend: AbilityDefs::MEND}
                       })

# p ["health: #{wizard.health}", "defense: #{wizard.defense}", "abilities: #{wizard.abilities}"]
# puts ""
# puts "equipping helment"
# wizard.equip(helmet)
#
# p ["health: #{wizard.health}", "defense: #{wizard.defense}", "abilities: #{wizard.abilities}"]
# puts ""
#
# puts "checking abilities"
# p wizard.abilities
#
# puts ""
# puts "unequipping helment"
# wizard.unequip(helmet)
# puts ""
# p ["health: #{wizard.health}", "defense: #{wizard.defense}", "abilities: #{wizard.abilities}"]

# puts "inspecting wizard no helm"
# p wizard
# puts ""
# wizard.equip(helmet)
#
# puts "inspecting wizard with helm"
# p wizard
# guy.unequip(helmet)
#
# puts "guy stats after unequip: #{[guy.health, guy.defense, guy.head, guy.abilities].inspect}"

# puts "----------------------"
# p guy.abilities
# p guy.instance_variables

# conn = DBConnect.connect
# get_shield = conn.exec_params("SELECT * FROM equipment WHERE name = $1;", ['Steel Shield'] )
#
# p get_shield.to_a.first.to_h
#
# shield = Equipment.new(get_shield.to_a.first)
# conn.close
# puts ""
# p shield
#
# puts ""
# warrior.equip(shield)
# p warrior

abilities = AbilityDefs.constants
p abilities

