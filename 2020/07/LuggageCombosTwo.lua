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

INPUT = 'luggage_rules.txt'

-- Collect all puzzle rules into a table like this:
-- rules[parent-color][child-color] == allowable-quantity
rules = {}

-- Find the children of a particular bag
function getchildren (parentcolor, depth)
  if not depth then depth = 0 end
  quantity = 0

  -- Given bag type has no allowable parents. This is the inner-most nesting doll
  if isempty(rules[parentcolor]) then
    print("|" .. string.rep("    ", depth) .. parentcolor)

    -- No bags inside this one
    return quantity
  end

  -- For the types of bags this can contain, how many?
  for childcolor, requiredquantity in pairs(rules[parentcolor]) do
    print("|" .. string.rep("    ", depth) .. "- " .. parentcolor .. " > " .. requiredquantity .. " x " .. childcolor)

    -- This bag contains: required number of this type
    quantity = quantity + requiredquantity

    -- And all its children
    quantity = quantity + (requiredquantity * getchildren(childcolor, depth + 1))

    -- Report on what we've collected at this level
    print("|" .. string.rep("    ", depth) .. "  " .. quantity)
  end

  return quantity
end

--
-- MAIN:
--
for rule in io.lines(INPUT) do
  parserule(rule)
end

print("PART TWO: Looking for all descendants of a shiny gold bag")
totalcount = getchildren("shiny gold")
print("\n** Within the shiny gold bag, there are " .. math.floor(totalcount) .. " bags.")

-- Part Two answer:
-- ** Within the shiny gold bag, there are 45018 bags.
