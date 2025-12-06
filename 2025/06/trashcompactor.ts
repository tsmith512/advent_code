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
const INPUT = 'input.txt';

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
