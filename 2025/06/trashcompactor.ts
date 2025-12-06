/**
 *   ___               __   __
 *  |   \ __ _ _  _   /  \ / /
 *  | |) / _` | || | | () / _ \
 *  |___/\__,_|\_, |  \__/\___/
 *             |__/
 *
 * "Trash Compactor"
 *
 * Given a table of numbers with a final row of operators, help a cephalopod
 * student complete her homework. Use the operator (* or +) to math the columns
 * of number together, then sum all the answers.
 */

import fs from 'fs';

const DEBUG = true;
const INPUT = 'sample.txt';

const debugPrint = (input: any) => {
  if (DEBUG) {
    console.log(input);
  }
};

const problems: number[][] = [];
const operators: ('*'|'+')[] = [];

// Read and clean up the input
fs.readFileSync(INPUT)
  .toString()
  .trim()
  .split('\n')
  .map(r => r.trim()) // Remove leading spaces on each line (this will come back to haunt me, won't it)
  .forEach((line, i, input) => {
    // Last line, process the operators
    if (i == input.length - 1) {
      line.split(/\s+/).forEach(s => operators.push(s as ('*' | '+')));
    }

    // First line, we need to make the arrays for each problem
    else if (i === 0) {
      line.split(/\s+/).forEach(n => problems.push([ parseInt(n) ]));
    }

    // Push new row of numbers into each math problem
    else {
      line.split(/\s+/).forEach((n, i) => problems[i].push(parseInt(n)));
    }
  });

if (problems.length !== operators.length) {
  debugPrint("Something is wrong: different number of problems and operators.");
}

// As a friend once said, "boutique and unnecessary." But I think this this is
// the kind of clever that's too fun for production work:
const op = {
  "+": (input: number[]) => { return input.reduce((total, current) => total + current, 0) },
  "*": (input: number[]) => { return input.reduce((total, current) => total * current, 1)},
};

const answers = problems.map((n, i) => (op[operators[i]])(n));

debugPrint(answers);

// Part One:
// The sum of all homework answers is 4076006202939.
console.log(`The sum of all homework answers is ${op["+"](answers)}.`);

//
// PART TWO
//
// LOL OKAY MATH IS STUPIDER NOW.
// Numbers are written top-to-bottom, right-to-left.
//

// Let's start over shall we?
problems.length = 0;

// Read and clean up the input. but different.
const lines = fs.readFileSync(INPUT)
  .toString()
  .trim()
  .split('\n');

// We already know the operators.
lines.pop();

// Keep track of what problem we're populating
let currentProblem = 0;
problems.push([]);

// From right to left...
for (let i = lines[0].length; i >= 0; i--) {
  // From top to bottom...
  const digits: string[] = lines.map(l => l[i]);

  // If a column is all spaces, we've moved on to a new problem.
  // Make an array for it and continue to the next column.
  if (digits.every(c => c === ' ')) {
    currentProblem++;
    problems.push([]);
    continue;
  }

  const number: number = digits
    // Cast to int, empty spaces will be NaN
    .map(n => parseInt(n))
    // Remove NaN's: both [NaN, NaN, 1] and [1, NaN, NaN] are 1, not 1 and 100.
    .filter(n => !Number.isNaN(n))
    // Put the full numbers together (re-using this reducer from Day 3 "Lobby"!)
    // NB: 'n' is the result of the filter, 'number''s length may have changed:
    .reduce((total, current, index, n) => total + (current * 10 ** (n.length - index - 1)), 0)

  problems[currentProblem].push(number);
}

// These were read left-to-right, so reverse them.
operators.reverse();

// This part works the same way.
const newAnswers = problems.map((n, i) => (op[operators[i]])(n));

console.log(`Having learned to read octopus math, new sum is ${op["+"](newAnswers)}.`);
