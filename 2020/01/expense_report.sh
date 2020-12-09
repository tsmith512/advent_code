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

mapfile -t LIST < <(cat expense_report.txt | sort -n)
  # NOTE: Sort the list so we can bail when numbers get high. This will save
  # time on Part Two. This redirection worked but I had to research it. Piping
  # the output of `sort` into `mapfile` didn't work because piped commands run
  # in a subshell, so mapfile did work but the array was lost when the subshell
  # terminated.

for A in ${LIST[@]}
do
  for B in ${LIST[@]}
  do
    [ $(($A + $B)) -eq 2020 ] && echo "$A plus $B = $(($A + $B)). Multiplied: $(( $A * $B ))" && break 2
  done
done

# Solution: 399 plus 1621 = 2020. Multiplied: 646779


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
    [ $(($A + $B)) -gt 2020 ] && break 1
    # If A + B is already 2020+, bail out.

    for C in ${LIST[@]}
    do
      [ $(($A + $B + $C)) -eq 2020 ] && echo "$A + $B + $C = $(($A + $B + $C)). Multiplied: $(( $A * $B * $C ))" && break 3
    done
  done
done

# Solution: 591 + 1021 + 408 = 2020. Multiplied: 246191688
