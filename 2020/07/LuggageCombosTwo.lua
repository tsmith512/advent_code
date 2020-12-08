#!/bin/env lua

--  ___               __ _____   ___          _     ___
-- |   \ __ _ _  _   /  \__  |  | _ \__ _ _ _| |_  |_  )
-- | |) / _` | || | | () |/ /   |  _/ _` | '_|  _|  / /
-- |___/\__,_|\_, |  \__//_/    |_| \__,_|_|  \__| /___|
--            |__/
--
-- "Handy Haversacks"
--
-- Challenge:
-- Reverse of LuggageCombos.lua, we need to traverse the potential children of
-- the given bag type and count how many bags "one gold shiny bag" contains.

-- Grab all my functions from Part One
dofile "LuggageCombos.lua"

INPUT = 'sample_rules_pt2.txt'

-- Collect all puzzle rules into a table like this:
-- rules[parent-color][child-color] == allowable-quantity
-- See parserule() and parsechildren()
rules = {}

-- OVERRIDE PART ONE FILE
-- Given a rule from the puzzle input
-- Then insert the set into {rules} above.
function parserule (rule)
  local parentcolor, allowablechildren = string.match(rule, "(.+) bags contain (.+)")
  local childrules = parsechildren(allowablechildren)

  if (not isempty(childrules)) then
    -- This parent bag can hold +1 child types, split and save them
    for index, child in ipairs(childrules) do

      -- Split the quantity from the color of the child member
      local qty, childcolor = string.match(child, "(%d+) (.+) ?")

      -- If rules[parentcolor] is new, set up a table for it
      if rules[parentcolor] == nil then
        rules[parentcolor] = {}
      end

      rules[parentcolor][childcolor] = qty
    end
  else
    -- @TODO: This parent can contain no other bags. I don't think this matters.
  end
end


-- Find the children of a particular bag
function getchildren (parentcolor, depth)
  if not depth then depth = 0 end

  if isempty(rules[parentcolor]) then
    -- Given bag type has no allowable parents. This is the inner-most nesting doll
    print("|" .. string.rep("    ", depth) .. parentcolor)
    return
  end

  for childcolor, requiredquantity in pairs(rules[parentcolor]) do
    print("|" .. string.rep("    ", depth) .. "- " .. parentcolor .. " > " .. requiredquantity .. " x " .. childcolor)
    getchildren(childcolor, depth + 1)
  end

  return
end

--
-- MAIN:
--
for rule in io.lines(INPUT) do
  parserule(rule)
end

print("OUTPUT OF RULES:")
dump(rules)
print("")

print("PART TWO: Looking for all descendants of a shiny gold bag")
getchildren("shiny gold")