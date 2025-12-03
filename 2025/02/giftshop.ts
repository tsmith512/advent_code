//  ___               __ ___
// |   \ __ _ _  _   /  \_  )
// | |) / _` | || | | () / /
// |___/\__,_|\_, |  \__/___|
//            |__/
//
// "Gift Shop"
//
// (On Node v20+ you can just run `npx tsx giftship.ts` to execute)
//
// Given a list of ranges /(\d+-\d+,)+/ (one long line), find "invalid" IDs:
// range boundaries where a number/sequence is repeated twice. (As the whole
// number-string?)
//
// > So, 55 (5 twice), 6464 (64 twice), and 123123 (123 twice) would all be invalid IDs.
//
// "None of the ranges have leading zeroes" (so... may need to strip out?)

import fs from 'fs';

const DEBUG = true;
const INPUT = 'sample.txt';

const debugPrint = (input: any) => {
  if (DEBUG) {
    console.log(input);
  }
};

/**
 * An invalid ID is a repeated sequence of digits, so split the string in half
 * and compare. This also filters out (as valid) odd-length strings silently.
 *
 * This is part one.
 *
 * @param i (string) ID to check, as a string
 * @returns (boolean) True if the ID is "invalid."
 */
const isInvalid = (i: string): boolean => i.slice(0, i.length / 2) === i.slice(i.length / 2);

/**
 * Split a string into X-length pieces
 *
 * @param input (string) Input string to split
 * @param n (number) How long the pieces should be
 * @returns (string[] | false) Array of string pieces, or false if input length not divisble by n
 */
const stringSplit = (input: string, n: number): false | string[] => {
  if (input.length % n) {
    return false;
  }

  return Array.from({ length: input.length / n }, (_, i) => input.slice(
    // Where to start
    n * i,
    // Where to stop
    n * (i + 1)
  ));
};

/**
 * An invalid ID is made of a repeated sequence of digits of any length.
 * Example: 123123 or 1212 or 111 all invalid.
 *
 * This is part two.
 *
 * @param input (string) ID to check, as a string
 * @returns (boolean) True if the ID is "invalid" per Part 2 rules
 */
const isSuperInvalid = (input: string): boolean => {
  // Split the string into pieces of i length, up to half the length of the string
  for (let i = 1; i <= input.length / 2; i++) {
    const pieces = stringSplit(input, i);

    // String length isn't a multiple of piece length; move on
    if (!pieces) {
      continue;
    }

    // Do we have a repeating sequence? If so, bail out and return true:
    // this ID is "invalid."
    if (pieces.every((piece) => piece === pieces[0])) {
      debugPrint(`In ${input} there is a repeated sequence of ${pieces[0]}`);
      return true;
    }
  }
}

//
// MAIN:
//

// Read ranges in from the input file: ["START-END", ...]
const ranges = fs.readFileSync(INPUT)
  .toString()
  .trim()
  .split(",");


// Isolate the invalid ranges:
const invalid = ranges
  // Expand ranges into the included numbers
  .map(r => {
    const [a, b] = r.split('-').map(i => parseInt(i));
    return Array.from({ length: b - a + 1}, (_, i) => a + i);
  })
  // Flatten nested array to check them all
  .flat()
  // Convert them back to strings, which also would remove leading zeroes
  .map(x => x.toString())
  // Filter to keep only invalid strings.
  // isInvalid() is part 1. isSuperInvalid() is part two.
  .filter(i => isSuperInvalid(i));

debugPrint(invalid);
const sum = invalid.reduce((total: number, current: string) => total + parseInt(current), 0);

// Part One:
// In provided ranges, there are 757 invalid IDs.
// The sum of invalid IDs is: 64215794229
console.log(`In provided ranges, there are ${invalid.length} invalid IDs.`);
console.log(`The sum of invalid IDs is: ${sum}`);
