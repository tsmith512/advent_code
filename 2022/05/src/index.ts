/**
 *  ___               __  ___
 * |   \ __ _ _  _   /  \| __|
 * | |) / _` | || | | () |__ \
 * |___/\__,_|\_, |  \__/|___/
 *            |__/
 *
 * "Supply Stacks"
 *
 * Given a little ASCII art of stacked letters atop numbers, followed by a list
 * of movements, determine the contents of veritical stacks, then execute the
 * movements in order (individually). Finally, report the top item in each stack
 * after the transofrmation.
 *
 * WARNING: Input file has hidden spaces at the end of each line... watch out for that...
 *
 * ALSO WARNING: Object properties have to be strings, so the stack designations
 * will always be strings. (They're integers.)
 */

import * as fs from 'fs';
import { join } from 'path';
import chalk from 'chalk';

const FILENAME = 'sample.txt';

type cargoStack = string[];

interface cargoArea {
  [key: string]: cargoStack;
}

interface movement {
  count: number;
  from: number;
  to: number;
}

type instructions = movement[];

/**
 * Pretty print with colors.
 *
 * @param cargo (cargoArea) Current cargo stack area
 */
const visualizeCargo = (cargo: cargoArea): void => {
  const cols = Object.keys(cargo).length;
  const max = Object.keys(cargo).reduce((max, key) => Math.max(max, cargo[key].length) , 0);

  const output = [];

  // Header Row
  output.push('');
  output.push((' ' + Object.keys(cargo).join('   ')));
  output.push(chalk.gray('-'.repeat(output[1].length + 1)));

  // Contents
  for (let i = 0; i < max; i++) {
    const row = [];
    for (const stack in cargo) {
      // Assume empty
      let display = '   ';

      // If it's populated and the top of the stack
      if (cargo[stack][i] && i < cargo[stack].length - 1) {
        display = `${chalk.gray("[")}${chalk.blueBright(cargo[stack][i])}${chalk.gray("]")}`;
      }
      // If it's populated but not on top:
      else if (cargo[stack][i]) {
        display = `${chalk.gray("[")}${chalk.yellowBright(cargo[stack][i])}${chalk.gray("]")}`;
      }

      row.push(display);
    }
    output.push(row.join(' '));
  }

  output.push('');
  console.log(output.reverse().join("\n"));
};


/**
 * Execute a step 1 or more times on the cargo field.
 *
 * @param move (movement) what to do
 * @param cargo (cargoArea) the working cargo space
 */
 const doStep = (move: movement, cargo: cargoArea): void => {
  for (let i = 0; i < move.count; i++) {
    const pickup = cargo[move.from.toString()].pop();
    if (pickup) {
      cargo[move.to.toString()].push(pickup);
    }
  }
}

const report = (cargo: cargoArea): string => {
  return Object.keys(cargo)
    .reduce((report, stack) => report + cargo[stack][cargo[stack].length - 1], "");
}

// MAIN:

const [stacksArt, stepsRaw] =
  fs.readFileSync(join(process.cwd(), `lib/${FILENAME}`), 'utf8')
  .split("\n\n");

const stacksRaw = stacksArt.split("\n").reverse();

// Split the "header" row into the column numbers we'll have. Extra spaces don't
// matter, and after clean/split, it's just digits.
const stackAddresses: string[] = stacksRaw
  .shift()?.trim().replace(/\s+/g, ' ').split(' ') ?? [];

// Make a column stack for each address we got.
const cargo: cargoArea =
  Object.assign({}, ...Array.from(stackAddresses, (a) => ({[a]: []})))

// Make addresses we can use when we split out the map.
const addresses: number[] = Object.keys(cargo).map(s => parseInt(s));

// Unpack the artwork into
// {
//   [COLUMN]: [BOTTOM ... TOP]
// }
stacksRaw.forEach((row) => {
  addresses.forEach((n) => {
    // Funky addressing but this works.
    const textPostion = (n * 4) - 3;
    const container = row.slice(textPostion, textPostion + 1);

    if (container && container != ' ') {
      cargo[n.toString()].push(container);
    }
  });
});

// Unpack the instructions raw text into
// [{
//   count: How many to move
//   from: Source stack
//   to: Destination stack
// }, {}, ...]
const steps: instructions = stepsRaw.trim().split("\n").flatMap((row) => {
  const numbers = row.match(/\d/g)?.map(s => parseInt(s));
  if (numbers) {
    return {
      count: numbers[0],
      from: numbers[1],
      to: numbers[2],
    }
  } else {
    // Mostly to make type checking happy, but if a row fails the regex, flatMap
    // will make bad rows go away.
    return [];
  }
});

// Run the instructions on the cargo area global
for(const step in steps) {
  doStep(steps[step], cargo);
  visualizeCargo(cargo);
}

console.log(`The top crates are ${chalk.yellowBright(report(cargo))}\n`);
