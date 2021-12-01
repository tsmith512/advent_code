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

const count = depths.reduce(
  (count, reading, index) => count + ((reading > depths[index - 1]) ? 1 : 0), 0);

console.log(`Of those, ${count} readings increased over the previous value.`);

// Part One:
// There are 2000 readings total.
// Of those, 1711 readings increased over the previous value.
