#!/bin/env tclsh

#  ___              _ ___      ___          _     ___
# |   \ __ _ _  _  / |_  )    | _ \__ _ _ _| |_  |_  )
# | |) / _` | || | | |/ /     |  _/ _` | '_|  _|  / /
# |___/\__,_|\_, | |_/___|    |_| \__,_|_|  \__| /___|
#            |__/
#
# "Rain Risk"
#
# Challenge:
# Part Two manipulates a _waypoint_ instead of the ship itslelf except for F.
# New rules:
#
# - Action [NESW] -> move WAYPOINT the given direction by given value.
# - Action [LR] -> rotate WAYPOINT around the ship counterclock/clockwise
# - Action F -> move SHIP forward to WAYPOINT a number of times equal to the
#   given VALUE. (I am still not 100% sure what this means...)
#

# After these steps on the sample, the ship's Manhattan Distance from its
# starting position is 214 + 72 = 286. Report the Manhattan Distance between
# the new location and the ship's starting position.

set file [open "navigation_sample.txt"]
set route [read $file]
close $file

# Ship starting position, still facing east
set ship(heading) 90
set ship(x) 0
set ship(y) 0

# Waypoint start relative to the ship start
set waypoint(x) 10
set waypoint(y) -1

foreach step $route {
  set mode [string index $step 0]
  set value [string range $step 1 end]

  if {$mode == "F"} {
    set diffX [expr {$waypoint(x) - $ship(x)}]
    set diffY [expr {$waypoint(y) - $ship(y)}]
    # puts "Ship $ship(x), $ship(y) heading $ship(heading)"
    # puts "Waypoint $waypoint(x), $waypoint(y)"
    # puts "Difference $diffX, $diffY"
    set ship(x) [expr {$ship(x) + $diffX} * $value]
    set ship(y) [expr {$ship(y) + $diffY} * $value]
  }

  switch $mode {
    N {incr waypoint(y) [expr {0 - $value}]}
    S {incr waypoint(y) $value}
    W {incr waypoint(x) [expr {0 - $value}]}
    E {incr waypoint(x) $value}
    # @TODO: Figure out this rotation
  }

  puts "Ship $ship(x), $ship(y) heading $ship(heading)"
  puts "Waypoint $waypoint(x), $waypoint(y)"
}

puts "Final Waypoint: $waypoint(x), $waypoint(y)"
puts "Final Ship Position: $ship(x), $ship(y)"
puts "Manhattan distance: [expr abs($ship(x)) + abs($ship(y))]"
