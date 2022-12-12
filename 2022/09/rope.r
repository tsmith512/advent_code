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

show_position <- function (h, t) {
  print(sprintf("Head (%d,%d), Tail (%d, %d)", h[1], h[2], t[1], t[2]))
}

distance <- function (h, t) {
  abs(h - t)
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
  show_position(h, t)
}

for (s in 1:nrow(steps)) {
  dir <- steps[s, "dir"]

  cat("\n\n== STEP", s, ":", dir, steps[s, "n"], "\n\n")

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

    # Do we need to add a column?
    if (head[2] >= ncol(field)) {
      field <- cbind(field, rep(0, nrow(field)))
    }

    # Do we need to add a row?
    if (head[1] >= nrow(field)) {
      field <- rbind(field, rep(0, ncol(field)))
    }

    # Head can be 1 unit away from Tail in any direction, but not two. If there
    # is a gap, it moves in any direction (including diagonally) but only one
    # space to catch up.
    if (any(distance(head, tail) > 1)) {
      one_step <- unlist(lapply((head - tail), sign))
      print(one_step)
      tail <- tail + one_step
    }

    visualize(field, head, tail)
  }
}
