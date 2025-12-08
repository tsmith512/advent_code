/**
 *   ___               __ ____
 *  |   \ __ _ _  _   /  \__  |
 *  | |) / _` | || | | () |/ /
 *  |___/\__,_|\_, |  \__//_/
 *             |__/
 *
 * "Laboratories"
 *
 * Part Two: Uhhhh somethingsomethingsomething "tachyons split timelines not
 * beams." Permute through each path a tachyon may have taken through the field
 * and count the possible paths / "timelines" instead of split events.
 */
import fs from 'fs';

const DEBUG = true;
const INPUT = 'sample.txt';

const debugPrint = (input: any) => {
  if (DEBUG) {
    console.log(input);
  }
};

const debugField = (input: string[][]) => {
  if (DEBUG) {
    input.forEach((l, i) => console.log(`${i.toString().padStart(3, ' ')}: ${l.join('')}`))
  }
}

// Read and clean up the input
const field = fs.readFileSync(INPUT)
  .toString()
  .trim()
  .split('\n')
  .map(line => line.trim().split(''));

debugField(field);

// I think "paths" would make this make more sense in my head but this is what
// the challenge text called it:
let timelines = 0;

// Run the field starting from a given number
const traverse = (area: string[][], i: number) => {
  // Read across characters in the previous line to determine what this line
  // should be.
  for (i; i < area.length; i++) {
    area[i - 1].forEach((c, j) => {
      switch (c) {
        // If a beam hits this cell...
        case 'S':
        case '|':
          // ...and this is empty space...
          if (area[i][j] === '.') {
            // ... the beam continues through it.
            // No new timeline.
            area[i][j] = '|';
          } else if (area[i][j] === '^') {
            // Copy the field here --> new "timeline"
            const newArea = structuredClone(area);
            timelines++

            area[i][j-1] = '|'; // <-- Let's say that "this timeline" always picks left
            area[i][j] = '-';

            newArea[i][j] = '-';
            newArea[i][j+1] = '|'; // <-- And that "other timeline" always handles right
            traverse(newArea, i);
          }
        break;
        case '-':
          // Above was a split, this is now empty space.
          area[i][j] = '.';
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
  debugField(area)
};

// Start at row 1 (traverse looks back 1 level)
timelines++;
traverse(structuredClone(field), 1);

debugField(field);

console.log(`Timeline was split ${timelines} times.`);
