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

# This will be a matrix of:
# "." open space (prettier to print this way)
# "H" the rope head is here
# "T" the rope tail is here
# "X" the rope is overlapped here
# "#" the rope has been here (doesn't matter if this gets overwritten; not a count)
field <- matrix(data = ".", nrow = 5, ncol = 5)
field[nrow(field),1] <- "X"


# Where is the head of the rope?
findH <- function() {
  h <- which(field == "H", arr.ind = TRUE)

  # Are they overlapped?
  if (length(h) < 1) {
    h <- findX()
  }

  h[1,]
}

setH <- function(r, c) {
  val <- field[r, c]
cat(r, c, val, "\n")
  if (val == "T") {
    # If the tail was here already, the head now overlaps it
    field[r, c] <- "X"
  } else if (val == ".") {
    # If this was empty space, the head is here now
    field[r, c] <- "H"
  } else {
    cat("Unhandled case, original value was", val, "\n")
  }
}

findT <- function() {
  t <- which(field == "T", arr.ind = TRUE)

  # Are they overlapped?
  if (length(t) < 1) {
    t <- findX()
  }

  t[1,]
}

# We'll only call this in findH or findT when we know there's an overlap, and
# we'll unlist in those functions
findX <- function() {
  which(field == "X", arr.ind = TRUE)
}

print(sprintf("Starting position: %d, %d", findH()[1], findH()[2]))
field
for (s in 1:nrow(steps)) {
  dir <- steps[s, "dir"]

  for (i in 1:steps[s, "n"]) {
    head <- findH()
    prev <- head
    if (dir == "R") {
      head[2] <- head[2] + 1
    } else if (dir == "L") {
      head[2] <- head[2] - 1
    } else if (dir == "U") {
      head[1] <- head[1] - 1
    } else if (dir == "D") {
      head[1] <- head[1] + 1
    }

    setH(head[1], head[2])
  }
}
field
# Print out the map where the field will be a table with:
#   0 - no history for this position
#   1 - tail has been here
#  10 - tail is here currently
# 100 - head is here currently
visualize <- function(f, h, t) {
  print(sprintf("Head (%d,%d), Tail (%d, %d)", h[1], h[2], t[1], t[2]))
}

# visualize(field, head, tail)
