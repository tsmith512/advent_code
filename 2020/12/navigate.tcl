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

set file [open "navigation_instructions.txt"]
set route [read $file]
close $file

set direction 90
set position(x) 0
set position(y) 0

foreach step $route {
  set mode [string index $step 0]
  set value [string range $step 1 end]

  if {$mode == "F"} {
    switch $direction {
        0 {set mode N}
       90 {set mode E}
      180 {set mode S}
      270 {set mode W}
      360 {set mode N}
    }
  }

  switch $mode {
    N {incr position(y) [expr {0 - $value}]}
    S {incr position(y) $value}
    W {incr position(x) [expr {0 - $value}]}
    E {incr position(x) $value}
    L {set direction [expr {[expr {$direction - $value}] % 360}]}
    R {set direction [expr {[expr {$direction + $value}] % 360}]}
  }

  # puts "$position(x), $position(y)"

}

puts "New Position: $position(x), $position(y)"
puts "Manhattan distance: [expr {abs($position(x)) + abs($position(y))}]"
# Part One solution:
#   New Position: 24, 415
#   Manhattan distance: 439
