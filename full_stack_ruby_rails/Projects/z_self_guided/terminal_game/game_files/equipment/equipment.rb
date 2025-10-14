## this class should take in the character relationship and view their stats
# there will be an IV of equipped? boolean
# if true, apply bonus stats to character
# if unequipped (equipped goes away), reduce character stats by weapon stats

#def apply_boost_on_equip(owner)
#if self.equipped?
# owner.strength += self.strength
# ...
# end

#def remove_boost_on_unequip(owner)
# if !self.equipped?
# owner.strength -= self.strength
# ...
# end

#something like this

#------------------------------

#ivs should include stats, names, abilities, rarity

class Equipment
  attr_accessor :owner,:type, :name, :rarity, :color, :stats, :equipped, :abilities

  def initialize(property_hash)
    p = property_hash

    @name = p[:name]
    @description = p[:description] || nil
    @type = p[:type]
    @rarity = p[:rarity]
    @color = p[:color]

    @stats = p[:stats] #hash of stats and values
    @abilities = p[:abilities] || nil #hash of abilities and values

    @equipped = false
  end

  def equipped?
    self.equipped
  end

  def unequipping(owner_object)
    self.equipped = false
    update_stats(owner_object)
  end

  def equipping(owner_object)
    return if self.equipped?

    @owner = owner_object

    old_item =owner_object.instance_variable_get("@#{self.type}")
    old_item.unequipping(owner_object) if old_item

    owner_object.send("#{self.type}=", self)
    self.equipped = true

    update_stats(owner_object)
  end

  def update_stats(owner_object)
    if self.equipped?
      self.stats.each do |stat, value|
        owner_stat = owner_object.send("#{stat}")
        new_value = owner_stat + value
        owner_object.send("#{stat}=", new_value)
      end

      if self.abilities
        self.abilities.each do |ability, info|
          owner_abilities = owner_object.instance_variable_get(:@abilities)
          unless owner_abilities[ability]
            owner_abilities[ability] = info
            info[:native] = false
          end
        end
      end
    elsif !self.equipped?
      self.stats.each do |stat, value|
        owner_stat = owner_object.send("#{stat}")
        new_value = owner_stat - value
        owner_object.send("#{stat}=", new_value)
      end

      if self.abilities
        self.abilities.each do |ability, info|
          owner_abilities = owner_object.instance_variable_get(:@abilities)
          owner_abilities.delete(ability.to_sym) if owner_abilities[ability][:native] == false
        end
      end
    else
      puts "error in equipment.rb update_stats"
    end
  end

  def info
    output = <<~INFO
      -------------------------------------------------------------------------------------
      -------------------  #{self.name}  ---------------------------
      type: #{self.type} | rarity: #{self.rarity} | color: #{self.color}
      abilities: #{self.abilities&.keys&.join(" | ")}
      #{self.stats.map { |stat, value| "---------------- #{stat}: #{value}" }.join("\n")}
      description:
      #{self.description}
      -------------------------------------------------------------------------------------
    INFO
    puts output
  end

end