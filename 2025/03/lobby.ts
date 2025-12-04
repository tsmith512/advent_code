/**
 *  ___               __ ____
 * |   \ __ _ _  _   /  \__ /
 * | |) / _` | || | | () |_ \
 * |___/\__,_|\_, |  \__/___/
 *            |__/
 *
 * "Lobby"
 *
 * Given a list of numbers (ex: `818181911112111`), find the highest two-digit
 * number that can be made from the available digits in the given order (ex: 92).
 * Provide the sum of those two-digit numbers.
 *
 * Part two: instead of 2, output sets are 12 digits.
 */

import fs from 'fs';

const DEBUG = true;
const INPUT = 'input.txt';

const debugPrint = (input: any) => {
  if (DEBUG) {
    console.log(input);
  }
};


const max = (a: number, b: number) => (a > b) ? a : b;

const sum = (i: number[]) => i.reduce((total, next) => total + next, 0);

/**
 * Get the two highest numbers from the battery bank string, in order.
 *
 * This is part 1.
 *
 * @param input (string) The battery bank, a string of numbers. Ex: 818181911112111
 * @returns (number[]) The two highest ordered digits. Ex: 89
 */
const highPair = (input: string): number[] => input.split('').reduce(
  (
    set: number[],
    current: string,
    i: number
  ) => {
    // Add the next number to the array
    set.push(parseInt(current));

    // We need two numbers, so if we're short, keep what we have.
    if (set.length < 3) { return set; }

    // @TODO: Is there a smarter way to write this?
    else if (set[0] < set[1]) { return [        max(set[0], set[1]), set[2]] }
    else                      { return [set[0], max(set[1], set[2])] }
  }, []);


/**
 * Get X highest numbers from the battery bank string, in order.
 *
 * This is part two.
 *
 * @param input (string) The battery bank, a string of numbers. Ex: 818181911112111
 * @param length (number) How many digits to collect (Ex: 3)
 * @returns (number[]) The two highest ordered digits. Ex: 892
 */
const highSet = (input: string, length: number): number[] => input.split('').reduce(
  (
    set: number[],
    current: string,
    i: number
  ) => {
    // Add the next number to the array
    set.push(parseInt(current));

    // If we're short, keep what we have
    if (set.length <= length) { return set; }

    // Scan through the numbers we've collected so far in pairs...
    for (let i = 1; i < set.length; i++) {
      // ...find a pair where A < B...
      if (set[i - 1] < set[i]) {
        // ... and remove A.
        set.splice(i - 1, 1);
        // If we do this multiple times, we'll come up short, so stop here.
        break;
      }
    }

    // Return the first LEN items (if they're all in descending order, we'll have one too many)
    return set.slice(0, length);
  }, []);

//
// MAIN:
//

// Read ranges in from the input file: ["START-END", ...]
const banks = fs.readFileSync(INPUT)
  .toString()
  .trim()
  .split('\n');

const batteryPairs = banks
  // Isolate the two highest numbers in order
  .map(l => highPair(l))
  // Make it a single number
  .map(p => (p[0] * 10) + p[1])


debugPrint(`Pairs: ${batteryPairs.join(', ')}`);

// Part One:
// Sum of battery pairs: 17144
console.log(`Sum of battery pairs: ${sum(batteryPairs)}`);

//
// PART TWO:
//
const batterySets = banks
  // Isolate the two highest numbers in order
  .map(l => highSet(l, 12))
  // Make it a single number
  .map(s => s.reduce((total, current, index) => total + (current * 10 ** (s.length - index - 1)), 0))

debugPrint(`Sets: \n  ${batterySets.join('\n  ')}`);

// Part Two:
// Sum of battery sets: 170371185255900
console.log(`Sum of battery sets: ${sum(batterySets)}`);
