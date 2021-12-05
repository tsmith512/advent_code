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

# Given a matrix, a column index, whether to keep the most or least common value,
# and what to do in the event of a tie, return a new matrix with only the
# requested value in that column.
scrubMatrixByColumn <- function(matrix, i, minmax, tie) {
  # Average the column. Avg > 0.5 means 1 was more freq
  a <- sum(matrix[,i]) / dim(matrix)[1]

  # Tie? Keep the tie-breaker.
  if (a == 0.5) { k <- tie }

  # When "keep most common"
  else if (minmax == 1 && a > 0.5) { k <- 1 }
  else if (minmax == 1 && a < 0.5) { k <- 0 }

  # When "keep least common"
  else if (minmax == 0 && a > 0.5) { k <- 0 }
  else if (minmax == 0 && a < 0.5) { k <- 1 }

  # Return a new matrix with only rows where i = k.
  matrix[ matrix[, i] == k, ]
}

# Given a matrix, whether to keep most or least common values, and what to do in
# the event of a tie, reduce the matrix to only that value which had the
# requested value for each column index.
reduceSensorMatrix <- function(matrix, minmax, tie) {
  for (col in 1:dim(matrix)[1]) {
    # If there's only one row left, we have our answer.
    if (!is.matrix(matrix)) break

    # Drop rows that don't contain the most common value for this column.
    matrix <- scrubMatrixByColumn(matrix, col, minmax, tie)
  }

  matrix
}

binOxygen <- reduceSensorMatrix(readings, 1, 1)
oxygen <- Reduce(unbin, binOxygen)
sprintf("Oxygen Sensor: %d", oxygen)

binCo2 <- reduceSensorMatrix(readings, 0, 0)
co2 <- Reduce(unbin, binCo2)
sprintf("CO2 Sensor: %d", co2)
