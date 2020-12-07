#!/bin/env lua

-- ___               __ ____
-- |   \ __ _ _  _   /  \__  |
-- | |) / _` | || | | () |/ /
-- |___/\__,_|\_, |  \__//_/
--            |__/
--
-- "Handy Haversacks"
--
-- Challenge:
-- A constraint satisfaction problem. Given a list of rules like "[color] bags
-- can contain {X of [color] bags, Y of [color] bags, ...}", determine how many
-- different color bags could be used to contain at least one of the given bag.
--
-- How many bag colors can eventually contain at least one shiny gold bag?
--
-- In English:
-- - We have a shiny bag
-- - Figure out which color bags can hold shiny bags --> [x]
-- - Figure out which color bags can hold [x] bags --> recursively until we have
--   only no bag colors remaining that can be contained.
-- - Count distinct colors from [x].

for rule in io.lines('sample_rules.txt') do
  print(rule)
end
