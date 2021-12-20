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
