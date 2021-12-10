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

import chalk from 'chalk';

import { SignalInput } from './SignalInput';
import { SevenSeg } from './SevenSeg';

// Read input
const signals = new SignalInput('input.txt');

// Get just the output signals
const output = signals.getOutputDigits();

// Tally up how many unique digits there are
let countUniqueDigits = 0;

output.flat()
  .forEach(display => countUniqueDigits += SevenSeg.isUnique(display) ? 1 : 0);

console.log(`Of displays, there are ${countUniqueDigits} unique-length digits.\n\n`);

// Part One:
// Of displays, there are 383 unique-length digits.

new SevenSeg(1234);
