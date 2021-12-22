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
  // Make a copy for the iteration so we know where we were before we started
  // this round of extending the chain.
  const temp = Object.assign({}, pairs);

  // For every pair in the list:
  for (pair in temp) {
    // What is the count at _now_? (... that may be the wrong approach)
    const count = pairs[pair];

    // Split the sandwich and get the meat from the ruleset object above.
    const [a, b] = pair.split('');
    const A = a + ruleset[a][b];
    const B =     ruleset[a][b] + b;
    console.log(`${pair}-- (was ${temp[pair]}). ${A}++ (was ${temp[A]}) and ${B}++ (was ${temp[B]})`);

    // Count for the new pairs will be old-count++ (or start it at 1)
    pairs[A] = (count) ? count + 1 : 1;
    pairs[B] = (count) ? count + 1 : 1;

    // Old pairs will be reduced by the same count.
    pairs[pair] -= count;

    // And expunged from the object if they're zeroed out.
    if (pairs[pair] < 1) {
      delete pairs[pair];
    }
    console.log(`${pair}-- (now ${pairs[pair]}). ${A}++ (now ${pairs[A]}) and ${B}++ (now ${pairs[B]})`);
  }
  console.log(Object.entries(pairs).sort());
};

console.log(start);
makeManifest(start);
console.log(Object.entries(pairs).sort());
extendManifest();
extendManifest();
