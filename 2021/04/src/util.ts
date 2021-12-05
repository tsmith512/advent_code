import chalk from "chalk";

export type bingoCallsType = number[];
export type bingoBoardType = number[][];
export type bingoBoardCollection = bingoBoardType[];

/**
 * Split a space-filled row from a bingo board or a comma-separated sequence
 * of calls into an array of numbers.
 *
 * @param input (string) A string with tabular and whitespace separated numbers
 * @returns (number[]) An array of integers
 */
export const numbersFromString = (input: string): number[] => input
  .trim()
  .split(/[\s,]+/g)
  .map(e => parseInt(e))
  .filter(e => isFinite(e));

/**
 * Is this board valid? (Checks size only for now)
 *
 * @param board (number[] as bingoBoardType) Input board to check
 * @returns (boolean) is it a valid board
 */
export const isValidBoard = (board: bingoBoardType): boolean => {
  const checks = board.map(row => row.length == 5)
  return (checks.length == 5 && checks.every(x => x))
};

/**
 * Has a given number been called yet?
 *
 * @param n (number) to check
 * @param calls (number[] as bingoCallsType) What's been called so far
 * @returns (boolean) Has this number been called?
 */
export const numberCalled = (n: number, calls: bingoCallsType): boolean => (calls.indexOf(n) > -1);

/**
 * Visualize and score a bingo board
 *
 * WIP: "Scored" at this point is a boolean for a winning _row._
 *
 * @param board (number[][] as bingoBoardType) A bingo board
 * @param calls (number[] as bingoCallsType) What's been called?
 */
export const scoreBoard = (board: bingoBoardType, calls: bingoCallsType): boolean => {
  // Score the rows, which is easy:
  const scoredRows = board.map(row => {
    return row.every(n => numberCalled(n, calls));
  });

  // Score the columns, which is less so:
  const scoredCols = Array(board[0].length).fill(0).map((e, i) => {
    return board
      .map(row => row[i])
      .every(n => numberCalled(n, calls));
  });

  // Do the visualization of what's been called so far.
  visualizeBoard(board, calls);

  // If any row or column on this board wins, raise that.
  if (scoredRows.some(bool => bool) || scoredCols.some(bool => bool)) {
    // This board won. Let's score it.
    // Find all the numbers on the board that haven't been called.
    const uncalledNumbers = board.flat().filter(n => !numberCalled(n, calls));

    // Sum them.
    const sumUncalled = uncalledNumbers.reduce((acc, cur) => acc + cur);

    // What was the last bingo number called?
    const finalCall = calls[calls.length - 1];

    console.log(`This winning board's score was ${sumUncalled} * ${finalCall} = ${sumUncalled * finalCall}`);
    return true;
  }
  return false;
};

/**
 * Print out the board with some formatting and highlighting to show what's been
 * called and what might be a winning sequence.
 *
 * @param board (number[][] as bingeBoardType) The board to inspect
 */
export const visualizeBoard = (board: bingoBoardType, calls: bingoCallsType): void => {
  board.forEach((row) => {
    row.forEach((n, i) => {
      const pad = (n < 10) ? ' ' : '';
      const color = numberCalled(n, calls) ? 'red' : 'gray';
      process.stdout.write(pad + chalk[color](n) + ' ');
    });
    process.stdout.write("\n");
  });

  process.stdout.write("\n");
};


/**
 * Because why would shouting "Bingo!!" not be a throwable?
 */
export class Bingo extends Error {
  boardIndex: number;
  round: number;

  constructor(message: string, boardIndex: number, round: number) {
    super(message);
    Object.setPrototypeOf(this, Bingo.prototype);

    this.boardIndex = boardIndex;
    this.round = round;
  }

  announce() {
    console.log(`Bingo! Board ${chalk.green(this.boardIndex)} won on round ${this.round}`);
  }
}
