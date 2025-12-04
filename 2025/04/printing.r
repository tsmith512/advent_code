#  ___               __  _ _
# |   \ __ _ _  _   /  \| | |
# | |) / _` | || | | () |_  _|
# |___/\__,_|\_, |  \__/  |_|
#            |__/
#
# "Printing Department"
#
# Given a shelf of "rolls of wrapping paper" (@) and "empty spaces" (.), find
# and count rolls of wrapping paper where 4 or fewer rolls are in adjacent cells.
#
# > The forklifts can only access a roll of paper if there are fewer than four
# > rolls of paper in the eight adjacent positions.

# Read input to a nested vector of characters
lines <- scan("sample.txt", what = "character")
rows <- length(lines)
cols <- length(unlist(strsplit(lines[1], "")))

# Construct a shelf where rolls are 1 and empty space is 0
shelf <- matrix(
  data = ifelse(unlist(strsplit(lines, "")) == "@", 1, 0),
  nrow = rows,
  ncol = cols,
  byrow = TRUE
)

# Find "count of 1's adjacent to each cell" by shifting the matrix in a circle
# and adding it all together.
heatmap <- function(matrix) {
  # TODO: Can this be more elegant?
  n  <- rbind(              matrix[-1,], rep(0, cols))
  s  <- rbind(rep(0, cols), matrix[-rows,])
  e  <- cbind(              matrix[,-1], rep(0, rows))
  w  <- cbind(rep(0, rows), matrix[,-cols])

  ne <- cbind(              rbind(matrix[-1,],    rep(0, cols))[,-1], rep(0, rows))
  se <- cbind(              rbind(rep(0, cols), matrix[-rows,])[,-1], rep(0, rows))
  nw <- cbind(rep(0, rows), rbind(matrix[-1,],    rep(0, cols))[,-cols])
  sw <- cbind(rep(0, rows), rbind(rep(0, cols), matrix[-rows,])[,-cols])

  # Return a "heatmap" so-to-speak
  n + s + e + w + ne + se + nw + sw
}

# How many loops?
i <- 1
# How many have we removed?
r <- 0
# Track how many we can get at in the next loop:
available <- FALSE

while (i == 1 || sum(available) > 0) {
  # Now, where there are rolls on the shelf AND that cell has < 4 adjacent ones:
  map <- heatmap(shelf)
  available <- shelf & (map < 4)

  # Part One: "Available rolls:  1457"
  print(paste("On loop ", i, ": Available rolls: ", sum(available)))

  r <- r + sum(available)
  print(paste("Running total removed: ", r))
  shelf <- shelf - available
  i <- i + 1
}

#################
## SCRATCHWORK ##
#################
quit()

### THIS WORKS BUT I DIDN'T NEED IT
# Expand the matrix by one in all directions so make some easier math later
field <- matrix(
  data =   rbind(
    rep(0, cols + 2),
    cbind(
      rep(0),
      shelf,
      rep(0)
    ),
    rep(0, cols + 2)
  ),
  nrow = rows + 2,
  ncol = cols + 2,
  byrow = TRUE
)

### THIS DID NOT WORK... WANTED TO MAKE n/e/s/w/ne/se/sw/nw A ONE-LINER OR LOOP
for (vert in 0:2) {
  for (horiz in 0:2) {
    if (vert == 1 && horiz == 1) {
      next
    }
    shelf <- shelf +
      rbind(
        rep(0, ifelse(horiz == -1, 1, 0)),
        cbind(
          rep(0, ifelse(vert == -1, 1, 0)),
          shelf,
          rep(0, ifelse(vert == 1, 1, 0))
        ),
        rep(0, ifelse(horiz == 1, 1, 0)),
      )
  }
}
