#!/bin/env bash

#  ___               __  _
# |   \ __ _ _  _   /  \/ |
# | |) / _` | || | | () | |
# |___/\__,_|\_, |  \__/|_|
#            |__/
#
# "Fixing my expense report"

# Challenge:
# Specifically, they need you to find the two entries that sum to 2020 and then
# multiply those two numbers together.

mapfile -t LIST < expense_report.txt

for A in ${LIST[@]}
do
  for B in ${LIST[@]}
  do
    # Pair of nested loops, so this will return the same answer twice
    [ $(($A + $B)) -eq 2020 ] && echo "$A plus $B = $(($A + $B)). Multiplied: $(( $A * $B ))"
  done
done
