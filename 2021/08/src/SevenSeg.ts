import chalk from 'chalk';

export interface signalToDigitMap {
  [key: string]: number | false,
}

export class SevenSeg {
  /**
   * What incoming signals is this display receiving?
   */
  signals?: string[];

  /**
   * What number is represented on this display?
   */
  number?: number;

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
    6, // nine
  ];

  /**
   * A map of which segments are ON for a given number, assuming no bad "signal"
   */
  static digitSegments = [
    'abcefg',  // zero
    'cf',      // one - unique
    'acdeg',   // two
    'acdfg',   // three
    'bcdf',    // four - unique
    'abdfg',   // five
    'abdefg',  // six
    'acf',     // seven - unique
    'abcdefg', // eight - unique
    'abcdfg',  // nine
  ];

  /**
   * Do we know this digit because the number of segments it uses is unique?
   *
   * @param input (string) A signal output string
   * @returns (boolean) True if input represets a unique-length digit
   */
  static isUnique(input: string): boolean {
    return this.segmentsPerDigit.filter(n => n === input.length).length === 1;
  }

  /**
   * Set up a new Seven Segment Display. If we have incoming signals, parse them
   * into a number, show the number with my visualizer because that's fancy, and
   * be ready to report on that nubmer as part of the final answer for Part Two.
   *
   * @param input (string[]) Array of input signals representing a number
   */
  constructor(input?: string[]) {
    if (input) {
      this.signals = input;

      // For each input signal, determine the digit it represents
      const digits = this.signals.map(signal => {
        return SevenSeg.digitSegments.indexOf(signal);
      });

      // And turn that array of digits into a numeric value
      this.number = digits.reduce((number, digit) => {
        return (number * 10) + digit;
      }, 0);

      this.visualize(this.number);
    }

    return this;
  }

  /**
   * What number is on this display?
   *
   * @returns (number | false) The number if we know it, or false.
   */
  getNumber(): number | false {
    return (this.number) ? this.number : false;
  }

  private pixel(a: string, b: string[], r?: number): string {
    r = r || 1;
    return b.includes(a)
      ? chalk.yellow('#'.repeat(r))
      : chalk.gray('.'.repeat(r));
  }

  visualize(number: number): void {
    const digits = number.toString().split('').map(d => parseInt(d));

    const lights = digits.map(d => this.illuminate(SevenSeg.digitSegments[d]));

    const matrix = Array(8).fill('');

    for (const digit in lights) {
      for (const i in matrix) {
        matrix[i] += lights[digit][i];
      }
    }

    console.log(matrix.join('\n') + '\n');
  }

  illuminate(input: string): string[] {
    const segments = input.split('');

    const lights = [
      ` ${this.pixel('a', segments, 4)}  `,
      `${this.pixel('b', segments)}    ${this.pixel('c', segments)} `,
      `${this.pixel('b', segments)}    ${this.pixel('c', segments)} `,
      ` ${this.pixel('d', segments, 4)}  `,
      `${this.pixel('e', segments)}    ${this.pixel('f', segments)} `,
      `${this.pixel('e', segments)}    ${this.pixel('f', segments)} `,
      ` ${this.pixel('g', segments, 4)}  `,
      `       `,
    ];

    return lights;
  }
}
