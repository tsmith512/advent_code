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



lines <- scan("seating_sample.txt", what = "")
rows <- length(lines)
cols <- length(unlist(strsplit(lines[1], "")))

seats <- matrix(data = unlist(strsplit(lines, "")), nrow = rows, ncol = cols, byrow = TRUE)
print(seats)

countType <- function(matrix, type) {
  return(length(which(matrix == type)))
}

getNeighbors <- function(x, y, matrix) {
  maxW <- length(matrix[1,])
  maxH <- length(matrix[,1])
  # Thankfully the 0,0 bounds are automatically "cropped," but figure max-bounds
  x2 <- if(x >= maxW) maxW else x + 1
  y2 <- if(y >= maxH) maxH else x + 1
  return(matrix[(x-1):x2, (y-1):y2])
}

sprintf("Floor area: %d", countType(seats, "."))
sprintf("Empty Seats: %d", countType(seats, "L"))
sprintf("Taken Seats: %d", countType(seats, "#"))

print(getNeighbors(2, 2, seats))
