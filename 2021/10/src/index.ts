/**
 *  ___              _  __
 * |   \ __ _ _  _  / |/  \
 * | |) / _` | || | | | () |
 * |___/\__,_|\_, | |_|\__/
 *            |__/
 *
 * "Syntax Scoring"
 *
 * Challenge:
 * Given a sequence of open and closing "chunk" containers () {} [] <>
 * find rows that are not paired correctly to open and close in order. Rows that
 * are merely incomplete are to be ignored in Part One. Stop at the FIRST wrong
 * character.
 *
 * With "corrupted" rows and the incorrect characters identified, score them and
 * report the sum of the score for the input.
 *
 * - ): 3 points.
 * - ]: 57 points.
 * - }: 1197 points.
 * - >: 25137 points.
 */

import * as fs from 'fs';
import { join } from 'path';

import { NavLine } from './NavLine';

// Read and prep lines
const lines: string[] = fs
  .readFileSync(join(process.cwd(), 'lib/input.txt'), 'utf8')
  .toString()
  .trim()
  .split("\n");

// Run through the NavLine processor to grab the invalid ones
const invalidLines = lines
  .map(line => new NavLine(line))
  .filter(navLine => navLine.corruptChunk);

// Score the bad ones
const score = invalidLines.reduce((score, line) => {
  return score += line.score();
}, 0)

console.log(`The score of invalid nav lines is ${score}.`);

// Part One:
// The score of invalid nav lines is 436497.
