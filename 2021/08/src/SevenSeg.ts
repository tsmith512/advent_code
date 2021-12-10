import chalk from 'chalk';

export class SevenSeg {
  /**
   * A map of what numbers use how many segments on a seven-segment display.
   */
  static segmentsPerDigit = {
    one: 2, // unique
    two: 5,
    three: 5,
    four: 4, // unique
    five: 5,
    six: 6,
    seven: 3, // unique
    eight: 7, // unique
  }

  /**
   * Do we know this digit because the number of segments it uses is unique?
   *
   * @param input (string) A signal output string
   * @returns (boolean) True if input represets a unique-length digit
   */
  static isUnique(input: string): boolean {
    const uniqueLengths = Object.entries(this.segmentsPerDigit)
      .filter(d => ['one', 'four', 'seven', 'eight'].indexOf(d[0]) > -1)
      .map(d => d[1]);

    return uniqueLengths.indexOf(input.length) > -1;
  }
}
