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
  highlightBoard,
} from './util';


// Read from file and split into sections (delineated by double-newlines).
const inputSections: any = fs
  .readFileSync(join(process.cwd(), 'lib/sample.txt'), 'utf8')
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
    past.push(call);

    console.clear();
    console.log(`Round ${round}`);
    bingoBoards.forEach((board, index) => highlightBoard(board, past));
  });
} catch (e) {

}
