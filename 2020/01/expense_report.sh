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
    [ $(($A + $B)) -eq 2020 ] && echo "$A plus $B = $(($A + $B)). Multiplied: $(( $A * $B ))" && break 2
  done
done

# Solution: 646779 is the product of 399 and 1621


#  ___          _     ___
# | _ \__ _ _ _| |_  |_  )
# |  _/ _` | '_|  _|  / /
# |_| \__,_|_|  \__| /___|
#
# Find the product of three numbers whose sum is 2020.

# This seems more stupid to do this way with a third nested loop...

for A in ${LIST[@]}
do
  for B in ${LIST[@]}
  do
    for C in ${LIST[@]}
    do
      [ $(($A + $B + $C)) -eq 2020 ] && echo "$A + $B + $C = $(($A + $B + $C)). Multiplied: $(( $A * $B * $C ))" && break 3
    done
  done
done
