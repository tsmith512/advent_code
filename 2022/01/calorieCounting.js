#!/usr/bin/env node

/**
 * ___               __  _
 * |   \ __ _ _  _   /  \/ |
 * | |) / _` | || | | () | |
 * |___/\__,_|\_, |  \__/|_|
 *            |__/
 *
 * "Calorie Counting"
 *
 * Given a list of numbers where numbers are separated by new lines, and groups
 * are seprated by blank lines, find the group with the highest count.
 */


const fs = require('fs');

// Return the sum of an array of numbers
const sum = (arr) => arr.reduce((total, next) => total + next, 0);

// Find the largest number in an array of numbers
const max = (arr) => arr.reduce((max, next) => (next > max ? next : max), 0);

// Read the groupings into an array of snack packs (int[][])
const elves = fs.readFileSync('input.txt')
  .toString()
  .trim()
  .split("\n\n")
  .map(string => string.split("\n").map(n => parseInt(n)));

// Sum each elf's snack pack into its total calories for the pack (int[])
const calories = elves.map(e => sum(e));

const maxCals = max(calories);

// The highest elf snack-pack calorie count is 74198
console.log(`The highest elf snack-pack calorie count is ${maxCals}`);

/**
 *  ___          _     ___
 * | _ \__ _ _ _| |_  |_  )
 * |  _/ _` | '_|  _|  / /
 * |_| \__,_|_|  \__| /___|
 *
 * Same deal, but sum the max 3 groups
 */

// Sort an array of integers numerically, descending (int[])
const sort = (arr) => arr.sort((a, b) => b - a);

const topThree = sort(calories).slice(0,3);

const total = sum(topThree);

// The cumulative calorie count of the top three elves is 209914
console.log(`The cumulative calorie count of the top three elves is ${total}`);
