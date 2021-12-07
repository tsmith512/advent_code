#!/usr/bin/env node

/**
 *  ___               __   __
 * |   \ __ _ _  _   /  \ / /
 * | |) / _` | || | | () / _ \
 * |___/\__,_|\_, |  \__/\___/
 *            |__/
 *
 * "Lanternfish"
 *
 * Challenge:
 * Consider a school of fish each identified by the number of cycles until they
 * next reproduce. Given a list of such numbers, grow the school a given number
 * of cycles and count the fish present on a particular day.
 *
 * - When a fish is born, it starts at 8 days (counting down)
 * - When a fish reaches 0 days, the _next_ morning it produces a fish at 8 days
 *   and its own counter resets to 6.
 * - 0 is a valid day. Fish make fish after Day 0, not after Day 1.
 */

const fs = require('fs');

const days = 80;
const input = fs.readFileSync('sample.txt')
  .toString()
  .trim();

const fishies = input.split(',').map(f => parseInt(f));

const day = () => {
  // Subtract one from the cycle time on each fish.
  fishies.forEach((f, i) => fishies[i] -= 1);


  // Reset reproduction cycle and count the fish that were born.
  let birthdays = 0;
  fishies.forEach((f, i) => {
    if (f === -1) {
      birthdays += 1;
      fishies[i] = 6;
    }
  });

  // Make new fishies and push 'em into the school.
  Array(birthdays).fill(8).map(f => fishies.push(f));
};

for (let i = days; i > 0, i--;) {
  day();
}

console.log(`After ${days}, there would be ${fishies.length} fish.`);

// Part One:
// After 80, there would be 390923 fish.

/**
 *  ___          _     ___
 * | _ \__ _ _ _| |_  |_  )
 * |  _/ _` | '_|  _|  / /
 * |_| \__,_|_|  \__| /___|
 *
 * Repeat the fish reproduction cycle until all system memory is sushi.
 *
 * Or: how many fish after day 256?
 */

// What if I maintained a count of fish by age instead?
const newSchool = Array(9).fill(0);

fs.readFileSync('sample.txt')
  .toString()
  .trim()
  .split(',')
  .map(f => parseInt(f))
  .forEach((f, i) => { newSchool[f] += 1 });

console.log(newSchool);

// I could not get this working, so calc the number of fish in the sample demo
const correctAnswers = fs.readFileSync('debug.txt')
  .toString()
  .trim()
  .split("\n")
  .map(x => x.split(',').length)

/**
 * Take any 0 Day fish off the newSchool. That number would be both the number
 * of new fish (8 Day fish) and parents (6 Day fish).
 */
const cycle = () => {
  // The index is "how many days until this count of fish makes more fish."
  const newFish = newSchool.shift();
  newSchool.push(newFish);

  newSchool[6] += newFish;

  console.log(newSchool.join('  '));
  console.log(`Total fish: ${countFishies()}`);
  console.log("\n");
};

const countFishies = () => newSchool.reduce((acc, age) => acc + age);

for (let i = 1; i <= days; i++) {
  console.log(`Day ${i}`);
  console.log(`Sample answer count: ${correctAnswers[i]}`);
  cycle();
}


console.log(newSchool);
console.log(`Total fish: ${countFishies()}`);
