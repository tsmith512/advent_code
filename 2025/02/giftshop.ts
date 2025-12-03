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
const INPUT = 'input.txt';

const debugPrint = (input: any) => {
  if (DEBUG) {
    console.log(input);
  }
};

// An invalid ID is a repeated sequence of digits, so split the string in half
// and compare. This also filters out (as valid) odd-length strings silently.
const isInvalid = (i: string) => i.slice(0, i.length / 2) === i.slice(i.length / 2);

// Read the ranges into an array (str[])
const ranges = fs.readFileSync(INPUT)
  .toString()
  .trim()
  .split(",");

let invalidCount = 0;

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
  .filter(i => isInvalid(i));

debugPrint(invalid);
const sum = invalid.reduce((total: number, current: string) => total + parseInt(current), 0);

// Part One:
// In provided ranges, there are 757 invalid IDs.
// The sum of invalid IDs is: 64215794229
console.log(`In provided ranges, there are ${invalid.length} invalid IDs.`);
console.log(`The sum of invalid IDs is: ${sum}`);
