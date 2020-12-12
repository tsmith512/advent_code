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
print(seats)

# UTILITY FUNCTIONS

# Figure out how many seats of a given type are in this area
countType <- function(matrix, type) {
  return(length(which(matrix == type)))
}

# Crop out a matrix of the neighbors for a given seat designation
getNeighbors <- function(row, col, matrix) {
  maxRow <- length(matrix[,1])
  maxCol <- length(matrix[1,])

  # Thankfully the 0,0 bounds are automatically "cropped," but figure max-bounds
  row2 <- if(row >= maxRow) maxRow else row + 1
  col2 <- if(col >= maxCol) maxCol else col + 1

  # Duplicate the matrix so we can clear out the queried seat
  new <- matrix[(row-1):row2, (col-1):col2]
  new[2,2] = "X"

  return(new)
}

sprintf("Floor area: %d", countType(seats, "."))
sprintf("Empty Seats: %d", countType(seats, "L"))
sprintf("Taken Seats: %d", countType(seats, "#"))

# These two work together:
print(              getNeighbors(2, 9, seats)          )
print(  countType(  getNeighbors(2, 9, seats)  , "L")  )

## THIS DID NOT WORK:
# testEdit <- function(seat) {
#   # Floor doesn't change.
#   if (seat ==".") return(".")
#   "X"
# }
# print(apply(seats, c(1,2), testEdit))
# Mostly because I couldn't figure out how to get the coordinates into the
# callback. Apply() seems to operate on an item's value without a way to relate
# it back to where it is in the matrix?

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

      # Don't mess up the floor.
      if (status == ".") {
        # No action.
      }
      else if (status == "L") {
        # An empty Seat
        if (countType(neighbors, "#") == 0) {
          after[row,col] = "#"
        }
      }
      else if (status == "#") {
        # Occupied Seat
        if (countType(neighbors, "#") >= 4) {
          after[row,col] = "L"
        }
      }
    }
  }
  after
}

print(seats)

print(iterateSeats(seats))
