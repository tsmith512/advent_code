#  ___               __  ___
# |   \ __ _ _  _   /  \| __|
# | |) / _` | || | | () |__ \
# |___/\__,_|\_, |  \__/|___/
#            |__/
#
# "Hydrothermal Ventore"
#
# Challenge:
# Given a list of vectors (like, two coord pairs) figure out which represent
# straight lines through a field and calc the number of points with a value > 2.

# Make a field. The sample is 10x10, the production data are 1000x1000
size <- 10
field <- matrix(data = 0, nrow = size, ncol = size)

# Check two coord pairs and see if they're a horiz or vert line?
straightLine <- function(a, b) {
  if (a[1] == b[1] || a[2] == b[2]) {
    TRUE
  } else {
    FALSE
  }
}

for (line in scan("sample.txt", what = "raw", sep = "\n")) {
  # Split the line up into numbers and pair them into coordinates.
  x <- unlist(strsplit(line, "(,| -> )", perl = TRUE))

  # Rotate the incoming coord pairs and add 1 since R is 1-indexed.
  a <- c(strtoi(x[2]) + 1, strtoi(x[1]) + 1)
  b <- c(strtoi(x[4]) + 1, strtoi(x[3]) + 1)

  # For Part 1, we're told to only look at straight lines.
  if (straightLine(a, b) == TRUE) {
    this <- matrix(data = 0, nrow = size, ncol = size)
    this[a[1]:b[1],a[2]:b[2]] <- 1
    field <- field + this
  }
}

hotspots <- sum(field > 1, na.rm = TRUE)
sprintf("There are %d hotspots in the field.", hotspots)
