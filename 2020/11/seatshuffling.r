#  ___              _ _
# |   \ __ _ _  _  / / |
# | |) / _` | || | | | |
# |___/\__,_|\_, | |_|_|
#            |__/
#
# "Seating System"
#
# Challenge:
# This is a cellular automaton problem essentially. Given a "seating chart" with
# floor spaces (.), empty seats (L), and occupied seats (#), deduce the
# arrangement given the input and these rules:
# - "Adjacent" seats are all 8 surrounding a given seat (so, diagonals too)
# - Transformation rules are applied simultaneously
# - If a seat is Empty (L) without occupied seats (#) adjacent, it fills (#)
# - If a seat is Occupied (#) and 4+ adj are also occupied (#), it empties (L)
# - Otherwise, state does not change.
# - Flooring is always just a floor.
#
# Here are the iterations of the sample chart:
#
# L.LL.LL.LL   #.##.##.##   #.LL.L#.##   #.##.L#.##   #.#L.L#.##   #.#L.L#.##
# LLLLLLL.LL   #######.##   #LLLLLL.L#   #L###LL.L#   #LLL#LL.L#   #LLL#LL.L#
# L.L.L..L..   #.#.#..#..   L.L.L..L..   L.#.#..#..   L.L.L..#..   L.#.L..#..
# LLLL.LL.LL   ####.##.##   #LLL.LL.L#   #L##.##.L#   #LLL.##.L#   #L##.##.L#
# L.LL.LL.LL   #.##.##.##   #.LL.LL.LL   #.##.LL.LL   #.LL.LL.LL   #.#L.LL.LL
# L.LLLLL.LL   #.#####.##   #.LLLL#.##   #.###L#.##   #.LL#L#.##   #.#L#L#.##
# ..L.L.....   ..#.#.....   ..L.L.....   ..#.#.....   ..L.L.....   ..L.L.....
# LLLLLLLLLL   ##########   #LLLLLLLL#   #L######L#   #L#LLLL#L#   #L#L##L#L#
# L.LLLLLL.L   #.######.#   #.LLLLLL.L   #.LL###L.L   #.LLLLLL.L   #.LLLLLL.L
# L.LLLLL.LL   #.#####.##   #.#LLLL.##   #.#L###.##   #.#L#L#.##   #.#L#L#.##
#
# After repeated application of these rules, the seating distribution
# stabilizes. Report how many seats are occupied at that point.


# Read the the original seating chart into a matrix
lines <- scan("seating_sample.txt", what = "")
rows <- length(lines)
cols <- length(unlist(strsplit(lines[1], "")))
seats <- matrix(data = unlist(strsplit(lines, "")), nrow = rows, ncol = cols, byrow = TRUE)

# UTILITY FUNCTIONS

# Figure out how many seats of a given type are in this area
countType <- function(matrix, type) {
  length(which(matrix == type))
}

# Crop out a matrix of the neighbors for a given seat designation
getNeighbors <- function(row, col, matrix) {
  maxRow <- length(matrix[,1])
  maxCol <- length(matrix[1,])

  # Thankfully the 0,0 bounds are automatically "cropped," but figure max-bounds
  row2 <- if(row >= maxRow) maxRow else row + 1
  col2 <- if(col >= maxCol) maxCol else col + 1

  matrix[(row-1):row2, (col-1):col2]
}

# Return counts of seat statuses
seatReport <- function(matrix) {
  setNames(
    c(countType(matrix, "."), countType(matrix, "L"), countType(matrix, "#")),
    c("floor", "empty", "taken")
  )
}

# Apply the rules to a copy of the seatmap and return the new state
iterateSeats <- function(before) {
  # I couldn't figure out how to do this "simultaneously" so I'm reading from
  # Before and writing to / returning After.
  after <- before
  maxRow <- length(before[,1])
  maxCol <- length(before[1,])
  for (row in 1:maxRow) {
    for (col in 1:maxCol) {
      status <- before[row,col]
      neighbors <- getNeighbors(row, col, before)

      if (status == ".") {
        # Floor tile. No action.
      }
      else if (status == "L") {
        # An empty Seat.
        if (countType(neighbors, "#") == 0) {
          after[row,col] = "#"
        }
      }
      else if (status == "#") {
        # Occupied Seat
        if (countType(neighbors, "#") >= 5) {
          # The rule is +4 adjacent seats, but our count will also include the
          # current seat, so we need to check for 5+
          after[row,col] = "L"
        }
      }
    }
  }
  after
}

# Determine seat stats for the initial seatmap
beforeStats <- seatReport(seats)
afterStats <- seatReport(list())
i <- 0

