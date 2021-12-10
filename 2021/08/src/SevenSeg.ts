import chalk from 'chalk';

export interface signalToDigitMap {
  [key: string]: number | false,
}

export class SevenSeg {
  value?: number;

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

  constructor(value?: number) {
    if (value || value === 0) {
      this.visualize(value);
    }
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
