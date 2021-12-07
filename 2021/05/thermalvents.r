#  ___               __  ___
# |   \ __ _ _  _   /  \| __|
# | |) / _` | || | | () |__ \
# |___/\__,_|\_, |  \__/|___/
#            |__/
#
# "Hydrothermal Venture"
#
# Challenge:
# Given a list of vectors (like, two coord pairs) figure out which represent
# straight lines through a field and calc the number of points with a value > 2.

# Make a field. The sample is 10x10, the production data are 1000x1000
size <- 1000
field <- matrix(data = 0, nrow = size, ncol = size)

# Check two coord pairs and see if they're a horiz or vert line?
straightLine <- function(a, b) {
  if (a[1] == b[1] || a[2] == b[2]) {
    TRUE
  } else {
    FALSE
  }
}

for (line in scan("input.txt", what = "raw", sep = "\n")) {
  # Split the line up into numbers and pair them into coordinates.
  x <- unlist(strsplit(line, "(,| -> )", perl = TRUE))

  # Rotate the incoming coord pairs and add 1 since R is 1-indexed.
  a <- c(strtoi(x[2]) + 1, strtoi(x[1]) + 1)
  b <- c(strtoi(x[4]) + 1, strtoi(x[3]) + 1)

  # For Part 1, we're told to only look at straight lines.
  if (straightLine(a, b) == TRUE) {
    # Make a fresh matrix of zeroes, and put a 1 where this line passes
    updates <- matrix(data = 0, nrow = size, ncol = size)
    updates[a[1]:b[1],a[2]:b[2]] <- 1

    # Add the updates to the field that exists.
    field <- field + updates
  } else {
    #  ___          _     ___
    # | _ \__ _ _ _| |_  |_  )
    # |  _/ _` | '_|  _|  / /
    # |_| \__,_|_|  \__| /___|
    #
    # Also diagonal lines, lol.
    updates <- matrix(data = 0, nrow = size, ncol = size)

    # Assign 1 to the diagonal described by the line
    diag(updates[a[1]:b[1],a[2]:b[2]]) <- 1

    # Like above, add to field and move on.
    field <- field + updates
  }
}

hotspots <- sum(field > 1, na.rm = TRUE)
sprintf("There are %d hotspots in the field.", hotspots)

# Part One:
# [1] "There are 5145 hotspots in the field."

# Part Two:
# [1] "There are 16518 hotspots in the field."
