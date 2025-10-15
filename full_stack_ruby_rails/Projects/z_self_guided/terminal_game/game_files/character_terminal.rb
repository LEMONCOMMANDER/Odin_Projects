require_relative './character'
require_relative './character_classes/warrior'
require_relative './character_classes/wizard'
require_relative './character_classes/hunter'
require_relative './character_classes/rouge'
require_relative './monster_classes/slime'
require_relative './equipment/equipment.rb'

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

puts "inspecting wizard no helm"
p wizard
puts ""
wizard.equip(helmet)

puts "inspecting wizard with helm"
p wizard
# guy.unequip(helmet)
#
# puts "guy stats after unequip: #{[guy.health, guy.defense, guy.head, guy.abilities].inspect}"

# puts "----------------------"
# p guy.abilities
# p guy.instance_variables