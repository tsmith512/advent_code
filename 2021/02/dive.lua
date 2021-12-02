#!/usr/bin/env lua

--  ___               __ ___
-- |   \ __ _ _  _   /  \_  )
-- | |) / _` | || | | () / /
-- |___/\__,_|\_, |  \__/___|
--            |__/
--
-- "Dive!"
--
-- Challenge: From `depth = 0` and `horizontal = 0', follow given instructions
-- to a specific position. Then return the product of depth * horizontal.
--
-- 'up' -> depth--
-- 'down' -> depth++
-- 'forward' -> horizontal++ (there's no backing up in Part 1)
-- (no left/right in Part 1)

INPUT = 'part1_input.txt'

DEPTH = 0
HORIZ = 0

function navigate (input)
  local direction, distance = string.match(input, "(%a+) (%d+)")

  if     direction == "up"      then DEPTH = DEPTH - distance
  elseif direction == "down"    then DEPTH = DEPTH + distance
  elseif direction == "forward" then HORIZ = HORIZ + distance
  else print(string.format("Unknown rule %s", input))
  end
end

for rule in io.lines(INPUT) do
  navigate(rule)
end

print("\nPart One:")
print(string.format("Position: Depth = %d, Horizontal = %d", DEPTH, HORIZ))
print(string.format("Product of position components: %d", DEPTH * HORIZ))

-- Position: Depth = 1051, Horizontal = 2162
-- Product of position components: 2272262

--  ___          _     ___
-- | _ \__ _ _ _| |_  |_  )
-- |  _/ _` | '_|  _|  / /
-- |_| \__,_|_|  \__| /___|
--
-- Same concept, adding a new variable "aim"
-- 'down' --> aim++
-- 'up' --> aim--
-- 'forward x' --> horiz+=x  depth+=(aim * x)

aDEPTH = 0
aHORIZ = 0
AIM    = 0

function navigate_with_aim (input)
  local direction, distance = string.match(input, "(%a+) (%d+)")

  if     direction == "up"      then AIM = AIM - distance
  elseif direction == "down"    then AIM = AIM + distance
  elseif direction == "forward" then
    aHORIZ = aHORIZ + distance
    aDEPTH = aDEPTH + (AIM * distance)
  else print(string.format("Unknown rule %s", input))
  end
end

for rule in io.lines(INPUT) do
  navigate_with_aim(rule)
end

print("\nPart Two:")
print(string.format("Position: Depth = %d, Horizontal = %d", aDEPTH, aHORIZ))
print(string.format("Product of position components: %d", aDEPTH * aHORIZ))

-- Part Two:
-- Position: Depth = 987457, Horizontal = 2162
-- Product of position components: 2134882034
