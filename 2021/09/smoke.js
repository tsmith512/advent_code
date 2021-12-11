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

const input = fs.readFileSync('input.txt').toString().trim();

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
  console.log(matrix.map(row => row.join(' ')).join('\n'))
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
    const nsew = [section[0][1], section[1][0], section[1][2], section[2][1]].filter(n => n !== false)

    // If this point value is lower than everything else, record it
    if (isLowest(value, nsew)) {
      lowPoints.push(value);
    }
  }
}

// Risk level is a point's value plus one. Part one wants a sum of these.
const riskLevels = lowPoints.map(n => n + 1).reduce((total, n) => total + n, 0);
console.log(`Sum of risk levels is: ${riskLevels}`);

// Part One:
// Sum of risk levels is: 491
