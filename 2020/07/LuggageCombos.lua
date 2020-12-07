#!/bin/env lua

--  ___               __ _____
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

-- Collect all puzzle rules into a table like this:
-- rules[child-color][parent-color] == allowable-quantity
-- See parserule() and parsechildren()
rules = {}


-- Given a rule from the puzzle input
-- (e.g. "clear tan bags contain 5 bright purple bags, 1 pale black bag, 5 muted lime bags.")
-- Split that up into the Parent Color and a table of allowable child members
-- Then insert the set into {rules} above.
function parserule (rule)
  local parentcolor, allowablechildren = string.match(rule, "(.+) bags contain (.+)")
  local childrules = parsechildren(allowablechildren)

  if (not isempty(childrules)) then
    -- This parent bag can hold +1 child types, split and save them
    for index, child in ipairs(childrules) do

      -- Split the quantity from the color of the child member
      local qty, childcolor = string.match(child, "(%d+) (.+) ?")

      -- If rules[childcolor] is new, set up a table for it
      if rules[childcolor] == nil then
        rules[childcolor] = {}
      end

      rules[childcolor][parentcolor] = qty
    end
  else
    -- @TODO: This parent can contain no other bags. I don't think this matters.
  end
end


-- Given the allowable contents string from a puzzle input
-- (e.g. "5 faded blue bags, 6 dotted black bags[...]")
-- split it into its members by recursion
function parsechildren (inputstring, collection)
  if not collection then collection = {} end
  if (inputstring == "no other bags.") then
    return nil
  end

  -- What's the first child bag type?
  local bag, remainder = string.match(inputstring, "(%d [^.,]+) bags?[ .,]?(.+)")

  -- Add this bag type to the collection
  table.insert(collection, bag)

  -- If remainder !empty: the parent bag can hold more, get the next one.
  if (not isempty(remainder)) then
    parsechildren(remainder, collection)
  end

  -- Return the list of bags types we know about
  return collection
end


-- Find the parents of a particular bag
function getparents (childcolor, depth, count)
  if not depth then depth = 0 end
  if not count then count = 0 end

  if (isempty(rules[childcolor])) then
    -- Given bag has no allowable parents, or: this is the outer-most nesting doll.
    count = count + 1
    print("|" .. string.rep("    ", depth) .. childcolor .. " (Solution #" .. count .. ")")
    return count
  end

  for parentcolor, allowablequantity in pairs(rules[childcolor]) do
    print("|" .. string.rep("    ", depth) .. "- " .. childcolor .. " < " .. parentcolor)
    count = getparents(parentcolor, depth + 1, count)
  end

  return count
end


-- Simple utility to test of a var is empty or unset
function isempty (input)
  return input == nil or input == ""
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
end

print("OUTPUT OF RULES:")
dump(rules)
print("")

print("PART ONE: Looking for shiny gold bag")
solutions = getparents("shiny gold")
print("\n** There are " .. solutions .. " combinations to pack the shiny gold bag.")
