import chalk from 'chalk';

export class SevenSeg {
  /**
   * A map of what numbers use how many segments on a seven-segment display.
   */
  static segmentsPerDigit = [
    6, // zero
    2, // one - unique
    5, // two
    5, // three
    4, // four - unique
    5, // five
    6, // six
    3, // seven - unique
    7, // eight - unique
  ]

  /**
   * Do we know this digit because the number of segments it uses is unique?
   *
   * @param input (string) A signal output string
   * @returns (boolean) True if input represets a unique-length digit
   */
  static isUnique(input: string): boolean {
    return this.segmentsPerDigit.filter(n => n === input.length).length === 1;
  }
}
