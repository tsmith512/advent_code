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
// {
//   StartLetter: {
//     EndLetter: 'InsertHereLetter'
//   }
// }

const ruleset = {};

rules.split('\n').forEach(str => {
  const [_, start, end, insert] = str.match(/^(\w)(\w) -> (\w)/);
  if (!ruleset.hasOwnProperty(start)) {
    ruleset[start] = {};
  }
  ruleset[start][end] = insert;
});

console.log(ruleset);
