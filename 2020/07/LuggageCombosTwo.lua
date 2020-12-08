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
rules = {}

-- OVERRIDE PART ONE FILE
-- Populate {rules}
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
function getchildren (parentcolor, quantity, depth)
  if not depth then depth = 0 end
  if not quantity then quantity = 0 end

  -- Given bag type has no allowable parents. This is the inner-most nesting doll
  if isempty(rules[parentcolor]) then
    print("|" .. string.rep("    ", depth) .. parentcolor)
    print("|" .. string.rep("    ", depth) .. quantity)

    -- No bags inside this one
    return 0
  end

  -- For the types of bags this can contain, how many?
  for childcolor, requiredquantity in pairs(rules[parentcolor]) do
    print("|" .. string.rep("    ", depth) .. "- " .. parentcolor .. " > " .. requiredquantity .. " x " .. childcolor)
    print("|" .. string.rep("    ", depth) .. "  " .. requiredquantity)

    -- This bag contains: required number of this type, plus all its children
    quantity = quantity + requiredquantity + (requiredquantity * getchildren(childcolor, quantity, depth + 1))
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

print("OUTPUT OF RULES:")
dump(rules)
print("")

print("PART TWO: Looking for all descendants of a shiny gold bag")
print(getchildren("shiny gold"))
