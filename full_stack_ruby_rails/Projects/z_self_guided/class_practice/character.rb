#character class
#TODO: create a set of stats to be used by a character:
#  - name
#  - race
#  - class type
#  - etc...
require_relative './stat_setup'


class Character
  extend StatSetup
  # include BattleActions

  attr_accessor :first_name, :last_name, :gender, :affinity, :karma, :origin, :region, :subregion, :character_class, :level, :health, :strength, :wisdom, :dexterity, :stealth
  attr_reader :alive
  # this ruby method creates getters / setters for all listed - attr_reader, attr_writer can limit for just getter or setter

  def initialize # this is called a constructor and is automatically triggerd on a Class.new call
    stats = StatSetup.generate

    @alive = true
    @first_name = StatSetup.character_name(self)[:first_name]
    @last_name = StatSetup.character_name(self)[:last_name]
    @gender = stats[:gender]
    @affinity = stats[:affinity]
    @karma = stats[:karma]
    @origin = stats[:origin]
    @region = StatSetup.world_info(self)[:region]
    @subregion = StatSetup.world_info(self)[:subregion]
    @provence = StatSetup.world_info(self)[:provence]
    @character_class = stats[:class]
    @level = stats[:level]
    @health = stats[:health]
    @karma = stats[:karma]
    @strength = stats[:strength]
    @wisdom =  stats[:wisdom]
    @dexterity = stats[:dexterity]
    @stealth = stats[:stealth]

    # @backstory = StatSetup.backstory(self)

  end

  # getters collect information from the object
  #      ruby getters will be named "def stats", not "def get_stats"
  # setters set information on the object - update the value of something in the object
  #      ruby setters will be named "def stats=(value)", not "def set_stats(value)"
  #          where = delineates that the method is a setter | always returns input value
  def get_stats
    puts self.inspect
  end
  def level_up(details: true)
    weights = [] #str wis dex stl
    case character_class
      when 'warrior' then weights = [30, 50, 50, 70]
      when 'wizard' then weights = [70, 30, 50, 50]
      when 'ranger' then weights = [50, 70, 30, 50]
      when 'assassin' then weights = [50, 50, 70, 30]
    end

    info = []
    unless self.level == 10
      self.level += 1
        info.push("level increased by 1 to #{self.level}")

      old = self.health
      hp = self.health = self.health + (self.level * 2) + rand(1..6)
        info.push("health increased from #{old} to #{hp}")

      str_check = rand(1..100) > weights[0]
        old = self.strength
        str = self.strength = str_check ? self.strength + 1 : self.strength
        info.push("strength increased from #{old} to #{str}") if str_check

      w_check = rand(1..100) > weights[1]
        old = self.wisdom
        self.wisdom = w_check ? self.wisdom + 1 : self.wisdom
        info.push("wisdom increased from #{old} to #{self.wisdom}") if w_check

      d_check = rand(1..100) > weights[2]
        old = self.dexterity
        self.dexterity = d_check ? self.dexterity + 1 : self.dexterity
        info.push("dexterity increased from #{old} to #{self.dexterity}") if d_check

      stl_check = rand(1..100) > weights[3]
        old = self.stealth
        self.stealth = stl_check ? self.stealth + 1 : self.stealth
        info.push("stealth increased from #{old} to #{self.stealth}") if stl_check
    else
      info.push("already at max level")
    end

    if details
      info.join(' | ')
    end
  end

  def check_affinity
    self.affinity = case self.karma
                      when 0..3 then 'evil'
                      when 5..7 then 'neutral'
                      when 9..11 then 'good'
                    end
    self.affinity
  end

  def set_name(first, last)
    self.first_name = first
    self.last_name = last
  end

  def name
    "#{first_name} #{last_name}"
  end

  def death
    @alive = false
  end

  def revive
    @alive = true
  end

end

one = Character.new
# # two = Character.new
# #
# # 9.times do
# #   one.level_up
# #   two.level_up
# # end
#
# puts one.get_stats
# # puts two.get_stats

