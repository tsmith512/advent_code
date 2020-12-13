#!/bin/env tclsh

#  ___              _ ___
# |   \ __ _ _  _  / |_  )
# | |) / _` | || | | |/ /
# |___/\__,_|\_, | |_/___|
#            |__/
#
# "Rain Risk"
#
# Challenge:
# Evade a storm by having a boat follow some obtuse directions. Honestly this
# feels like it might be a little like Day 8.
#
# - Action [NESW] -> move the given direction by given value.
# - Action [LR] -> turn left or right the given NUMBER OF DEGREES.
#   - Only [LR] turn. [NESW] happen but ship translates without rotating.
# - Action F -> move forward in whatever direction ship is currently facing.
# - Ship starts facing EAST.
#
# Report the ship's "Manhattan Distance" (?) from its starting position: the sum
# of the absolute values of its E/W position and its N/S position. The sample
# evaluates to 17+8=25.
