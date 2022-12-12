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

steps <- read.table(
  "input.txt",
  sep = " ",
  col.names = c("dir", "n"),
  stringsAsFactors = FALSE
)

field <- matrix(data = 0, nrow = 5, ncol = 5)

show_progress <- FALSE

# Following the example, start on the bottom left.
head <- c(nrow(field),1)
tail <- c(nrow(field),1)
field[tail[1], tail[2]] <- 1

# Print a sentence with the head/tail positions
show_position <- function (h, t) {
  print(sprintf("Head (%d,%d), Tail (%d, %d)", h[1], h[2], t[1], t[2]))
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

# Run through the steps in order:
for (s in 1:nrow(steps)) {
  dir <- steps[s, "dir"]

  if (show_progress) {
    cat("\n\n== STEP", s, ":", dir, steps[s, "n"], "\n\n")
  }

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
    } else if (head[2] < 1) {
      # yes, but on the _left_ so we have to adjust the current markers
      field <- cbind(rep(0, nrow(field)), field)
      head[2] <- head[2] + 1
      tail[2] <- tail[2] + 1
    }

    # Do we need to add a row?
    if (head[1] >= nrow(field)) {
      field <- rbind(field, rep(0, ncol(field)))
      # yes, but on the _top_ so we have to adjust the current markers
      field <- rbind(rep(0, ncol(field)), field)
      head[1] <- head[1] + 1
      tail[1] <- tail[1] + 1

    }

    # Head can be 1 unit away from Tail in any direction, but not two. If there
    # is a gap, it moves in any direction (including diagonally) but only one
    # space to catch up.
    if (any(abs(head - tail) > 1)) {
      one_step <- unlist(lapply((head - tail), sign))

      if (show_progress) {
        cat("Need to move", one_step)
      }
      tail <- tail + one_step

      # Mark the history
      field[tail[1], tail[2]] <- 1
    }

    if (show_progress) {
      visualize(field, head, tail)
    }
  }
}

# Part One: The rope tail touched 5907 positions.
cat("The rope tail touched", sum(field), "positions.\n")
