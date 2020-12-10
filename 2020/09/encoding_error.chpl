//   ___               __  ___
//  |   \ __ _ _  _   /  \/ _ \
//  | |) / _` | || | | () \_, /
//  |___/\__,_|\_, |  \__/ /_/
//             |__/
//
//  "Encoding Error"
//
//  Challenge:
//  Given a list of numbers, treating the first 25 (5 for the sample) as a
//  "preamble," every subsequent number SHOULD BE the sum of at least one pair of
//  different numbers from the preceding 25 (5). Find the first number from the
//  list that is not the sum of two different numbers in the set before it.

prototype module decoder {
  use IO;
  use DistributedDeque;

  config var inputFilename: string = "encoded_sample.txt";
  config var windowLength: int = 5;
  var sequence: [0..windowLength - 1] int;

  // Given a value (the next line in the file), search for a pair of numbers
  // that are not the same which add to the given value.
  proc checkValidLine(value: int): bool {
    for x in sequence {
      label inner for y in sequence {
        if x == y then continue inner;
        if value == x + y then return true;
      }
    }
    return false;
  }

  proc main() {
    // Open the file and get a reader
    var inputFile = open(inputFilename, iomode.r);
    var inputReader = inputFile.reader();

    // Position trackers
    var position: int = 0; // Line number of the file, not the sequence array

    // Populate the buffer with the "preamble"
    while (position < windowLength) {
      inputReader.read(sequence[position]);
      position += 1;
    }

    // We'll read the "next line" into next to check it before adding it to the
    // sequence buffer for subsequent line validation.
    var next: int;

    while (inputReader.read(next)) {
      if (checkValidLine(next)) {
        sequence[position % windowLength] = next;
        position += 1;
      }
      else {
        writeln("Line validation failed at ", position, ". ", next, " not found as a sum of any pair in the buffer.");
        // Part One solution:
        // Line validation failed at 509. 31161678 not found as a sum of any pair in the buffer.
        break;
      }
    }

    inputReader.close();

    //  ___          _     ___
    // | _ \__ _ _ _| |_  |_  )
    // |  _/ _` | '_|  _|  / /
    // |_| \__,_|_|  \__| /___|
    //
    // We need to take the suspicious number determined from above and seek the
    // list, looking for a contiguous set of numbers that sum to the suspicipos
    // number. The set does not have a length limit.
    //
    // English:
    // - Reset file position
    // - Start at index 0
    // - While we don't have a working set
    //   - While sum < suspicious
    //     - sum index 0..
    //   - starting index++
    var suspiciousNumber: int = next;
    var startingIndex: int = 0;
    var startingValue: int = 0;
    var found: bool = false;
    var sum: int = 0;
    var endingValue: int = 0;
    next = 0;

    label outer while (!found) {
      // Start over from zero. CLosed/reopened the inputReader because I
      // couldn't get past an error about seeing a locking channel...
      var inputReader = inputFile.reader();
      var deque = new DistDeque(int, cap=-1);
      position = 0;
      startingValue = 0;
      sum = 0;

      // Even if I could get seek working, it seeks by bytes, not lines.
      // "Waste" reads until we get to the start of the range.
      if (startingIndex > 0) {
        for i in 1..startingIndex {
          inputReader.read(next);
          sum = next;
          position += 1;
        }

        deque.enqueue(next);
      }

      if (next > suspiciousNumber) {
        writeln("Error: Starting at position [", startingIndex, "] -> ", next, " is greater than target ", suspiciousNumber);
        break outer;
      }

      writeln("Starting at index [", position, "] ", next);
      while (sum < suspiciousNumber) {
        if (inputReader.read(next)) {
          writeln("Adding ", sum, " + ", next);
          sum += next;
          position += 1;
          deque.enqueue(next);
        }

        if (sum == suspiciousNumber) {
          writeln("Solution: Added lines ", startingIndex, "..", position, " => ", startingValue, " + ... + ", endingValue, " = ", sum);
          found = true;
          var highest: int;
          var lowest: int = 100000000000000000;
          for val in deque.these(Ordering.FIFO) {
            writeln(val);
            if (val > highest) then highest = val;
            if (val < lowest) then lowest = val;
          }
          writeln("Highest: ", highest, " .. Lowest: ", lowest, " .. Sum: ", (highest + lowest));
          break outer;
        }

      }
      writeln("Failed: Added lines ", startingIndex, "..", position, " => ", sum);
      startingIndex += 1;
      inputReader.close();
    }
  }
}
