/**
 *  ___               __ ____
 * |   \ __ _ _  _   /  \__  |
 * | |) / _` | || | | () |/ /
 * |___/\__,_|\_, |  \__//_/
 *            |__/
 *
 * "The Treachery of Whales"
 *
 * Challenge:
 * Given many "crab submarines", each identified by their current position on a
 * one-dimensional field, determine which position on that field they could move
 * to which would result in the lowest overall fuel usage -- each unit traveled
 * results in 1 fuel unit consumed. Report the amount of fuel used.
 */

const fs = require('fs');

const input = fs.readFileSync('input.txt').toString().trim();

const crabs = input
  .split(',')
  .map(n => parseInt(n))
  .sort((a, b) => a - b);

const avg = (arr) => arr.reduce((a, n) => a + n, 0) / arr.length;

const median = (arr) => {
  if (arr.length % 2) {
    // Is odd-length
    return arr[Math.floor(arr.length / 2)];
  } else {
    // Is even-length
    return avg([arr[(arr.length / 2) - 1], arr[(arr.length / 2)]]);
  }
}

const calcRelocationFuel = (pos, arr) => {
  // Figure out how far each crab has to go
  const usage = arr.map(crab => (crab > pos) ? crab - pos : pos - crab);

  // Sum and return
  return usage.reduce((a, n) => a + n);
}

console.log(`Median of crab positions: ${median(crabs)}`);
console.log(`Total relocation fuel: ${calcRelocationFuel(median(crabs), crabs)}`);

// Part One:
// Median of crab positions: 328
// Total relocation fuel: 339321
