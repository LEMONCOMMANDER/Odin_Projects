module AbilityDefs
  #magic
  MEND = {cost: 3, type: "Active", description: "Heals a small amount of health."}
  SHOCK = {cost: 4, type: "Active", description: "A bolt of magic energy that deals low damage."}
  FIREBALL = {cost: 5, type: "Active", description: "A small fireball thet deals moderate damage."}

  #physical
  PUMMEL = {cost: 5, type: "Active", description: "A mighty strike that deals high damage."}
  QUICK_SHOT = {cost: 3, type: "Active", description: "A low damage attack that always strikes first."}
  DOUBLE_STRIKE = {cost: 6, type: "Active", description: "Two moderate damage attacks that can each trigger lucky."}
  CUTPURSE = {cost: 2, type: "Active", description: "A low damage ability that will steal a small amount of gold from the target - first use only."}
  BACKSTAB = {cost: 10, type: "Active", description: "A high damage attack that ignores 15% of the target's defense."}

  #utility
  RAGE = {cost: 1, type: "Active", description: "Temporary boost to a warrior's rage for increased damage."}
  HUNTERS_MARK = {cost: 3, type: "Active", description: "Marks a target for 5 hits. All damage dealt during that time does 10% more."}
  LUCKY = {cost: 0, type: "Passive", description: "A passive rouge ability that allows for critical hits."}
  LETHAL = {cost: 0, type: "Passive", description: "A passive rouge ability the makes critical hits easier to get and do more damage."}
  DODGE = {cost: 6, type: "Active", description: "Prepares to dodge the next attack or ability."}
  BLOCK = {cost: 0, type: "Passive", description: "test ability that does nothing - given from Steel Shield"}
end