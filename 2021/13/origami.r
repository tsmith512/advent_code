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
lines <- scan("sample.txt", what = "", sep = "\n")

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

    flips <- rbind(flips, list(instruction[1], as.numeric(instruction[2])))
  }
}

# R is one-indexed, not zero-indexed. So we need to add 1 to all coords and then
# remember I did that when I get super confused later...
coords <- coords + 1

print(coords)
print(flips)
