require_relative 'character'
require_relative 'characater_classes/warrior'
require_relative 'characater_classes/wizard'
require_relative 'characater_classes/hunter'
require_relative 'monster_classes/slime'

guy = Character.new
warrior = Warrior.new("Conan")
slime = Slime.new

p guy
puts "-------------------"
p warrior
puts "-------------------"
p slime

