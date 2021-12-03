#  ___               __ ____
# |   \ __ _ _  _   /  \__ /
# | |) / _` | || | | () |_ \
# |___/\__,_|\_, |  \__/___/
#            |__/
#
# "Binary Diagnostic"
#
# Challenge:
# Given a list of binary numbers, derive two things
# - "Gamma rate" = binary number with the most common digit for each index of
#   input numbers
# - "Epsilon rate" = the leas common digit for each index of input numbers.

# Read the the input into a matrix
lines <- scan("input.txt", what = "")
rows <- length(lines)
cols <- length(unlist(strsplit(lines[1], "")))
readings <- matrix(
  data = as.numeric(unlist(strsplit(lines, ""))),
  nrow = rows,
  ncol = cols,
  byrow = TRUE
)

ups <- function(x) {
  if (x > 0) { 1 }
  else       { 0 }
}

downs <- function(x) {
  if (x < 0) { 1 }
  else       { 0 }
}

# Reducer handler to convert a binary number from a vector into a decimal int.
unbin <- function(x, a) {
  (x * 2) + a
}

# Sum the columns, then subtract half the number of rows from each.
# Values greater than 0 meant a 1 was more common.
cols <- (colSums(readings) - rep(rows/2,cols))

# For "gamma", the positive numbers are the `1`s, vice-versa "epsilon"
gamma <- Reduce(unbin, sapply(cols, ups))
sprintf("Gamma: %d", gamma)

epsilon <- Reduce(unbin, sapply(cols, downs))
sprintf("Epsilon: %d", epsilon)

sprintf("Power Consumption: %d", gamma * epsilon)

# Part One:
# [1] "Gamma: 2576"
# [1] "Epsilon: 1519"
# [1] "Power Consumption: 3912944"
