#   ___               __  ___
#  |   \ __ _ _  _   /  \( _ )
#  | |) / _` | || | | () / _ \
#  |___/\__,_|\_, |  \__/\___/
#             |__/
#
# "Treetop Tree House"
#
# Given a matrix of "trees" (whose heights are the values), figure out how many
# trees are visible in total from the edge. A tree is visible as long as each
# tree between it and _another edge_ are shorter than it is. Consider rows/cols,
# but not diagonals.

lines <- scan("input.txt", what = "")
rows <- length(lines)
cols <- length(unlist(strsplit(lines[1], "")))
trees <- matrix(
  data = as.numeric(unlist(strsplit(lines, ""))),
  nrow = rows,
  ncol = cols,
  byrow = TRUE
)

is_visible <- function(r, c) {
  # What is the height of the tree at this address?
  t <- trees[r,c]

  # In each direction, what are the trees between `t` and the edge of the matrix
  # vX = "is this tree visible from X edge" (`t` is larger than everything between)
  e <- trees[r,][1:c-1]
  ve <- all(t > e)

  w <- rev(tail(trees[r,], -c))
  vw <- all(t > w)

  n <- trees[,c][1:r-1]
  vn <- all(t > n)

  s <- rev(tail(trees[,c], -r))
  vs <- all(t > s)

  # Is this tree visible from any edge?
  any(ve, vw, vn, vs)

}

# Wanted to do this:
# mapply(is_visible, seq(1, rows), seq(1, cols))
# but that only applied on [[1,1], [2,2], [3,3], ...] --> use outer() instead

# NOTE: outer() doesn't call the function for each combination of arguments, but
# instead _once_ on a vector of arguments, which is_visible() won't handle right.
# Using Vectorize() instead

# See https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/Vectorize
# and https://stackoverflow.com/questions/15601359/an-error-in-r-when-i-try-to-apply-outer-function
visible <- outer(seq(1, rows), seq(1, cols), Vectorize(is_visible))

cat(sum(visible), "trees are visible from the edge of the forest.\n")
# Part One: 1546 trees are visible from the edge of the forest.
