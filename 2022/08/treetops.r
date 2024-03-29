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

  # From each direction, what are the trees to `t` from the edge of the matrix
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


png("forest.png", width = 2000, height = 2000, bg = "white")
par(oma=c(0, 1, 1, 0))
par(mar=c(1, 1, 1, 1))
colors <- colorRampPalette(rev(c("springgreen4", "white")))
heatmap(
  trees,
  Rowv = NA, Colv = NA,
  col = colors(10),
  main = "Forest (Tree Heights)",
  scale = "none"
)
legend(x="right", legend=c("short", seq(1:8), "tall"), fill=colors(10))
x <- dev.off()

png("visible.png", width = 2000, height = 2000, bg = "white")
par(oma=c(0, 1, 1, 0))
colors <- colorRampPalette(rev(c("springgreen4", "white")))
heatmap(
  visible * 1,
  Rowv = NA, Colv = NA,
  col = colors(2),
  main = "Visible Trees (from Forest Edge)",
  scale = "none"
)
x <- dev.off()


#  ___          _     ___
# | _ \__ _ _ _| |_  |_  )
# |  _/ _` | '_|  _|  / /
# |_| \__,_|_|  \__| /___|
#
# Figure out which tree has the highest "scenic score," that is, a product of
# how many trees (N/W/S/E only) it can see, as defined "count every tree between
# X and an edge or the first taller tree."

scenic_score <- function(r, c) {
  # What is the height of the tree at this address?
  t <- trees[r,c]

  # X = In each direction, what are the trees from `t` to the edge of the matrix

  # bX = "how far away is the first tree blocking the view" or NA if the view
  # to the edge is unobstructed. I.e.:  bX is the number of trees visible in
  # that direction OR NA, in which case we should count every tree in X.

  # v[X] = "how many trees are visible in that direction" (which just resolves
  # the "bX || count 'em all" uncertainty) in a single vector to multiply later.

  e <- rev(trees[r,][1:c-1])
  be <- which(e >= t)[1]
  v <- as.vector(if (is.na(be)) length(e) else be)

  w <- tail(trees[r,], -c)
  bw <- which(w >= t)[1]
  v <- c(v, if (is.na(bw)) length(w) else bw)

  n <- rev(trees[,c][1:r-1])
  bn <- which(n >= t)[1]
  v <- c(v, if (is.na(bn)) length(n) else bn)

  s <- tail(trees[,c], -r)
  bs <- which(s >= t)[1]
  v <- c(v, if (is.na(bs)) length(s) else bs)

  # Is this tree visible from any edge?
  prod(v)
}

scenic <- outer(seq(1, rows), seq(1, cols), Vectorize(scenic_score))
max_score <- max(scenic)
where <- which(scenic == max_score, arr.ind = TRUE)
cat(max_score, "is the highest scenic score for any tree on the map.\n")
cat(sprintf("It is at row %d column %d.\n", where[1], where[2]))

# Part Two:
# 519064 is the highest scenic score for any tree on the map.
# It is at row 47 column 8.

png("scenic.png", width = 2000, height = 2000, bg = "white")
colors <- colorRampPalette(c("springgreen4", "white"))
par(oma=c(0, 1, 1, 0))
heatmap(
  scenic,
  Rowv = NA, Colv = NA,
  col = colors(100),
  main = "Scenic Scores",
  scale = "none"
)
x <- dev.off()
