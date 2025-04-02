#module for setting up stats
# TODO: this will be a grouping of helper functions that are used to generate the character
# sheets for both monsters and characters in initialization

require 'httparty'
require_relative './api_config'
require 'json'
module StatSetup
  def self.generate
    first_name = nil
    last_name = nil
    gender = nil
    affinity = nil
    karma = nil
    origin = nil
    character_class = nil
    level = nil
    health = nil
    strength = nil
    wisdom = nil
    dexterity = nil
    stealth = nil

    num = rand(1..100)
    character_class = case num
        when 1..25 then 'warrior'
        when 26..50 then 'wizard'
        when 51..75 then 'ranger'
        when 76..100 then 'assassin'
      end

    level = 1
    health = 12 + (level * 2) + rand(1..8)
    origin = ['plains', 'city', 'mountains', 'forest', 'desert', 'village'].sample

      num = rand(1..99)
      mod = rand(-15..15)
    affinity =  (num + mod).between?(67, 99) ? 'good' : (num + mod).between?(1, 33) ? 'evil' : 'neutral'

    karma = case affinity
      when 'good' then rand(9..11)
      when 'evil' then rand(1..3)
      when 'neutral' then rand(5..7)
    end

    strength = character_class == 'warrior' ? rand(1..6) + 2 : character_class == 'wizard' ? rand(2..6) - 1 : rand(1..6)
    wisdom = character_class == 'wizard' ? rand(1..6) + 2 : character_class == 'ranger' ? rand(2..6) - 1 : rand(1..6)
    dexterity = character_class == 'ranger' ? rand(1..6) + 2 : character_class == 'assassin' ? rand(2..6) - 1 : rand(1..6)
    stealth = character_class == 'assassin' ? rand(1..6) + 2 : character_class == 'warrior' ? rand(2..6) - 1 : rand(1..6)

    gender = rand(1..10).odd? ? 'male' : 'female'

    character = {first_name: 'phf', last_name: 'phl', gender: gender, affinity: affinity, karma: karma, origin: origin, class: character_class, level: level, health: health, strength: strength, wisdom: wisdom, dexterity: dexterity, stealth: stealth}
    character
  end

  def self.character_name(character)

  end

  def self.world_info(character)
    # norhaven = Norórë
    # valoria = Iavren-Cuio
    # esgard = Arta-Parahta
    # Thalindor = Thalindor


    region = nil
    subregion = nil
    provence = nil
    region = case character.origin
                  when 'forest' then'Norórë'
                  when 'mountains' then ['Norórë', 'Arta-Parahta'].sample
                  when 'city' then ['Iavren-Cuio', 'Thalindor'].sample
                  when 'plains' then 'Iavren-Cuio'
                  when 'desert' then ['Arta-Parahta', 'Thalindor'].sample
                  when 'village' then ['Norórë', 'Arta-Parahta', 'Iavren-Cuio'].sample
             end

    case region
      when 'Norórë'
        subregions = {
                      frozenpeak_range: ['Hîthloss', 'Taur-Amarth', 'Tûr-Gelair', 'Cûlvarn'],
                      whispering_woods: ['Sûlithîr', 'Thôr-Dôl', 'Tâlbereth', 'Bânthalad', 'Angrenthorn', 'Drû-penin'],
                      frostvale_basin:['Frostvale', 'Rathló', 'Cûl-awarth', 'Kornadûl']
                     }

        subregion = case character.origin
                      when 'forest' then :whispering_woods
                      when 'mountains' then :frozenpeak_range
                      when 'village' then :frostvale_basin
                    end

        provence = subregions.fetch(subregion).sample

      when 'Iavren-Cuio'
        subregions = {
                      eldenmir_plains: ['Eldenmir', 'Orunir', 'Celedhren', 'Abernil Ael'],
                      caelond_hills: ['Caelond', 'Nim-Er', 'Nim-Tád', 'Thalion'],
                      ardhon_fortress: ['Ardhon'],
                      green_sea: ['Gwindar', 'Londae', 'Dagor úrui', 'Glír Dór', 'Ulin']
                     }

        subregion = case character.origin
                      when 'city' then :ardhon_fortress
                      when 'plains' then [:eldenmir_plains, :caelond_hills].sample
                      when 'village' then :green_sea
                    end

        provence = subregions.fetch(subregion).sample

      when 'Arta-Parahta'
        subregions = {
                      ironpeak_mountains: ['Onglîn-i-Gorlak'],
                      bleakrock_pass: ['Morfuku Ost','Pîn Bardh', 'Coe Ant', 'Fânrist Magor', 'Orodcaun'],
                      enders_plateau: ['Tol Eressea']
                     }

        subregion = case character.origin
                      when 'mountains' then :ironpeak_mountains
                      when 'desert' then :bleakrock_pass
                      when 'village' then :enders_plateau
                    end

        provence = subregions.fetch(subregion).sample

      when 'Thalindor'
        subregions = {
                      calenmor: ['Calenmor', 'Tolond', 'The Lorien Stretch'],
                      anír_gilith_desert: ['Ardhâl', 'Aiwenor Ant Oasis', 'Astlant Oasis'],
                      herdirnen_bay: ['Herdirnen', 'Goronath Port', 'Rastrond Port', 'Cerch dôl Annui', 'Virda Port', 'Fán othrond']
                     }

        subregion = case character.origin
                      when 'city' then [:calenmor, :herdirnen_bay].sample
                      when 'desert' then :anír_gilith_desert
                    end

        provence = subregions.fetch(subregion).sample
    end

    {region: region, subregion: subregion.to_s.split('_').join(' '), provence: provence}
  end


  def self.backstory(character)
    puts "backstory for #{character.first_name} #{character.last_name}:"
    puts "#{character.first_name} is a #{character.gender}"
    puts "and was raised in the #{character.origin}"
    puts "and is a #{character.character_class}."
    puts "\n#{character.first_name} tends to lean towards #{character.affinity} activity."
  end
end
