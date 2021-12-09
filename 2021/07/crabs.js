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
 *
 * ... this will be a median of the set, right?
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

/**
 *  ___          _     ___
 * | _ \__ _ _ _| |_  |_  )
 * |  _/ _` | '_|  _|  / /
 * |_| \__,_|_|  \__| /___|
 *
 * Fuel cost = 1 additional unit per position shifted. So a move of 1 = 1 fuel,
 * but a move of 5 = 15 fuel. Same question; which position would result in the
 * lowest fuel usage, and how much would that fuel usage be?
 *
 * So fuel = factorial(distance) ... but with addition not multiplication?
 *
 * Wikipedia calls that a "triangular number" which it defines as
 *
 * n (n + 1)
 * ---------
 *    2
 *
 * and that matches the example. And instead of shooting for the median (fewer
 * total moves), we should hit the average (fewer moves of magnitude).
 */

const triangularNumber = (n) => (n * (n + 1)) / 2;

const calcPremiumRelocationFuel = (pos, arr) => {
  // Figure out how far each crab has to go
  const distances = arr.map(crab => (crab > pos) ? crab - pos : pos - crab);

  const fuel = distances.map(dist => triangularNumber(dist));

  // Sum and return
  return fuel.reduce((a, n) => a + n);
}

// @TODO: With Math.round, the position for my input was 471.6 --> 472. And that
// wasn't the right answer. But when calculating fuel to Math.floor(471.6): 471,
// I got the right answer. Would that work for any input? Is the right answer to
// "calc fuel usage for both positions and pick the lowest if it's not even?"
const position = Math.floor(avg(crabs));

console.log(`Average of crab positions (rounded): ${position}`);
console.log(`Total high-octane relocation fuel: ${calcPremiumRelocationFuel(position, crabs)}`);

// Part Two:
// Average of crab positions (rounded): 471
// Total high-octane relocation fuel: 95476244
