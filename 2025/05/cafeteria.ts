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
debugPrint(ranges);

// Items: convert string to number
const items: number[] = inputItems.split('\n').map(n => parseInt(n));
debugPrint(items);

// Filter for items where the item ID is between any range's low and high points
const fresh = items.filter(i => ranges.some((r) => r[0] <= i && i <= r[1]));
debugPrint(fresh);

console.log(`There are ${fresh.length} fresh ingredients in the fridge.`);
