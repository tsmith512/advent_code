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

  // proc checkValidLine(position: int): bool {
  //   var start: uint = position - windowLength;

  //   if (start < windowLength) {
  //     stderr.writeln("Cannot check validity of preamble entry at line ", position);
  //     exit(1);
  //   }
  // }

  proc main() {
    // Open the file and get a reader
    var inputFile = open(inputFilename, iomode.r);
    var inputReader = inputFile.reader();

    // Position trackers
    var position: int = 0;
    var line: int;

    // Populate the buffer with the "preamble"
    while (position < windowLength) {
      inputReader.read(sequence[position]);
      position += 1;
    }

    // What do we have so far?
    writeln("Preamble values: ", sequence);
  }
}
