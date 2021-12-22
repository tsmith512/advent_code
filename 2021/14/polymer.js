#!/usr/bin/env node

/**
 *  ___              _ _ _
 * |   \ __ _ _  _  / | | |
 * | |) / _` | || | | |_  _|
 * |___/\__,_|\_, | |_| |_|
 *            |__/
 *
 * "Extended Polymerization"
 */

const fs = require('fs');

const [start, rules] = fs.readFileSync('input.txt').toString().trim().split('\n\n');

// Let's make a map of
// { StartLetter: { EndLetter: 'InsertHereLetter' , ... }, ... }
const ruleset = {};
rules.split('\n').forEach(str => {
  const [_, start, end, insert] = str.match(/^(\w)(\w) -> (\w)/);
  if (!ruleset.hasOwnProperty(start)) {
    ruleset[start] = {};
  }
  ruleset[start][end] = insert;
});

/**
 * Take the polymer chain string and apply the rules to extend it.
 * @TODO: Right now this takes and returns a string. That may not be best...
 *
 * @param input (string) the polymer chain
 * @returns (string) the polymer chain text
 */
const extend = (input) => input.split('').reduce((chain, next) => {
  // Is this the first one?
  if (!chain.length) {
    chain.push(next);
    return chain;
  }

  // Is there an insertion rule for the last of chain and this character?
  if (ruleset?.[chain.at(-1)]?.[next]) {
    chain.push(ruleset[chain.at(-1)][next]);
  }

  chain.push(next);
  return chain;
}, []).join('');

/**
 * Take a polymer chain and count and sort the elements in it. Returns an entries
 * array that is ordered least to most freqeuently.
 *
 * @param input (string) the polymer chain
 * @returns (array) [ ['EL', count], ... ]
 */
const count = (input) => Object.entries(
  input.split('')
  .reduce((counts, next) => {
    counts[next] = counts[next] + 1 || 1;
    return counts;
  }, {})
).sort((a, b) => a[1] - b[1]);

//
// MAIN:
//
let chain = start;
const steps = 10;
for (let i = 0; i < steps; i++) {
  chain = extend(chain);
}

const counts = count(chain);

console.log(`After ${steps} steps, the total length is ${chain.length}.
  ${counts[0][0]} was used ${counts[0][1]} times.
  ${counts.at(-1)[0]} was used ${counts.at(-1)[1]} times.
  Difference: ${counts.at(-1)[1] - counts[0][1]}`);

// Part One:
// After 10 steps, the total length is 19457.
//   N was used 613 times.
//   O was used 4857 times.
//   Difference: 4244

/**
 *  ___          _     ___
 * | _ \__ _ _ _| |_  |_  )
 * |  _/ _` | '_|  _|  / /
 * |_| \__,_|_|  \__| /___|
 *
 * Do it again, steps = 40.
 */

// Okay fine, we track counts of pairs instead of the whole chain.
const pairs = {};

// Put the start string into our object of pairs.
for (let i = 0; i < start.length - 1; i++) {
  const pair = start[i] + start[i + 1];
  pairs[pair] = pairs[pair] + 1 || 1;
}

// And count the effect of extending it `steps` times
const part2Steps = 40;
for (let i = 0; i < part2Steps; i++) {
  // Make an object to record what we're going to do so that we can make that
  // happen after we've iterated over all the pairs.
  const adjustments = {};

  for (pair in pairs) {
    const count = pairs[pair];

    // Split the sandwich and get the meat from the ruleset object above.
    const [a, b] = pair.split('');
    const A = a + ruleset[a][b];
    const B =     ruleset[a][b] + b;

    // We need to add the count of old-pairs to new-pairs
    adjustments[A] = (adjustments[A]) ? adjustments[A] + count : count;
    adjustments[B] = (adjustments[B]) ? adjustments[B] + count : count;

    // Old pairs will be reduced by the same count.
    adjustments[pair] = (adjustments[pair]) ? adjustments[pair] - count : 0 - count;
  }

  for (pair in adjustments) {
    const count = adjustments[pair];

    if (pairs.hasOwnProperty(pair)) {
      pairs[pair] += count;
    } else {
      pairs[pair] = count;
    }

    if (pairs[pair] < 1) {
      delete pairs[pair];
    }
  }
}

// Count up all the letters. (So BC:5 --> B: 5, C: 5, ...)
const totals = {};
for (pair in pairs) {
  const count = pairs[pair];

  pair.split('').forEach((el) => {
    if (totals.hasOwnProperty(el)) {
      totals[el] += count;
    } else {
      totals[el] = count;
    }
  });
}

// The first and last letters of the original string won't be part of the count,
// so add one for each.
totals[start[0]] += 1;
totals[start.split('').at(-1)] += 1;

// Now every letter is double-counted, split it.
for (el in totals) {
  totals[el] /= 2;
}

// Drop into an array and sort.
const summary = Object.entries(totals).sort((a, b) => a[1] - b[1]);

console.log(`After ${part2Steps} steps,
  ${summary[0][0]} was used ${summary[0][1]} times.
  ${summary.at(-1)[0]} was used ${summary.at(-1)[1]} times.
  Difference: ${summary.at(-1)[1] - summary[0][1]}`);

// Part Two:
// After 40 steps,
//   H was used 712042793487 times.
//   O was used 5519099747353 times.
//   Difference: 4807056953866
