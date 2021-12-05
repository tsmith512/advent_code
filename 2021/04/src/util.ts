export type bingoCallsType = number[];
export type bingoBoardType = number[][];
export type bingoBoardCollection = bingoBoardType[];

/**
 * Split a space-filled row from a bingo board into an array of numbers.
 *
 * @param input (string) A row from a bingo board as a string with tabular and
 *   whitespace
 * @returns (number[]) An array of numbers
 */
export const numbersFromString = (input: string): number[] => input
  .trim()
  .split(/\s+/)
  .map(e => parseInt(e))
  .filter(e => isFinite(e));

/**
 * Given a bingo board, check that it is a valid size.
 *
 * @param board (number[] as bingoBoardType) Input board to check
 * @returns (boolean) is it a valid board
 */
export const isValidBoard = (board: bingoBoardType): boolean => {
  const checks = board.map(row => row.length == 5)
  return (checks.length == 5 && checks.every(x => x))
}
