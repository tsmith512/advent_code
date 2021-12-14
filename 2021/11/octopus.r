#  ___              _ _
# |   \ __ _ _  _  / / |
# | |) / _` | || | | | |
# |___/\__,_|\_, | |_|_|
#            |__/
#
# "Dumbo Octopus"
# Given a field of octopuses (octopi?)

# Read the the input into a matrix
lines <- scan("sample.txt", what = "")
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


  # If anything that didn't flash is now high enough, it flashes.
  # @TODO: Something about this logic is wrong because when adjacent followup
  # flashes happen, my numbers don't matching the sample. Also this ran more
  # often than I thought it did...
  if (sum(matrix[flashes != 1] > 9)) {
    print(matrix)
    matrix <- flash(matrix)
  }

  matrix
}

for (i in 1:2) {
  # Increment each by one.
  octos <- apply(octos, c(1,2), function(value) value + 1)

  octos <- flash(octos)
  print('')
  print(sprintf('After round %d', i))
  print(octos)
}
