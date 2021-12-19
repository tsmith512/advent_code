#  ___              _ ____
# |   \ __ _ _  _  / |__ /
# | |) / _` | || | | ||_ \
# |___/\__,_|\_, | |_|___/
#            |__/
#
# "Transparent Origami"
#
# Challenge:
# Read in coordinates of "marks" on graph paper. After that, fold along the x or
# y axis at the index indicated.
#
# Tricky bits:
# - Graph paper is zero-indexed, but R isn't
# - You don't know the dimensions of the graph paper, just where the dots are...
#   and this messed with @akioohtori because he had a column with no marks in it
# - Gonna have to get good at string manipulation to read the instructions in

# All the lines from the file (coordinates and flip instructions)
lines <- scan("input.txt", what = "", sep = "\n")

# Containers for what we need to process
coords <- matrix(nrow = 0, ncol = 2)
colnames(coords) <- c("x", "y")

flips <- matrix(nrow = 0, ncol = 2)
colnames(flips) <- c("axis", "at")


for (line in lines) {
  if (length(grep("^\\d+,\\d+$", line, perl = TRUE)) > 0) {
    coords <- rbind(coords, as.numeric(unlist(strsplit(line, ","))))
  } else {
    # This piece of work gets and splits the "a=n" part.
    instruction <- unlist(
      strsplit(
        regmatches(line,
          regexpr("(x|y)=\\d+", line, perl = TRUE)
        )
      , "=")
    )

    # @TODO: flips should be a data.frame because it has mixed types. As-is, the
    # "at" address column will be a string, not a number. Cast on use. One-index
    flips <- rbind(flips, c(instruction[1], as.numeric(instruction[2]) + 1))
  }
}

# Make these one-based instead of zero-based.
coords <- coords + 1

# Construct the field
dimensions <- apply(coords, 2, max)

paper <- matrix(
  data = 0,
  ncol = dimensions["x"],
  nrow = dimensions["y"]
)

# Plot each of the coordinates. @TODO: Why does R want to do [y,x] here?
invisible(apply(coords, 1, function(pair) {
  # Use 1 as a "dot" so we can do the flip easily with matrix addition.
  paper[pair["y"], pair["x"]] <<- 1
}))

# Process each of the flips
#                    [ Pt 1 = 1st Fold ]
invisible(apply(flips[1, , drop = FALSE], 1, function(flip) {
  axis <- flip["axis"]
  at <- as.numeric(flip["at"])

  if (axis == "y") {
    # We need to do a horizontal cut and reflect
    top <- paper[1:at - 1,]

    # Fetch the bottom half and then flip it vertically
    bottom <- paper[-(1:at),]
    mirrored <- bottom[c(nrow(bottom):1),]

    paper <<- (top + mirrored)
  } else {
    # We need to do a vertical cut and reflect
    left <- paper[,1:at - 1]

    # Fetch the right half and then flip it horizontally
    right <- paper[,-(1:at)]
    mirrored <- right[,c(ncol(right):1)]

    paper <<- (left + mirrored)
  }

  # Normalize all the "dots" back to 1 in case any of them overlapped.
  paper[paper > 0] <<- 1
}))

print(sprintf("After folding, there are %d dots visible", sum(paper)))

# Part One: (first fold only)
# "After folding, there are 788 dots visible"
