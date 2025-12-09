/**
 *   ___               __  ___
 *  |   \ __ _ _  _   /  \( _ )
 *  | |) / _` | || | | () / _ \
 *  |___/\__,_|\_, |  \__/\___/
 *             |__/
 *
 * "Playground"
 *
 * Given a list of coordinates [X,Y,Z] for "junction boxes" in 3D spaces,
 * determine pairs that are closest together and "connect them." Chains form
 * circuits.
 */
import fs from 'fs';

const DEBUG = true;
const INPUT = 'sample.txt';

const debugPrint = (input: any) => {
  if (DEBUG) {
    console.log(input);
  }
};

class Box {
  id: number; // Will be line of the file (1-based), used as circuit init too
  x: number;
  y: number;
  z: number;
  circuit: number | null;
  connected?: Box[];

  constructor(params: {id: number, x: number, y: number, z: number}) {
    Object.assign(this, params);
    this.connected = [];
    this.circuit = null;
  }

  connect = (box: Box): Box | Error => {
    // Is this already connected?
    if (this.connected.length >= 2) {
      throw new Error(`Box ${this.id} already connected to two others.`);
    }
    // This the other already connected?
    else if (box.connected.length >= 2) {
      throw new Error(`Box ${box.id} already connected to two others.`);
    }
    // Okay there are empty sockets... try to make a circuit
    else {
      // If neither are already in a group circuit, use this ID as the circ #
      if (this.circuit === null && box.circuit === null) {
        this.connected.push(box);
        box.connected.push(this);
        this.circuit = this.id;
        box.circuit = this.id;
      }
      // If the other is in a circuit and this isn't, use its circuit id
      else if (this.circuit === null && box.circuit) {
        this.connected.push(box);
        box.connected.push(this);
        this.circuit = box.circuit;
      }
      // If this is in a circuit and the other isn't, use this circuit id
      else if (this.circuit && box.circuit === null) {
        this.connected.push(box);
        box.connected.push(this);
        box.circuit = this.circuit;
      }
      // If these two are already in the same circuit (and it's not null)
      else if (this.circuit === box.circuit) {
        throw new Error(`Boxes ${this.id} and ${box.id} already in the same circuit.`);
      }
      // If they are different circuits...
      else if (this.circuit !== box.circuit) {
        // @TODO is this okay??
        throw new Error(`Boxes ${this.id} and ${box.id} already in separate circuits.`);
      }
    }

    // @TODO: Figue out circuits.

    return this;
  }
}

const debugBox = (box: Box) => {
  if (DEBUG) {
    console.log(
      `Box ${box.id.toString().padStart(4) || 'unknown'}: ` +
      `${box.x.toString().padStart(4)}, ${box.y.toString().padStart(4)}, ${box.z.toString().padStart(4)} ` +
      `Connected to ${box.connected.map(b => b.id).join(',') || 'none'}. Circuit ${box.circuit || 'isolated'}.`
    );
  }
}

/**
 * Given two boxes, calculate the euclidian distance between them.
 * ref: https://en.wikipedia.org/wiki/Euclidean_distance
 *
 * @param a (box)
 * @param b (box)
 */
const boxDistance = (a: Box, b: Box): number => Math.sqrt(
  ((a.x - b.x) ** 2) +
  ((a.y - b.y) ** 2) +
  ((a.z - b.z) ** 2)
);

const field: Box[] = [];

// Read and create Boxes in the field.
fs.readFileSync(INPUT)
  .toString()
  .trim()
  .split('\n')
  .forEach((line, i) => {
    const [x, y, z] = line.trim().split(',').map(n => parseInt(n));
    field.push(new Box({ id: i + 1, x, y, z}));
  });

field.forEach(b => debugBox(b));

// Make an array of pairs of boxes with their calcuated distance.
const distances: {lo: Box, hi: Box, dist: number}[] = [];

for (let a = 0; a < field.length; a++) {
  for (let b = 0; b < field.length; b++) {
    // No need for a box to connect to itself.
    if (a === b) {
      continue;
    }

    // To avoid duplicates, always pair up by lower and higher ids
    const lo = field[Math.min(a, b)];
    const hi = field[Math.max(a, b)];

    // If we have't accounted for this combination already
    if (distances.some((pair) => pair.lo.id === lo.id && pair.hi.id === hi.id) === false) {
      distances.push({
        lo, hi, dist: boxDistance(lo, hi)
      });
    }
  }
}

distances.sort((a, b) => a.dist - b.dist);

distances.forEach(d => debugPrint(`${d.lo.id} --> ${d.hi.id}: ${d.dist}`));

let connections = 0;
let i = 0;
while (connections < 10) {
  // If this pair of two isn't already connected to each other:
  if (!distances[i].lo.connected.includes(distances[i].hi)) {
    // Try to connect them together. This will fail if either is already
    // connected two two others
    try {
      distances[i].lo.connect(distances[i].hi);
      connections++;
    } catch (err) {
      debugPrint(err?.message);
    }
  } else {
    debugPrint(`Boxes ${distances[i].lo.id} and ${distances[i].hi.id} already connected`);
  }
  i++;
}

field.forEach(b => debugBox(b));

debugPrint(field.reduce((circuits, box) => {
  if (circuits.hasOwnProperty(box.circuit)) {
    circuits[box.circuit]++;
  } else {
    circuits[box.circuit] = 1;
  }
  return circuits;
}, {}));
