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
  "sample2.txt",
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
# rope[rope_length,] will be the tail
rope <- matrix(
  nrow = rope_length,
  ncol = 2,
  byrow = TRUE,
  data = c(nrow(field),1)
)

# Mark the first history
field[rope[rope_length,1], rope[rope_length,2]] <- 1

# Print a sentence with the head/tail positions
show_position <- function(r) {
  h <- r[1,]
  t <- r[rope_length,]
  print(r)
  print(sprintf("Head (%d,%d), Tail (%d, %d)", h[1], h[2], t[1], t[2]))
}

rotate <- function(x) t(apply(x, 2, rev))

# Print out the map where the field will be a table with:
#   0 - no history for this position
#   1 - tail has been here
#  10 - tail is here currently
# 100 - head is here currently
visualize <- function(f, r) {
  x <- f

  for (i in 1:rope_length) {
    x[r[i, 1], r[i, 2]] <- (i * 10) + x[r[i, 1], r[i, 2]]
  }

  # print(x)
  colors <- colorRampPalette(rev(c("black", "white")))
  image(
    rotate(x),
    useRaster = TRUE,
    axes = FALSE,
    col = c("white", "red", colors(10))
  )
  # show_position(r)
}

# Run through the steps in order:
for (s in 1:nrow(steps)) {
  dir <- steps[s, "dir"]

  if (show_progress) {
    cat("\n\n== STEP", s, ":", dir, steps[s, "n"], "\n\n")
  }

  png(
    "test%02d.png",
    width = (ncol(field) * 10) + 20,
    height = (nrow(field) * 10) + 20,
    bg = "white",
  )
  par(
    mar = rep(1, 4)
  )

  for (i in 1:steps[s, "n"]) {
    if (dir == "R") {
      rope[1,2] <- rope[1,2] + 1
    } else if (dir == "L") {
      rope[1,2] <- rope[1,2] - 1
    } else if (dir == "U") {
      rope[1,1] <- rope[1,1] - 1
    } else if (dir == "D") {
      rope[1,1] <- rope[1,1] + 1
    }

    # Do we need to add a column?
    if (rope[1,2] >= ncol(field)) {
      field <- cbind(field, rep(0, nrow(field)))
    } else if (rope[1,2] < 1) {
      # yes, but on the _left_ so we have to adjust the current markers
      field <- cbind(rep(0, nrow(field)), field)
      rope[,2] <- rope[,2] + 1
    }

    # Do we need to add a row?
    if (rope[1,1] >= nrow(field)) {
      field <- rbind(field, rep(0, ncol(field)))
    } else if (rope[1,1] < 1) {
      # yes, but on the _top_ so we have to adjust the current markers
      field <- rbind(rep(0, ncol(field)), field)
      rope[1,] <- rope[1,] + 1
    }

    # Head can be 1 unit away from Tail in any direction, but not two. If there
    # is a gap, it moves in any direction (including diagonally) but only one
    # space to catch up.


    for (r in 2:rope_length) {
      if (any(abs(rope[r - 1,] - rope[r,]) > 1)) {
        one_step <- unlist(lapply((rope[r - 1,] - rope[r,]), sign))
        rope[r,1] <- rope[r,1] + one_step[1]
        rope[r,2] <- rope[r,2] + one_step[2]

        # Mark the history if this is the tail
        if (r == rope_length) {
          field[rope[r,1], rope[r,2]] <- 1
        }
      }
    }

    if (show_progress) {
      visualize(field, rope)
    }
  }
  dev.off()
}

# Part One: The rope tail touched 5907 positions.
cat("The rope tail touched", sum(field), "positions.\n")

if (show_progress) {
  print(rope)
}
