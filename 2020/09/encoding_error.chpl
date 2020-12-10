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
    // Init and add index 0 to the queue.
    // While we have no answer:
    // - Sum the queue. Reset/Track highest and lowest. If we hit the target, break.
    //   - If we run out of lines in the queue and:
    //     - The sum isn't high enough, read a line from file into the queue, position++, try again
    //   - If we exceed the target:
    //     - Pop the first element ouf of the queue, try again
    // - Report highest + lowest.
    var suspiciousNumber: int = next;
    var sum: int = 0;
    inputReader = inputFile.reader();
    var deque = new DistDeque(int, cap=-1);
    next = 0;

    inputReader.read(next);
    deque.enqueue(next);

    label outer while (sum != suspiciousNumber) {
      // Run the queue:
      sum = 0;
      var highest: int = -1;
      var lowest: int = -1;
      label queueSum for val in deque.these(Ordering.FIFO) {
        writeln(val);
        if (val > highest) then highest = val;
        if (val < lowest || lowest == -1) then lowest = val;
        sum += val;
        if (sum == suspiciousNumber) {
          writeln("Found target.");
          writeln("Highest: ", highest, " .. Lowest: ", lowest, " .. Sum: ", (highest + lowest));
          // Part Two solution:
          // Highest: 4241588 .. Lowest: 1212280 .. Sum: 5453868
          break outer;
        }
      }

      // We finished the queue.
      // If we went over target, pop the first entry off and start over.
      if (sum > suspiciousNumber) {
        deque.popFront();
      }

      // If we're short, pull in the next number and start over.
      else if (sum < suspiciousNumber) {
        if (inputReader.read(next)) {
          deque.enqueue(next);
        } else {
          writeln("Uhh what happened we ran out of file");
          break outer;
        }
      }

      // Only way to hit this is if we got a match but didn't see it before.
      else {
        writeln("Sum ", sum, " is target", suspiciousNumber, ", how did we lose track?");
        break outer;
      }
    }
  }
}
