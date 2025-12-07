/**
 *   ___               __ ____
 *  |   \ __ _ _  _   /  \__  |
 *  | |) / _` | || | | () |/ /
 *  |___/\__,_|\_, |  \__//_/
 *             |__/
 *
 * "Laboratories"
 *
 * Given a field of mostly empty space ("." ), a beam emiter ("S") in the top
 * row, and a series of "splitters" ("^") in the field, trace a beam from the
 * emitter, through subsequent splitters:
 *
 * ..S..
 * ..|..
 * .|^|.
 * .|.|.
 *
 * Adjacent splitters will consolidated beams, so 2 splitters like ".*.*."
 * become three beams like "|.|.|" not four.
 *
 * Part one: how many times did the beam get split? (I take this to mean how
 * many times was a beam splitter hit from above)
 */
import fs from 'fs';

const DEBUG = true;
const INPUT = 'input.txt';

const debugPrint = (input: any) => {
  if (DEBUG) {
    console.log(input);
  }
};

const debugField = (input: string[][]) => {
  if (DEBUG) {
    input.forEach((l, i) => console.log(`${i.toString().padStart(3, ' ')}: ${l.join('')} (Beams: ${l.filter(c => c === '|').length})`))
  }
}

// Read and clean up the input
const field = fs.readFileSync(INPUT)
  .toString()
  .trim()
  .split('\n')
  .map(line => line.trim().split(''));

debugField(field);

let splits = 0;

// Starting from line 2...
for (let i = 1; i < field.length; i++) {
  // Read across characters in the previous line to determine what this line
  // should be.
  field[i - 1].forEach((c, j) => {
    switch (c) {
      // If a beam hits this cell...
      case 'S':
      case '|':
        // ...and this is empty space...
        if (field[i][j] === '.') {
          // ... the beam continues through it.
          field[i][j] = '|';
        } else if (field[i][j] === '^') {
          splits++;
          // @TODO: Anything we need to do to catch an overlap here?
          // Works properly with sample input...
          field[i][j-1] = '|';
          field[i][j] = '-';
          field[i][j+1] = '|';
        }
      break;
      case '-':
        // Above was a split, this is now empty space.
        field[i][j] = '.';
      break;
      case '.':
        // No-op. Empty space would continue; marking this case for completeness.
      break;
      case '^':
        // No-op. This was a splitter that didn't get hit.
      break;
      default:
        console.log(`Uncaught field character "${c}" at ${i}:${j+1}`);
      break;
    }
  });
}

debugField(field);
console.log(`Beam was split ${splits} times.`);
