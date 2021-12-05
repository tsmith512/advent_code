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
import { PassThrough } from 'stream';

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


const past: bingoCallsType = []

// Play Bingo
try {
  bingoCalls.forEach((call, round, all) => {
    // Add the new call to the list of called numbers.
    // @TODO: This means board scoring starts over on every round...
    past.push(call);

    // Score (and visualize) each board.
    const scoredBoards = bingoBoards
      .map((board, index) => scoreBoard(board, past));

    // If we had any winners this round, throw a Bingo.
    if (scoredBoards.some(bool => bool)) {
      throw new Bingo('Bingo', (scoredBoards.indexOf(true) + 1), round);
    }
  });
} catch (e) {
  if (e instanceof Bingo) {
    e.announce();
  }
}

// Part One:
// This winning board's score was 639 * 54 = 34506
// Bingo! Board 15 won on round 25
