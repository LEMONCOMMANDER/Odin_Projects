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

#ivs should include stats, names, item_abilities, rarity

class Equipment
  attr_accessor :owner,:type, :name, :rarity, :color, :stats, :equipped, :item_abilities, :role

  ## converts string keys retrieved from db objects to symbols
  def convert_keys(property_hash)
    p = property_hash
    return p unless p.keys.any? {|key| key.class == String}

    new_p = {}
    stats = {}
    abilities = {}

    p.each do |key, value|
      if key.include?("_mod")
        stat = key.split("_")[0].to_sym
        stat = :ability_points if stat == :ap

        stats[stat] = value.to_i
      elsif key.include?("ability")
        ability_name = value.strip.downcase if value
        abilities[ability_name.to_sym] = AbilityDefs.const_get(ability_name.upcase) if ability_name
      else
        new_p[key.to_sym] = value
      end
    end

    new_p[:stats] = stats
    new_p[:item_abilities] = abilities
    new_p
  end
  def initialize(property_hash)
    p = property_hash
    p = convert_keys(p)

    @name = p[:name]
    @description = p[:description] || nil
    @type = p[:type]
    @role = p[:role]
    @rarity = p[:rarity]
    @color = p[:color]

    @stats = p[:stats] #hash of stats and values
    @item_abilities = p[:item_abilities] || nil #hash of item_abilities and values

    @equipped = false
  end

  def equipped?
    self.equipped
  end

  def return_item_info
    {stats: self.stats, item_abilities: self.item_abilities}
  end

  def info
    output = <<~INFO
      -------------------------------------------------------------------------------------
      -------------------  #{self.name}  ---------------------------
      type: #{self.type} | rarity: #{self.rarity} | color: #{self.color}
      item_abilities: #{self.item_abilities&.keys&.join(" | ")}
      #{self.stats.map { |stat, value| "---------------- #{stat}: #{value}" }.join("\n")}
      description:
      #{self.description}
      -------------------------------------------------------------------------------------
    INFO
    puts output
  end

end