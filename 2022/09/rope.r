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

# Generate (return, not print) a sentence with the head/tail positions
show_position <- function(r) {
  h <- r[1,]
  t <- r[rope_length,]
  sprintf("Head (%d,%d), Tail (%d, %d)", h[1], h[2], t[1], t[2])
}

# Rotate a matrix for visualziation with image()
rotate <- function(x) t(apply(x, 2, rev))

# This got too big to output as a matrix in a console. Output an image of the
# field with squares for:
# white - unused space
# gray - tail has been here
# black - rope segment
# red - rope head
visualize <- function(f, r, title = "") {
  x <- f

  for (i in 2:rope_length) {
    x[r[i, 1], r[i, 2]] <- 2
  }
  x[r[1, 1], r[1, 2]] <- 3

  image(
    rotate(x),
    useRaster = TRUE,
    axes = FALSE,
    col = c("white", "gray", "black", "red"),
  )

  mtext(text = title, side = 3)
  mtext(text = show_position(r), side = 1)
}

# Run through the steps in order:
for (s in 1:nrow(steps)) {
  dir <- steps[s, "dir"]

  if (show_progress) {
    cat("\n\n== STEP", s, ":", dir, steps[s, "n"], "\n\n")
  }

  for (i in 1:steps[s, "n"]) {
    png(
      paste("field", sprintf("%02d", s), sprintf("%02d", i), "field.png", sep = "-"),
      width = (ncol(field) * 20) + 100,
      height = (nrow(field) * 20) + 100,
      bg = "white",
    )
    par(oma = rep(0.25, 4))

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
      rope[,1] <- rope[,1] + 1
    }

    # Head can be 1 unit away from Tail in any direction, but not two. If there
    # is a gap, it moves in any direction (including diagonally) but only one
    # space to catch up.
    if (show_progress) {
      visualize(field, rope, paste("Rule", s, ":", steps[s,"dir"], steps[s,"n"], "#", i, "Head", sep = " "))
    }

    for (r in 2:rope_length) {
      prev <- rope[r - 1,]
      this <- rope[r,]
      if (any(abs(prev - this) > 1)) {
        one_step <- unlist(lapply((prev - this), sign))
        this <- this + one_step
        rope[r,] <- this

        # Mark the history if this is the tail
        if (r == rope_length) {
          field[this[1], this[2]] <- 1
        }
      }

      if (show_progress) {
        visualize(field, rope, paste("Rule", s, ":", steps[s,"dir"], steps[s,"n"], "#", i, "R", r, sep = " "))
      }
    }

    dev.off()
  }
}

# Part One: The rope tail touched 5907 positions.
cat("The rope tail touched", sum(field), "positions.\n")
