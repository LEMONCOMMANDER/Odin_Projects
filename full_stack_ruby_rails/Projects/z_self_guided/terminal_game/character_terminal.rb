require_relative 'character'
require_relative 'character_classes/warrior'
require_relative 'character_classes/wizard'
require_relative 'character_classes/hunter'
require_relative 'character_classes/rouge'
require_relative 'monster_classes/slime'

guy = Character.new
warrior = Warrior.new("Conan")
slime = Slime.new(type: 'Red')
wizard = Wizard.new("Gandalf")
rouge = Rouge.new('Shadow')
hunter = Hunter.new('Legolas')

# p guy
# puts "-------------------"
# p warrior
# puts "-------------------"
# p slime
# puts ""
# puts "-------------------"
# puts "ability test"
# puts "warrior uses attack on slime"
# p warrior.attack(slime)
#
#
# puts "-------------------"


rouge.force_level(7, rouge.weight_list)
p rouge