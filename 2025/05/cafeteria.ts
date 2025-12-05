/**
 *  ___               __  ___
 * |   \ __ _ _  _   /  \| __|
 * | |) / _` | || | | () |__ \
 * |___/\__,_|\_, |  \__/|___/
 *            |__/
 *
 * "Cafeteria"
 *
 * Given an input in two sections: ranges and ingredient IDs, where ingredients
 * are "fresh" if they fall within of the provided any range (inclusive), count
 * how many ingredients are fresh?
 *
 * Part two: Count the total number of IDs that would be fresh across all ranges,
 * the example takes into account (and doesn't double-count) the overlap.
 */

import fs from 'fs';

const DEBUG = true;
const INPUT = 'sample.txt';

const debugPrint = (input: any) => {
  if (DEBUG) {
    console.log(input);
  }
};

// Read and split the file into two big text blobs:
const [inputRanges, inputItems] = fs.readFileSync(INPUT)
  .toString()
  .trim()
  .split('\n\n');

// Ranges: turn the "1-5" strings into an array of [1, 5] pairs
const ranges: number[][] = inputRanges.split('\n').map(l => l.split('-').map(n => parseInt(n)));

// Items: convert string to number
const items: number[] = inputItems.split('\n').map(n => parseInt(n));

// Filter for items where the item ID is between any range's low and high points
const fresh = items.filter(i => ranges.some((r) => r[0] <= i && i <= r[1]));

// Part One:
// There are 744 fresh ingredients in the fridge.
console.log(`There are ${fresh.length} fresh ingredients in the fridge.`);

// Sort the ranges
ranges.sort((a, b) => a[0] - b[0]);

// Just for kicks... how many total would we be talking about?
debugPrint(`Without accounting for overlaps, there are ${ranges
  .map(r => r[1] - r[0])
  .reduce((total, current) => total += current)} IDs here...`);
// oh. it's trillions.



/**
 * Combine two given ranges (number[min,max]) if they overlap, or return false
 * if they do not.
 *
 * @param a (number[]) Range with a lower start
 * @param b  (number[]) Range with an equal or higher start
 * @returns (number[]) Overlapping range, or false if they don't overlap
 */
const overlap = (a: number[], b: number[]): number[] | false => {
  // assume a and b will be in order:
  if (a[0] > b[0]) {
    throw(new Error("Out of order"))
  }

  // if B starts before A ends, combine them:
  if (a[1] >= b[0]) {
    return [a[0], Math.max(a[1], b[1])];
  }

  // May be more cases to grab but for now, skip
  return false;
};

// Show input ranges:
debugPrint(ranges);

console.log(`Initially, there were ${ranges.length} ranges of fresh IDs.`);
let replacement: number[] | false;

for (let i = 0; i < ranges.length - 2; i++) {
  try {
    // While "this" range overlaps with "next" range, remove next:
    while ((replacement = overlap(ranges[i], ranges[i+1])) !== false) {
      ranges[i][1] = replacement[1];
      ranges.splice(i+1, 1);
    }
  } catch (err) {
    // Because we removed things from the array after checking its length, we'll
    // end up pulling undefined values. That's when we know we can stop.
    break;
  }
  debugPrint(`Ranges: ${ranges.length}`);
}
console.log(`After consolidation, there are ${ranges.length} ranges of fresh IDs.`);

debugPrint(ranges);

// Now that we've consolidated ranges so they don't overlap:
debugPrint(`Reducing overlaps, there are ${ranges
  .map(r => (r[1] - r[0]) + 1)
  .reduce((total, current) => total += current)} IDs here.`);
