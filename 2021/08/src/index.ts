/**
 *   ___               __  ___
 *  |   \ __ _ _  _   /  \( _ )
 *  | |) / _` | || | | () / _ \
 *  |___/\__,_|\_, |  \__/\___/
 *             |__/
 *
 * "Seven Segment Search"
 *
 * Challenge:
 * There are four-digit seven-segment displays. Segments are lettered A thru G.
 * However, the mapping of letter to segment is unknown. [...]
 *
 * The input contains "unique signal patters" a pipe and "four digit output val"
 *
 * Digits 1, 4, 7, 8 ea use a unique number of segments so the output is easy to
 * determine. Count the number of those digits in the output values (after |).
 */

import { SignalInput } from './SignalInput';
import { SevenSeg } from './SevenSeg';
import { Decoder } from './Decoder';

// Read input
const input = new SignalInput('input.txt');

// Get just the output signals
const output = input.getOutputDigits();

// Tally up how many unique digits there are
let countUniqueDigits = 0;

output.flat()
  .forEach(display => countUniqueDigits += SevenSeg.isUnique(display) ? 1 : 0);

console.log(`Of displays, there are ${countUniqueDigits} unique-length digits.\n\n`);

// Part One:
// Of displays, there are 383 unique-length digits.

/**
 *  ___          _     ___
 * | _ \__ _ _ _| |_  |_  )
 * |  _/ _` | '_|  _|  / /
 * |_| \__,_|_|  \__| /___|
 *
 * Build the mapping for each row's signals to which segments each letter really
 * is. And from there, determine the numbers in the display and report the sum.
 *
 * Note: Each row's input signals have ten unique so there's one for every digit
 */

const fixedNumbers = input.getAll().map(row => {
  const fixedSignals = new Decoder(row).resolve().translateOutput();
  return new SevenSeg(fixedSignals).getNumber() || 0;
});

const sum = fixedNumbers
  .reduce((sum, number) => sum += number, 0);

console.log(`After translating the signals, the sum of displayed numbers is ${sum}`);

// Part Two:
// After translating the signals, the sum of displayed numbers is 998900
