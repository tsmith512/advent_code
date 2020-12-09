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

  var inputFilename: string = "encoded_sample.txt";
  var windowLength: int = 5;
  var sequence: [0..windowLength - 1] int;

  proc checkValidLine(value: int, position: int): bool {
    if (position > 15) {
      return false;
    }

    writeln("Checking line ", position, " with a value of ", value);
    return true;
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

    // What do we have so far?
    writeln("Preamble values: ", sequence);

    var next: int;
    while (inputReader.read(next)) {
      checkValidLine(next, position);
      position += 1;
    }
  }
}
