require_relative 'character'
require_relative 'game_files/character_classes/warrior'
require_relative 'game_files/character_classes/wizard'
require_relative 'game_files/character_classes/hunter'
require_relative 'game_files/character_classes/rouge'
require_relative 'game_files/monster_classes/slime'
require_relative 'game_files/equipment/game_files/equipment'

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
                         stats: {health: 0, defense: 0},
                         abilities: {mend: AbilityDefs::MEND}
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