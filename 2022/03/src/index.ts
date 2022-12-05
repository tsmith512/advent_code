/**
 *  ___               __ ____
 * |   \ __ _ _  _   /  \__ /
 * | |) / _` | || | | () |_ \
 * |___/\__,_|\_, |  \__/___/
 *            |__/
 *
 * "Rucksack Reorganization"
 *
 * Given a list of strings, each string represents two halves of a rucksack and
 * the contents therein. First, determine which item is only in one half of each
 * string (only one compartment of the rucksack).
 *
 * Then, for "priority," where letters [a-z] => 1-26 and [A-Z] => 27-52, what is
 * the sum of the unique items.
 */

import * as fs from 'fs';
import { join } from 'path';
import chalk from 'chalk';

const FILENAME = 'sample.txt';

const rucksacks: string[] =
  fs.readFileSync(join(process.cwd(), `lib/${FILENAME}`), 'utf8')
  .trim()
  .split("\n");

/**
 * Figure out what item is "overpacked"
 *
 * @param sack (string) A string to split and inspect
 * @returns (string) What letter is present in both halves of the input
 */
const findUnique = (sack: string): string => {
  const first = sack.split('').slice(0, sack.length / 2);
  const second = sack.split('').slice(sack.length / 2);

  // There _should_ only be one letter from each set that also appears in the
  // other. Find the item that is shared between both halves, but look in both
  // and use a Set() to eliminate the duplicates.
  const uniques = [...new Set([
    ...first.filter(item => second.indexOf(item) > -1),
    ...second.filter(item => first.indexOf(item) > -1),
  ])];

  // @TODO: So that was a nifty bit of error checking... if that array has more
  // than one item in it, throw an error??

  return uniques[0];
}

/**
 * Given a letter where [a-z] => 1-26 and [A-Z] => 27-52, return the
 * corresponding "priority" number.
 *
 * @param input (string) A letter to code as a number
 * @returns (number) The priority number of the letter
 */
const getNumber = (input: string): number => {
  // 27 - 52 for capital letters
  if (input.match(/^[A-Z]$/)) {
    return input.charCodeAt(0) - 64 + 26
  }
  // 1 - 26 for lower case letters
  else if (input.match(/^[a-z]$/)) {
    return input.charCodeAt(0) - 96
  }
  // Or boop.
  else {
    console.log(`Couldn't determine priority number for "${input}"`);
    return 0;
  }
}

// Which items are overpacked?
const overpackedItems = rucksacks.map(sack => findUnique(sack));

// And what are their "priority" numbers?
const itemPriorities = overpackedItems.map(item => getNumber(item));

// Sum those and report.
const sum = itemPriorities.reduce((total, next) => total + next, 0);

console.log(`The sum of the item types in both compartments of each sack is ${sum}.`);
