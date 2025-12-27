## this file is redundant - it serves the same purpose as creating the table in a postgres console window or cli.
# I just wanted the practice of building a function and interpolating variables into a SQL string.
# This code will not be user facing - users will have no access to creating items - but i will sanitize inputs anyway
# see: https://deveiate.org/code/pg/PG/Connection.html#method-i-close_prepared

require_relative 'db_connect'

#fill this out for each new item
p = {
  name: "Leather Boots",
  description: "A pair of very worn leather boots. They have travelled far and been repaired often. Though basic, they are quite comfortable",
  type: "leg",    #options = ['head', 'chest', 'arm', 'leg', 'weapon', 'shield', 'accessory']
  role: "utility",    #options = ['offense', 'defense', 'utility']
  rarity: "common",  #options = ['common', 'rare', 'epic', 'legendary']
  color: "grey",   #options = ['red', 'grey', 'blue', 'green', 'orange', 'purple'] | default grey
  health_mod: 0,
  strength_mod: 0,
  defense_mod: 0,
  speed_mod: 2,
  wisdom_mod: 0,
  ap_mod: 0,
  ability1: "", #default null
  ability2: "", #default null
  ability3: "" #default null
}

def sanitize(param_hash)
  raise StandardError, "Input must be a hash" unless param_hash.is_a?(Hash)
  raise StandardError, "Hash must have all required fields" if param_hash.size != 15

  proper_keys = [:name, :description, :type, :role, :rarity, :color, :health_mod, :strength_mod, :defense_mod, :speed_mod, :wisdom_mod, :ap_mod, :ability1, :ability2, :ability3]

  # convert string keys to symbol keys
  if param_hash.keys.any? {|key| key.class == String}
    new_param_hash == {}
    param_hash.each_pair do |k, v|
      new_param_hash[k.to_sym] = v if k.class == String
    end
    param_hash = new_param_hash
  end

  raise StandardError, "At least 1 Hash key is invalid" unless param_hash.keys.difference(proper_keys).empty?

  text_based = [:name, :description, :type, :role, :rarity, :color, :ability1, :ability2, :ability3]
  integer_based = [:health_mod, :strength_mod, :defense_mod, :speed_mod, :wisdom_mod, :ap_mod]

  #validate values
  param_hash.each_pair do |key, value|
    if text_based.include?(key)
      cleaned_value = value.downcase.split(' ').map do |word| #removes all extra spaces
        if key == :description
          word.split('').map {|letter| letter.gsub(/[^a-z.]/, '')}.join('') # cleans each word but allows . and letters
        else
          word.split('').map {|letter| letter.gsub(/[^a-z]/, '')}.join('') # removes all non letter characters
        end
      end.join(' ') # joins each word with a single space

      if [:name, :description, :type, :role, :rarity].include?(key)
        raise StandardError, "Value for #{key} must be a non empty string" if cleaned_value.empty? || cleaned_value.nil?
        if [:type, :role, :rarity].include?(key)
          raise StandardError, "Value for #{key} is invalid" unless cleaned_value.split.length == 1
        end
      end

      if [:ability1, :ability2, :ability3].include?(key)
        raise StandardError, "Value for #{key} must be a string (can be empty)" unless cleaned_value.class == String || cleaned_value.nil? || cleaned_value.empty?
        cleaned_value = value.empty? ? nil : value
      end
    end

    if integer_based.include?(key)
      cleaned_value = value.class == Float ? value.to_i : value
      raise StandardError, "Value for #{key} must be an integer" unless value.class == Integer
    end

    param_hash[key] = cleaned_value
  end

  # capitalize each word and sentence (description only)
  param_hash[:name] = param_hash[:name].split(' ').map {|word| word.capitalize}.join(' ')
  param_hash[:description] = param_hash[:description].split('. ').map {|line| line.strip.capitalize}.join('. ')

  #final validations:
  param_hash.each_pair do |key, value|
    case key
    when :type
      valid_types = ['head', 'chest', 'arm', 'leg', 'weapon', 'shield', 'accessory']
      raise StandardError, "Invalid value for type" unless valid_types.include?(value)
    when :role
      valid_roles = ['offense', 'defense', 'utility']
      raise StandardError, "Invalid value for role" unless valid_roles.include?(value)
    when :rarity
      valid_rarities = ['common', 'rare', 'epic', 'legendary']
      raise StandardError, "Invalid value for rarity" unless valid_rarities.include?(value)
    when :color
      valid_colors = ['red', 'grey', 'blue', 'green', 'orange', 'purple']
      raise StandardError, "Invalid value for color" unless valid_colors.include?(value)
    when :ability1 || :ability2 || :ability3
      next if value.nil?

      defined_abilities = AbilityDefs.constants
      ability_check = value.upcase.to_sym
      raise StandardError, "Ability value must be defined first - see ability_defs" unless defined_abilities.include?(ability_check)
    else
      # basic second checks against _mods
      raise StandardError, "Final validation failed for #{key}" if value.class != Integer
      raise StandardError, "Final validation failed for #{key}" if value.nil?
    end
  end

  param_hash
end

p = sanitize(p)
conn = DBConnect.connect
conn.exec_params(
  "INSERT INTO equipment (
    name,
    description,
    type,
    role,
    rarity,
    color,
    health_mod,
    strength_mod,
    defense_mod,
    speed_mod,
    wisdom_mod,
    ap_mod,
    ability1,
    ability2,
    ability3
) VALUES (
    $1::varchar(100),
    $2::text,
    $3::varchar(25),
    $4::varchar(25),
    $5::varchar(25),
    $6::varchar(25),
    $7::integer,
    $8::integer,
    $9::integer,
    $10::integer,
    $11::integer,
    $12::integer,
    $13::varchar(255),
    $14::varchar(255),
    $15::varchar(255)
  );", [p[:name], p[:description], p[:type], p[:role], p[:rarity], p[:color], p[:health_mod], p[:strength_mod],
        p[:defense_mod], p[:speed_mod], p[:wisdom_mod], p[:ap_mod], p[:ability1], p[:ability2], p[:ability3]]
)