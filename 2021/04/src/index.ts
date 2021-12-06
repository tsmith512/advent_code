/**
 *  ___               __  _ _
 * |   \ __ _ _  _   /  \| | |
 * | |) / _` | || | | () |_  _|
 * |___/\__,_|\_, |  \__/  |_|
 *            |__/
 *
 * "Giant Squid"
 *
 * Challenge:
 * Parse bingo boards and a sequence of calls out of a text file. Find the board
 * that will win and determine the bingo score it will receive.
 */

import * as fs from 'fs';
import { join } from 'path';
import chalk from 'chalk';

import {
  bingoCallsType,
  bingoBoardType,
  bingoBoardCollection,
  numbersFromString,
  isValidBoard,
  scoreBoard,
  Bingo,
} from './util';


// Read from file and split into sections (delineated by double-newlines).
const inputSections: any = fs
  .readFileSync(join(process.cwd(), 'lib/input.txt'), 'utf8')
  .split("\n\n");


// The call sequence is a CSV in the first section.
const bingoCalls: bingoCallsType = numbersFromString(inputSections.shift());
console.log(`Imported ${bingoCalls.length} bingo calls.`);


// Grab the remaining sections, and set up 5x5 boards.
const bingoBoards: bingoBoardCollection = inputSections
  .map((board: string) => {
    return board
      .split("\n")
      .map((row: string) => numbersFromString(row))
      .filter(row => row.length) as bingoBoardType;
  });

const validBoardCount = bingoBoards
  .map(b => isValidBoard(b))
  .filter(b => b)
  .length;

console.log(`Imported ${bingoBoards.length} boards, ${validBoardCount} are good.`);


// Play Bingo
console.log(`\n${chalk.green('Part One:')}`);
const past: bingoCallsType = [];

try {
  bingoCalls.forEach((call, round, all) => {
    // Add the new call to the list of called numbers.
    // @TODO: This means board scoring starts over on every round...
    past.push(call);

    // Score each board.
    const scoredBoards = bingoBoards
      .map((board, index) => scoreBoard(board, past));

    // If we had any winners this round, throw a Bingo.
    const findWinner = scoredBoards.findIndex(score => score > 0);
    if (findWinner > -1) {
      throw new Bingo('Bingo',
        (findWinner + 1),
        round,
        call,
        scoredBoards[findWinner]
      );
    }
  });
} catch (e) {
  // Stop and shout Bingo.
  if (e instanceof Bingo) {
    e.announce();
  }
}

// Part One:
// This winning board's score was 639 * 54 = 34506
// Bingo! Board 15 won on round 25

/**
 *  ___          _     ___
 * | _ \__ _ _ _| |_  |_  )
 * |  _/ _` | '_|  _|  / /
 * |_| \__,_|_|  \__| /___|
 *
 * Which board would win last?
 */

// My scoring method ain't fast, so lets filp the call stack to save time.
// const reverseCalls: bingoCallsType = bingoCalls.reverse();
console.log(`\n${chalk.green('Part Two:')}`);
past.length = 0;
const winningBoards = Array(bingoBoards.length).fill(false);
let lastWinner: any = null;

// Play Bingo
bingoCalls.forEach((call, round, all) => {
  past.push(call);

  bingoBoards.forEach((board, index) => {
    // If the board has already won, don't score it again.
    if (!winningBoards[index]) {

      // Did this board win?
      const score = scoreBoard(board, past)
      if (score) {
        // Don't score it again.
        winningBoards[index] = true;

        // Save it as the latest winner.
        lastWinner = new Bingo('Bingo',
          (index + 1),
          round,
          call,
          score
        );
      }
    }
  });
});

if (lastWinner instanceof Bingo) {
  lastWinner.announce();
}

// Part Two:
// Bingo! Board 59 won on round 85 when 42 was called. It scored 7686.
