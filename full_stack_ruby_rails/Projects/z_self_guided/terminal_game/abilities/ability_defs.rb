module AbilityDefs
  #magic
  MEND = {cost: 3, description: "Heals a small amount of health."}
  SHOCK = {cost: 4, description: "A bolt of magic energy that deals low damage."}
  FIREBALL = {cost: 5, description: "A small fireball thet deals moderate damage."}

  #physical
  PUMMEL = {cost: 5, description: "A mighty strike that deals high damage."}
  QUICK_SHOT = {cost: 3, description: "A low damage attack that always strikes first."}
  DOUBLE_STRIKE = {cost: 6, description: "Two moderate damage attacks that can each trigger lucky."}

  #utility
  RAGE = {cost: 1, description: "Temporary boost to a warrior's rage for increased damage."}
  HUNTERS_MARK = {cost: 3, description: "Marks a target for 5 hits. All damage dealt during that time does 10% more."}
  LUCKY = {cost: 0, description: "A passive rouge ability that allows for critical hits."}
end