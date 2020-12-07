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

INPUT = 'sample_rules.txt'

rules = {}

function parserule(rule)
  print(rule)
  parentcolor = string.match(rule, "(.+) bags contain")
  childrule = string.match(rule, "(%d [^.,]+)[.,]?")
  print(parentcolor)
  print(childrule)
end

-- Debug print of a potentially nested table.
-- Thanks to JCH2k at StackOverflow https://stackoverflow.com/a/22460068
-- and ripter on GitHub (OP) https://gist.github.com/ripter/4270799
-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation, used in recursion only.
function dump (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      dump(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))
    else
      print(formatting .. v)
    end
  end
end

for rule in io.lines(INPUT) do
  parserule(rule)
  print("")
end
