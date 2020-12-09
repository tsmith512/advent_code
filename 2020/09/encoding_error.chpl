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

use IO;

var preambleLen: int = 5;
var inputFile: file = open("encoded_sample.txt", iomode.r);

var inputReader: channel = inputFile.reader();
var line: string;

while (inputReader.read(line)) {
  writeln("Read line: ", line);
}
