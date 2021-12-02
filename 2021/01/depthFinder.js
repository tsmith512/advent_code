#!/usr/bin/env node

/**
 *  ___               __  _
 * |   \ __ _ _  _   /  \/ |
 * | |) / _` | || | | () | |
 * |___/\__,_|\_, |  \__/|_|
 *            |__/
 *
 * "Sonar Sweep"
 *
 * Challenge;
 * Given a list of numbers, count those which are higher than their predecessor.
 */

const fs = require('fs');

const depths = fs.readFileSync('part1_input.txt')
  .toString()
  .trim()
  .split("\n")
  .map(string => parseInt(string));

console.log(`There are ${depths.length} readings total.`)

const countIncreases = (input) => input.reduce(
  (count, current, index) => count + ((current > input[index - 1]) ? 1 : 0), 0);

const count = countIncreases(depths);

console.log(`Of those, ${count} readings increased over the previous value.`);

// Part One:
// There are 2000 readings total.
// Of those, 1711 readings increased over the previous value.

/**
 *  ___          _     ___
 * | _ \__ _ _ _| |_  |_  )
 * |  _/ _` | '_|  _|  / /
 * |_| \__,_|_|  \__| /___|
 *
 * Repeat the process but look for increases in the sum of three-measurement
 * windows: "the number of times the sum of measurements in this sliding window
 * increases from the previous sum"
 */

// Make a "window of 3" from the given index. Empty if we're out of numbers.
// That's an okay assumption because we're looking for increases.
const window = (n) => depths.length > (n + 2) ? depths.slice(n, n + 3) : [];

// Sum values in an array
const sum = (arr) => arr.reduce((sum, x) => sum + x, 0);

// Build an array of 3-reading window totals
const readings = depths.map((val, ind) => sum(window(ind)));

const count2 = countIncreases(readings);

console.log(`And over windows of three readings, ${count2} increased from the window prior.`);

// Part Two:
// And over windows of three readings, 1743 increased from the window prior.
