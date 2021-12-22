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

const [start, rules] = fs.readFileSync('sample.txt').toString().trim().split('\n\n');

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

/**
 * Break down the start string into component pairs.
 *
 * @param input (string) the starting place
 */
const makeManifest = (input) => {
  for (let i = 0; i < input.length - 1; i++) {
    const pair = input[i] + input[i + 1];
    pairs[pair] = pairs[pair] + 1 || 1;
  }
};

/**
 * Act on the global pairs object to split each key into the two result pairs:
 * Ex: for the rule "NN -> C" we subtract NN and add NC and CN.
 */
const extendManifest = () => {
  // Make an object to record what we're going to do so that we can make that
  // happen after we've iterated over all the pairs.
  const adjustments = {};

  // For every pair in the real list:
  for (pair in pairs) {
    // What is the count at the start of this round?
    const count = pairs[pair];

    // Split the sandwich and get the meat from the ruleset object above.
    const [a, b] = pair.split('');
    const A = a + ruleset[a][b];
    const B =     ruleset[a][b] + b;
    // console.log(`${pair}-- (was ${pairs[pair]}). ${A}++ (was ${pairs[A]}) and ${B}++ (was ${pairs[B]})`);

    // We need to add the count of old-pairs to new-pairs
    adjustments[A] = (adjustments[A]) ? adjustments[A] + count : count;
    adjustments[B] = (adjustments[B]) ? adjustments[B] + count : count;

    // Old pairs will be reduced by the same count.
    adjustments[pair] = (adjustments[pair]) ? adjustments[pair] - count : 0 - count;
  }

  // console.log('Adjustments: ', adjustments);

  // For every pair we know we need to adjust...
  for (pair in adjustments) {
    // ...by how much?
    const count = adjustments[pair];

    if (count == 0) {
      // We added as much as we subtracted, skip
      continue;
    }

    if (pairs.hasOwnProperty(pair)) {
      pairs[pair] += count;
    } else {
      pairs[pair] = count;
    }
    // console.log(`${pair} + ${count} --> now ${pairs[pair]}`);

    // And delete from the object if it is zeroed out.
    if (pairs[pair] < 1) {
      delete pairs[pair];
    }
  }
  // console.log(Object.entries(pairs).sort());
};

// Turn the original start string into our object of pairs.
makeManifest(start);

// And count the effect of extending it `steps` times
for (let i = 0; i < 10; i++) {
  extendManifest();
}

// console.log(pairs);


// We know each letter will be accounted for twice, except for the first and
// last pairs.
const totals = {};

// I don't know where I was going with this. Something about how the first or
// last letters (pairs?) aren't double-counted but everything else is.
const first = start.split('').at(0); // .slice(0,2).join(''); // @TODO: Do we just want the letter?
const last = start.split('').at(-1); // .slice(-2).join('');

// Count up all the letters. (So BC:5 --> B: 5, C: 5, ...)
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

totals[first] += 1;
totals[last] += 1;

// And this means every letter is double-counted.
for (el in totals) {
  totals[el] /= 2;
}

// And this _should be_ our totals per letter.
console.log(totals);

const summary = Object.entries(totals).sort((a, b) => a[1] - b[1]);

console.log(`After ${steps} steps, ${counts[0][0]} was used ${counts[0][1]} times.
  ${counts.at(-1)[0]} was used ${counts.at(-1)[1]} times.
  Difference: ${counts.at(-1)[1] - counts[0][1]}`);
