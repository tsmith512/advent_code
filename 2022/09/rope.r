#   ___               __  ___
#  |   \ __ _ _  _   /  \/ _ \
#  | |) / _` | || | | () \_, /
#  |___/\__,_|\_, |  \__/ /_/
#             |__/
#
# "Rope Bridge"
#
# Given a list of steps for how the head of a rope should move, figure out where
# the tail goes and keep track of all the positions it stopped in along the way.

lines <- scan("sample.txt", what = "")
rows <- length(lines)
cols <- 2
steps <- read.table(
  "sample.txt",
  sep = " ",
  col.names = c("dir", "n"),
  stringsAsFactors = FALSE
)

field <- matrix(data = 0, nrow = 5, ncol = 5)

steps

field

head <- c(nrow(field),1)
tail <- c(nrow(field),1)
field[tail[1], tail[2]] <- 1

for (s in 1:nrow(steps)) {
  dir <- steps[s, "dir"]

  for (i in 1:steps[s, "n"]) {
    if (dir == "R") {
      head[2] <- head[2] + 1
    } else if (dir == "L") {
      head[2] <- head[2] - 1
    } else if (dir == "U") {
      head[1] <- head[1] - 1
    } else if (dir == "D") {
      head[1] <- head[1] + 1
    }
  }
}

# Print out the map where the field will be a table with:
#   0 - no history for this position
#   1 - tail has been here
#  10 - tail is here currently
# 100 - head is here currently
visualize <- function(f, h, t) {
  x <- f
  f[h[1], h[2]] <- 100 + f[h[1], h[2]]
  f[t[1], t[2]] <- 10 + f[t[1], t[2]]
  print(f)
  print(sprintf("Head (%d,%d), Tail (%d, %d)", h[1], h[2], t[1], t[2]))
}

visualize(field, head, tail)
