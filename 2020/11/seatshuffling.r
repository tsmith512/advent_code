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
iterateSeats <- function(before, part = 1) {
  # I couldn't figure out how to do this "simultaneously" so I'm reading from
  # Before and writing to / returning After.
  after <- before
  maxRow <- length(before[,1])
  maxCol <- length(before[1,])
  for (row in 1:maxRow) {
    for (col in 1:maxCol) {
      status <- before[row,col]
      neighbors <- if(part == 1) getNeighbors(row, col, before) else getAdjacentBySight(row, col, before)

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
        # The rule is +4 adjacent seats, but our count will also include the
        # current seat, so we need to check for 5+ (6+ in part 2)
        limit <- if(part == 1) 5 else 6
        if (countType(neighbors, "#") >= limit) {
          after[row,col] = "L"
        }
      }
    }
  }
  after
}

runTest <- function(seats, puzzlePart) {
  # Determine seat stats for the initial seatmap
  beforeStats <- seatReport(seats)
  afterStats <- seatReport(list())
  i <- 0

  while (! all(beforeStats == afterStats) ) {
    i <- i + 1

    beforeStats <- afterStats
    seats <- iterateSeats(seats, puzzlePart)
    afterStats <- seatReport(seats)

    cat(sprintf("\n\nIteration %d\n", i))
    print(afterStats)
  }
}

# runTest(seats, 1)
# Part One solution:
#   Iteration 134
#   floor empty taken
#    1425  4914  2211

cat("\n\n\n\n\n")

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

  # Weird stuff happens trying to pull ranges at edges, get ready to catch
  edgeR <- if (row == 1 || row == maxRow) TRUE else FALSE
  edgeC <- if (col == 1 || col == maxCol) TRUE else FALSE

  # Go around the clock, take [ORIGIN:DESTINATION] and get the first non-floor
  # value from it (or floor, if that's all there is)
  for (r in 1:3) {
    print(c("Row options", 1, row, maxRow))
    destR <- c(1, row, maxRow)[r]
    print(c("Selected", destR))

    for (c in 1:3) {
      print(c("Column options", 1, col, maxCol))
      destC <- c(1, col, maxCol)[c]
      print(c("Selected", destC))

      # This is the seat we're looking _from_
      if (r == 2 && c == 2) {
        seen[r, c] <- "X"
        next
      }

      # If we're trying to look past the far edge
      if (col == maxCol && c == 3) {
        seen[r, c] <- "EC"
        next
      }

      if (row == maxRow && r == 3) {
        seen[r, c] <- "ER"
        next
      }

      # If we're looking across both axes, we need a diag()
      print(c("Mode", r, c))

      if (row == destR || col == destC) {
        line <- matrix[row:destR, col:destC]
        print(c("Line from", "row", row, ">", destR, ", col", col, ">", destC, "The line is:", line))
      }
      else {
        line <- diag(matrix[row:destR, col:destC])
        print(c("Diagonal from", "row", row, ">", destR, ", col", col, ">", destC, "The line is:", line))
      }

      print(c("We saw a ", getFirstSeatSeen(line)))

      # Save the first seat we see in the given direction
      seen[r, c] <- getFirstSeatSeen(line)
    }
  }
  print(c("Sightlines from", row, col))
  print(seen)
  seen
}

getFirstSeatSeen <- function(line) {
  status <- "Z"

  # If we're on an edge, there may not be a line here, just return what we have
  # @TODO: That might mess up the counting... should we return NULL? We didn't
  # "see" anything
  if (length(line) == 1) return ("E")

  # From my seat, look for the first non-floor that isn't me
  for (value in line[-1]) {
    status <- value
    if(value != ".") break
  }

  status
}


# Determine seat stats for the initial seatmap
beforeStats <- seatReport(seats)
afterStats <- seatReport(list())
i <- 0

while (i < 1) {
  i <- i + 1

  beforeStats <- afterStats
  seats <- iterateSeats(seats, 2)
  afterStats <- seatReport(seats)

  cat(sprintf("\n\nIteration %d\n", i))
  print(seats)
  print(afterStats)
}
# runTest(seats, 2)
