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
    // list, looking for a contiguous set of numbers that sum to the suspicious
    // number. The set does not have a length limit.

    var suspiciousNumber: int = next;

    inputReader = inputFile.reader();
    inputReader.read(next);

    var buffer = new DistDeque(int, cap=-1);
    buffer.enqueue(next);

    // Running trackers. Currently [next] is our only value so it is all of them
    var highest: int = next;
    var lowest: int = next;
    var sum: int = next;

    while (sum != suspiciousNumber) {
      // Sum the queue:
      sum = + reduce buffer;

      // If we went over target, pop the first entry off and start over.
      if (sum > suspiciousNumber) {
        var (success, toss) = buffer.dequeue();
        if toss == lowest then lowest = -1;
        if toss == highest then highest = -1;
      }

      // Winning!
      else if (sum == suspiciousNumber) {
        writeln("Found target: ", suspiciousNumber);
        writeln("Highest: ", highest, " .. Lowest: ", lowest, " .. Sum: ", (highest + lowest));
        // Part Two solution:
        // Highest: 4241588 .. Lowest: 1212280 .. Sum: 5453868
        break;
      }

      // If we're short, pull in the next number and start over.
      else if (sum < suspiciousNumber) {
        if (inputReader.read(next)) {
          buffer.enqueue(next);
          if (next > highest) then highest = next;
          if (next < lowest || lowest == -1) then lowest = next;
        } else {
          writeln("ERROR: Uhh what happened we ran out of file");
          break;
        }
      }
    }
  }
}
