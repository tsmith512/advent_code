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
 * Visualize a bingo board
 *
 * @param board (number[][] as bingoBoardType) A bingo board
 * @param calls (number[] as bingoCallsType) What's been called?
 */
export const highlightBoard = (board: bingoBoardType, calls: bingoCallsType): void => {
  board.forEach(row => {

    row.forEach((n, i) => {
      const pad = (n < 10) ? ' ' : '';
      const color = numberCalled(n, calls) ? 'red' : 'gray';
      process.stdout.write(pad + chalk[color](n) + ' ');
    });

    process.stdout.write("\n");
  });

  process.stdout.write("\n");
};
