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

const depths = [
  199,
  200,
  208,
  210,
  200,
  207,
  240,
  269,
  260,
  263,
];

console.log(`There are ${depths.length} readings total.`)

const count = depths.reduce(
  (count, reading, index) => count + ((reading > depths[index - 1]) ? 1 : 0), 0);

console.log(`Of those, ${count} readings increased over the previous value.`);
