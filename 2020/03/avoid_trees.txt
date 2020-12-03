#  ___               __ ____
# |   \ __ _ _  _   /  \__ /
# | |) / _` | || | | () |_ \
# |___/\__,_|\_, |  \__/___/
#            |__/
#
# "Toboggan Trajectory"

# Challenge:
# Given a 2D field of dots and hashes, where dots are "open" and hashes are
# "trees," count the number of trees encountered traversing the field on a given
# slope -- right 3 / down 1. The map repeats horizontally but not vertically.

Haven't picked a language yet, but I need to break this down:
- Read file into array of lines
- Be able to index each line, modulo by length to repeat the field horizontally
- Start at 0,0
- While not at the end:
  - Increment horizontal position 3
  - Increment vertical position 1
  - Read . or #
  - If # count++
- Output count.
