#  ___              _ _
# |   \ __ _ _  _  / / |
# | |) / _` | || | | | |
# |___/\__,_|\_, | |_|_|
#            |__/
#
# "Dumbo Octopus"
# Given a field of octopuses (octopi?) each represented by a number 1 to 9. On
# each iteration, increase each by 1. When an octopus reaches 10, it "flashes"
# and increases each adjacent (diagonals included) octopus by +1 and resets to
# 0. This cascades; if the flash brings a surrounding octopus to > 9, it flashes
# too. Resolve each before moving on to the next round. How many total "flashes"
# will have happened by round #100?

# Read the the input into a matrix
lines <- scan("input.txt", what = "")
rows <- length(lines)
cols <- length(unlist(strsplit(lines[1], "")))
octos <- matrix(
  data = as.numeric(unlist(strsplit(lines, ""))),
  nrow = rows,
  ncol = cols,
  byrow = TRUE
)


flash <- function(matrix) {
  # Who's fixin' to flash?
  flashes <- apply(matrix, c(1,2), function(value) if (value > 9) { 1 } else { 0 })
  totalFlashes <<- totalFlashes + sum(flashes)

  # Thank you @duplico for this handy thing you did for 2020 Day 11.
  # We know each adjacent point to a flash increases, and that these overlap.
  # So make 8 matrixes
  n  <- rbind(flashes[-1,], rep(0, cols))
  s  <- rbind(rep(0, cols), flashes[-rows,])
  e  <- cbind(flashes[,-1], rep(0, rows))
  w  <- cbind(rep(0, rows), flashes[,-cols])
  ne <- cbind(rbind(flashes[-1,], rep(0, cols))[,-1], rep(0, rows))
  se <- cbind(rbind(rep(0, cols), flashes[-rows,])[,-1], rep(0, rows))
  nw <- cbind(rep(0, rows), rbind(flashes[-1,], rep(0, cols))[,-cols])
  sw <- cbind(rep(0, rows), rbind(rep(0, cols), flashes[-rows,])[,-cols])


  # Apply these increases
  matrix <- matrix + n + s + e + w + ne + se + nw + sw

  # Anything that flashed is now a zero.
  matrix[flashes == 1] <- 0


  # And if anything is high enough to flash, flash it.
  if (sum(matrix > 9)) {
    matrix <- flash(matrix)
  }

  # Anything that flashed is now a zero again. Because we can only flash once
  # per iteration, so if anyhting was affected in the recursion, reset it.
  matrix[flashes == 1] <- 0

  matrix
}

totalFlashes <- 0

#  ___          _     ___
# | _ \__ _ _ _| |_  |_  )
# |  _/ _` | '_|  _|  / /
# |_| \__,_|_|  \__| /___|
#
# Instead of going to 100, repeat until all octos are back to zero. How long?
# So swap `for i in 1:100` for `while all-octos > 0` but still output #100.

totalRounds <- 0

while (sum(octos) > 0) {
  if (totalRounds == 100) {
    print(sprintf('Total flashes by round 100: %d', totalFlashes))
  }

  # Increment each by one.
  octos <- apply(octos, c(1,2), function(value) value + 1)
  totalRounds <- totalRounds + 1

  octos <- flash(octos)
}

print(sprintf('After round %d, all octos were at zero.', totalRounds))
print(sprintf('Total flashes after round %d: %d', totalRounds, totalFlashes))

# Part One:
# [1] "Total flashes: 1655"

# Part Two:
# [1] "After round 337, all octos were at zero."
# [1] "Total flashes after round 337: 5352"
