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

const days = 80;
const input = '3,4,3,1,2';

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
