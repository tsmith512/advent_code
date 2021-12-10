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
import { Decoder } from './Decoder';

// Read input
const signals = new SignalInput('sample-short.txt');

// Get just the output signals
const output = signals.getOutputDigits();

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


// Get a row from the sample and make a map of { signal: known-value | false }
// based on the uniques we can determine.
const test = new Decoder(signals.getRow(0));

// Figure out what signals map to which segments.
test.resolve();
test.translateOutput();

console.log(new SevenSeg(test.translatedOutputs).getNumber());
