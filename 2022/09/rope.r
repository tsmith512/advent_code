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
#
#  ___          _     ___
# | _ \__ _ _ _| |_  |_  )
# |  _/ _` | '_|  _|  / /
# |_| \__,_|_|  \__| /___|
#
# For indescribable narrative reasons, the rope is now longer (or "in pieces",
# but...) and each segment moves towards the preceeding segment following the
# original rules. So I'm gonna try to abstract rope length in the original code.

steps <- read.table(
  "sample.txt",
  sep = " ",
  col.names = c("dir", "n"),
  stringsAsFactors = FALSE
)

field <- matrix(data = 0, nrow = 5, ncol = 5)

show_progress <- TRUE
rope_length <- 10

# Following the example, start on the bottom left.
# PART TWO: Instead of head and tail both int[2], use int[X[2]] as a rope
# rope[1,] will be the head
# rope[rope_length + 1,] will be the tail
rope <- matrix(
  nrow = rope_length + 1,
  ncol = 2,
  byrow = TRUE,
  data = c(nrow(field),1)
)

# Mark the first history
field[rope[rope_length + 1,1], rope[rope_length + 1,2]] <- 1

rope

# Print a sentence with the head/tail positions
show_position <- function(r) {
  h <- r[1,]
  t <- r[rope_length + 1,]
  print(sprintf("Head (%d,%d), Tail (%d, %d)", h[1], h[2], t[1], t[2]))
}

# Print out the map where the field will be a table with:
#   0 - no history for this position
#   1 - tail has been here
#  10 - tail is here currently
# 100 - head is here currently
visualize <- function(f, r) {
  x <- f
  h <- r[1,]
  t <- r[rope_length + 1,]

  # @TODO: Make this not a loop
  # for (i in c(1, 10)) {
  #   f[r[i, 1], r[i, 2]] <- (i * 10) + f[r[i, 1], r[i, 2]]
  # }
  f[h[1], h[2]] <- 100 + f[h[1], h[2]]
  f[t[1], t[2]] <- 10 + f[t[1], t[2]]

  print(f)
  show_position(r)
}

# Run through the steps in order:
for (s in 1:nrow(steps)) {
  dir <- steps[s, "dir"]

  if (show_progress) {
    cat("\n\n== STEP", s, ":", dir, steps[s, "n"], "\n\n")
  }

  for (i in 1:steps[s, "n"]) {
    head <- rope[1,]
    tail <- rope[rope_length + 1,]

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
      # @TODO: Will need to update each rope row
    }

    # Do we need to add a row?
    if (head[1] >= nrow(field)) {
      field <- rbind(field, rep(0, ncol(field)))
      # yes, but on the _top_ so we have to adjust the current markers
      field <- rbind(rep(0, ncol(field)), field)
      head[1] <- head[1] + 1
      tail[1] <- tail[1] + 1
      # @TODO: Will need to update each rope row
    }

    # Update values (@WIP: This is just the head and tail, not pieces between)
    rope[1,] <- head
    rope[rope_length + 1,] <- tail


    # Head can be 1 unit away from Tail in any direction, but not two. If there
    # is a gap, it moves in any direction (including diagonally) but only one
    # space to catch up.
    if (any(abs(head - tail) > 1)) {
      one_step <- unlist(lapply((head - tail), sign))

      if (show_progress) {
        cat("Need to move", one_step, "\n")
      }
      tail <- tail + one_step
      rope[rope_length + 1,] <- tail

      # Mark the history
      field[tail[1], tail[2]] <- 1
    }

    if (show_progress) {
      visualize(field, rope)
    }
  }
}

# Part One: The rope tail touched 5907 positions.
cat("The rope tail touched", sum(field), "positions.\n")
