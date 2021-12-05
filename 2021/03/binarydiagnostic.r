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
lines <- scan("sample.txt", what = "")
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


#  ___          _     ___
# | _ \__ _ _ _| |_  |_  )
# |  _/ _` | '_|  _|  / /
# |_| \__,_|_|  \__| /___|
#
# Essentually, reduce the matrix by iterating over columns and keeping rows with
# the most (least) common value for that column, using 1 (0) as a tie-breaker to
# find the Oxygen (CO2) sensor values.

# Given a matrix, a column index, and what to do in the event of a tie, return
# the most common value in that column.
# for Oxygen Sensor, tie = 1
# for CO2 Sensor, tie = 0
commonColumn <- function(matrix, i, tie) {
  a <- sum(matrix[,i]) / dim(matrix)[1]
  if      (a > 0.5) { 1   }
  else if (a < 0.5) { 0   }
  else            { tie }
}

# Given a matrix, a column index, and what to do in the event of a tie, return
# a matrix with the only the rows containing the most common value at that index.
dropRows <- function(matrix, i, tie) {
  keep <- commonColumn(matrix, i, tie)
  matrix[ matrix[, i] == keep, ]
}

# Given a matrix and what to do in the event of a tie, reduce the matrix to only
# that value which had the most common value for each column index.
reduceSensorMatrix <- function(matrix, tie) {
  for (col in 1:dim(matrix)[1]) {
    # If there's only one row left, we have our answer.
    if (!is.matrix(matrix)) break
    print(matrix)

    # Drop rows that don't contain the most common value for this column.
    matrix <- dropRows(matrix, col, tie)
  }

  matrix
}

oxygen <- reduceSensorMatrix(readings, 1)
print(Reduce(unbin, oxygen))
