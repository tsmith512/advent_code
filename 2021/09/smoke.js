#!/usr/bin/env node

/*
 *  ___               __  ___
 * |   \ __ _ _  _   /  \/ _ \
 * | |) / _` | || | | () \_, /
 * |___/\__,_|\_, |  \__/ /_/
 *            |__/
 *
 * "Smoke Basin"
 *
 * Challenge:
 * Given a field of numbers, find points which are lower than their surroundings.
 * "Adjacent" points are U/D/L/R, not on the diagonal. ($1 says Part Two will
 * change that...) Locate the low points, and sum (point + 1).
 */

const fs = require('fs');

const input = fs.readFileSync('sample.txt').toString().trim();

// Define the field as it was presented
const field = input
  .split('\n')
  .map(row => row.split('').map(col => parseInt(col)));

// Now surround it with `false` on all edges. This means the real data start at
// [1,1] and we can safely do a 3x3 query anywhere on the field.
const bufferRow = Array(field[0].length - 2).fill(false);
field.unshift(bufferRow);
field.push(bufferRow);
field.forEach(row => {
  row.unshift(false);
  row.push(false);
});

/**
 * Given a matrix, output it to console formatted (ish)
 */
const showField = (matrix) => {
  console.log(matrix.map(row => {
    const hideBooleans = row
      .map(n => (n === false) ? '.' : n)
      .map(n => (n === true) ? '#' : n);
    return hideBooleans.join(' ');
  }).join('\n') + '\n');
};

/**
 * Make arrays of indexes to iterate over that match the size of a given matrix.
 * Each dimension starts at 1 and counts out to the edge of the numbers (before
 * the buffer of falses).
 */
const getDimensions = (matrix) => {
  const w = [...Array(matrix[0].length - 1).keys()];
  const h = [...Array(matrix.length - 1).keys()];

  w.shift();
  h.shift();

  return [w, h];
}

/**
 * Given an input matrix and set of coordinates, return a 3x3 matrix around that
 * original address.
 */
const submatrix = (matrix, x, y) => {
  const rows = matrix.slice(y - 1, y + 2);
  const sub = rows.map(row => row.slice(x - 1, x + 2));

  return sub;
}

/**
 * Given a needle, check to see if it is lower than all elements in haystack.
 */
const isLowest = (needle, haystack) => {
  const checks = haystack.map(n => needle < n);
  return !checks.includes(false);
}

// MAIN:
const [width, height] = getDimensions(field);
const lowPoints = [];

for (row of height) {
  for (col of width) {
    const value = field[row][col];
    const section = submatrix(field, col, row);

    // I had plans for a cute little unspiral, but diagonals are ignored, so:
    const nsew = [section[0][1], section[1][0], section[1][2], section[2][1]].filter(n => n !== false);

    // If this point value is lower than everything else, record it
    if (isLowest(value, nsew)) {
      lowPoints.push(value);
    }
  }
}

showField(field);

// Risk level is a point's value plus one. Part one wants a sum of these.
const riskLevels = lowPoints.map(n => n + 1).reduce((total, n) => total + n, 0);
console.log(`Sum of risk levels is: ${riskLevels}`);

// Part One:
// Sum of risk levels is: 491


/**
 *  ___          _     ___
 * | _ \__ _ _ _| |_  |_  )
 * |  _/ _` | '_|  _|  / /
 * |_| \__,_|_|  \__| /___|
 *
 * Figure out the area of the basin around these low points. Points of height 9
 * represent ridges that aren't in a basin. Otherwise every point eventually is
 * part of a basin when traversing out far enough.
 *
 * Calculate the product of basin areas.
 */

// Numbers don't matter: borders and ridgelines are false, basin volume is true.
const basinField = field.map(row => row.map(n => (n === 9 || n === false) ? false : true));
let basinNumber = 0;

/**
 * As we map basins, we need a way to "link" them, this replaces all addresses A
 * with B in the map globally.
 */
const rewriteBasins = (a, b) => {
  for (r of height) {
    for (c of width) {
      const value = basinField[r][c];

      if (value === a) {
        basinField[r][c] = b;
      }
    }
  }
}

// Iterate over the new T/F field and start identifying basin systems and setting
// the point value to the address. Result: a field where point values are not
// heights, but the basin number that point drains into.
for (row of height) {
  for (col of width) {
    const value = basinField[row][col];

    // It's a basin but we haven't figured out which system it's part of.
    if (value === true) {
      // What identified basins are around this point?
      const section = submatrix(basinField, col, row);
      const nsew = [section[0][1], section[1][0], section[1][2], section[2][1]]
        .filter(x => typeof x == 'number');

      // Dedupe that. Result: 1 basin this point is part of, or 2 basins this
      // point links together.
      const nearby = nsew.reduce((basins, current) => {
        if (!basins.includes(current)) {
          basins.push(current);
        }
        return basins;
      }, []);

      if (nearby.length === 0) {
        // If nearby is empty, then we're between borders and ridgelines -> new.
        basinNumber += 1;
        basinField[row][col] = basinNumber;
      } else if (nearby.length === 1) {
        // If only one basin adjacent, then this point is part of that system.
        basinField[row][col] = nearby[0];
      } else if (nearby.length === 2) {
        // We are adjacent to two basins, which means this point links them.
        const [a, b] = nearby;
        rewriteBasins(a, b);
        basinField[row][col] = b;
      }
      // Because we're going top-left to bottom-right, we won't ever see 3+.
    }
  }
}

showField(basinField);

// Caution: doozie ahead.
const answer = basinField
  .flat()                               // Flatten the field into a 1-d array
  .filter(n => typeof n === 'number')   // Drop the booleans
  .reduce((counts, address) => {        // Count distinct basin numbers
    counts[address] += 1;
    return counts
  }, Array(basinNumber + 1).fill(0))
  .filter(n => n > 0)                   // Remove the zeroes
  .sort((a, b) => b - a)                // Sort biggest-basin-first
  .slice(0, 3)                          // Take the largest three
  .reduce((product, current) => product * current, 1); // Multiply

console.log(`The product of the three largest basins is ${answer}`);
