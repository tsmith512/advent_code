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
const navLines = lines
  .map(line => new NavLine(line));

const invalidLines = navLines
  .filter(navLine => navLine.corruptChunk);

// Score the bad ones
const invalidScore = invalidLines.reduce((score, line) => {
  return score += line.score();
}, 0);

console.log(`The score of invalid nav lines is ${invalidScore}.`);

// Part One:
// The score of invalid nav lines is 436497.

/**
 *  ___          _     ___
 * | _ \__ _ _ _| |_  |_  )
 * |  _/ _` | '_|  _|  / /
 * |_| \__,_|_|  \__| /___|
 *
 * This time, dump the corrupt lines. Any remaining line is incomplete. Resolve
 * them by completing the sequence to close any open chunk. Score the completion
 * of each line -- start at 0, for each char: multiple score by 5 then add:
 *
 * - ): 1 point.
 * - ]: 2 points.
 * - }: 3 points.
 * - >: 4 points.
 *
 * Report the median score from the whole stack.
 */

const incompleteLines = navLines
  .filter(navLine => navLine.valid === 'incomplete');

const incompleteScores = incompleteLines.map(line => line.score());

const medianIndex = Math.floor(incompleteScores.length / 2)
const medianScore = incompleteScores.sort((a, b) => a - b)[medianIndex];

console.log(`The median score of incomplete nav lines is ${medianScore}.`);

// Part Two:
// The median score of incomplete nav lines is 2377613374.