while (! all(beforeStats == afterStats) ) {
  i <- i + 1

  beforeStats <- afterStats
  seats <- iterateSeats(seats)
  afterStats <- seatReport(seats)

  cat(sprintf("\n\nIteration %d\n", i))
  print(afterStats)
}
# Part One solution:
#   Iteration 134
#   floor empty taken
#    1425  4914  2211


#  ___          _     ___
# | _ \__ _ _ _| |_  |_  )
# |  _/ _` | '_|  _|  / /
# |_| \__,_|_|  \__| /___|
#
# Rules adjustment:
# - When considering adjacent seats, look for the _first_seat_ in that direction
#   regardless of distance. Examples:
#
#   L sees 8 occipued.     L sees 0 occupied.     A sees 1 empty.
#   .......#.              .##.##.                .............
#   ...#.....              #.#.#.#                .A.L.#.#.#.#.
#   .#.......              ##...##                .............
#   .........              ...L...
#   ..#L....#              ##...##
#   ....#....              #.#.#.#
#   .........              .##.##.
#   #........
#   ...#.....
#
# - It is 5 or more visible occupied seats for an occupied seat to empty (vs 4).
#
# After it stabilizes, the sample input produces 26 occupied seats.

getAdjacentBySight <- function(row, col, matrix) {
  # English:
  # - Rather than just cropping out a 3x3 around [row,col]...
  # - ...start at given seat addrress and then trace out in each direction
  # - For each direction:
  #   - Go "straight" looking for a "L" or "#", skipping any "."
  #     - If we hit a matrix boundary only having seen ".", keep "."
  #   - Put encountered letters back in a [3,3] matrix around an X so we can use
  #     the rest of what we had before.
  seen <- matrix(data = "", nrow = 3, ncol = 3, byrow = TRUE)
  maxRow <- length(matrix[,1])
  maxCol <- length(matrix[1,])

  # Go around the clock, take [ORIGIN:DESTINATION] and get the first non-floor
  # value from it (or floor, if that's all there is)
  for (r in 1:3) {
    if (r == 1) {destR <- 1}          # We're looking "up"
    else if (r == 2) {destR <- row}   # We're looking L/R
    else {destR <- maxRow}            # We're looking "down"

    for (c in 1:3) {
      if (c == 1) {destC <- 1}        # Looking "left"
      else if (c == 2) {destC <- col} # Looking U/D
      else {destC <- maxCol}          # Looking "right"

      # This is the seat we're looking _from_
      if (r == 2 && c == 2) {
        seen[r, c] <- matrix[row, col]
        next
      }

      # Determine which "axis" we're looking across, or if we need a diagonal
      if (row == destR) line <- matrix[row, col:destC]
      else if (col == destC) line <- matrix[row:destR, col]
      else line <- diag(matrix[row:destR, col:destC])

      # Save the first seat we see in the given direction
      seen[r, c] <- getFirstSeatSeen(line)
    }
  }
  seen
}

getFirstSeatSeen <- function(line) {
  status <- NULL
  # For legibility reasons above, the first element in the line will be the
  # current seat, we should skip that.
  for (value in line[-1]) {
    status <- value
    if(value != ".") break
  }
  status
}


testMatrixA <- matrix(data =
c(".", "#", "#", ".", "#", "#", ".",
  "#", ".", "#", ".", "#", ".", "#",
  "#", "#", ".", ".", ".", "#", "#",
  ".", ".", ".", "X", ".", ".", ".",
  "#", "#", ".", ".", ".", "#", "#",
  "#", ".", "#", ".", "#", ".", "#",
  ".", "#", "#", ".", "#", "#", "."), nrow = 7, ncol = 7, byrow = TRUE)

print(getAdjacentBySight(4, 4, testMatrixA))

testMatrixB <- matrix(data = c(
".", ".", ".", ".", ".", ".", ".", "#", ".",
".", ".", ".", "#", ".", ".", ".", ".", ".",
".", "#", ".", ".", ".", ".", ".", ".", ".",
".", ".", ".", ".", ".", ".", ".", ".", ".",
".", ".", "#", "L", ".", ".", ".", ".", "#",
".", ".", ".", ".", "#", ".", ".", ".", ".",
".", ".", ".", ".", ".", ".", ".", ".", ".",
"#", ".", ".", ".", ".", ".", ".", ".", ".",
".", ".", ".", "#", ".", ".", ".", ".", "."
), nrow = 9, ncol = 9, byrow = TRUE)
print(getAdjacentBySight(5, 4, testMatrixB))

testMatrixC <- matrix(data = c(
".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".",
".", "A", ".", "L", ".", "#", ".", "#", ".", "#", ".", "#", ".",
".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."
), nrow = 3, ncol = 13, byrow = TRUE)

print(getAdjacentBySight(2, 2, testMatrixC))
