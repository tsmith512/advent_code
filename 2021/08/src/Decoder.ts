import { signalPair } from "./SignalInput";
import { SevenSeg } from "./SevenSeg";

export interface finalSegmentMapping {
  [key: string]: string | false,
}

export interface segmentGuesses {
  [key: string]: number,
}

export interface mappingGuesses {
  [key: string]: string[],
}

export class Decoder {
  signals!: string[];
  outputs!: string[];
  signalMap: any;
  segmentMap: finalSegmentMapping;
  // segmentGuesses: mappingGuesses;

  /**
   * Start a Decoder from a row in the input
   *
   * @param pair (object: signalPair) signals/outputs pair from SignalInput
   */
  constructor(pair: signalPair) {
    Object.assign(this, pair);

    this.signalMap = pair.signals.reduce((map, signal) => {
      if (SevenSeg.isUnique(signal)) {
        return {
          [signal]: SevenSeg.segmentsPerDigit.indexOf(signal.length),
          ...map
        }
      } else {
        return {
          [signal]: false,
          ...map,
        }
      }
    }, {});

    this.segmentMap = {
      a: false,
      b: false,
      c: false,
      d: false,
      e: false,
      f: false,
      g: false,
    };
  }

  showSignals() {
    console.log(this.signalMap);
  }

  showSegments() {
    console.log(this.segmentMap);
  }

  /**
   * Yay! We figured out what input signal maps to what output segment.
   *
   * @param segment (string) The output segment
   * @param signal (string) The input signal
   */
  updateSegmentMap(segment: string, signal: string): void {
    if (this.segmentMap.hasOwnProperty(segment)) {
      this.segmentMap[segment] = signal;
    }
  }

  /**
   * Which segments are used to display a number?
   * @param n (number)
   * @returns (string) which segments illuminate to show this number
   */
  findDigit(n: number): string | false  {
    const search = Object.entries(this.signalMap).filter(m => m[1] === n);

    if (search.length === 1) {
      return search[0][0];
    }

    return false;
  }

  /**
   * Count members of an input array to determine how often they appear.
   *
   * @param x (string[]) Array of things to count
   * @returns (segmentGuesses) Array keys mapped to how often they occurred
   */
  getCounts(x: string[]): segmentGuesses {
    return x.reduce((counts: any, y) => {
      counts[y] = counts[y] || 0;
      counts[y]++;
      return counts;
    }, {});
  }

  lookup(needle: any, haystack: any): string | false {
    const key = Object.keys(haystack).find(key => haystack[key] === needle);
    return (key) ? key : false;
  }

  resolve() {
    const allInputSignals = this.signals.map(s => s.split('')).flat();

    const one = this.findDigit(1);
    const seven = this.findDigit(7);

    // If we have 1 and 7, we know what A is.
    if (one && seven) {
      const combo = [one.split(''), seven.split('')].flat();
      const counts = this.getCounts(combo);
      const unique: string = Object.entries(counts).filter(e => e[1] === 1)[0][0];
      this.updateSegmentMap('a', unique);
    }

    // Some segments are used a unique number of times across digits 0-9.
    // Those counts are 4, 6, and 9 --> segments E, B, and F.

    // Count how many times we see each letter in Input Signals...
    const allInputSignalsCounted =
      this.getCounts(allInputSignals);

    // ...and how many times we see each letter in Output Segments
    const allOutputSegmentsCounted =
      this.getCounts(SevenSeg.digitSegments.map(s => s.split('')).flat());

    // Match output <-- input for those and save to the map.
    for (const signal in allInputSignalsCounted) {
      const count = allInputSignalsCounted[signal];
      if ([4, 6, 9].includes(count)) {
        const segment = this.lookup(count, allOutputSegmentsCounted)

        if (segment) {
          this.updateSegmentMap(segment, signal);
        }
      }
    }

    // If we have 1 and F, we can deduce C by frequency, too.
    if (one) {
      const onesSignals = one.split('');
      const onesSignalsCounted =
        this.getCounts(allInputSignals.filter(n => onesSignals.includes(n)));
      const candidateC = this.lookup(8, onesSignalsCounted)

      if (candidateC) {
        this.updateSegmentMap('c', candidateC);
      }
    }

    // By now, all we have left is D and G, the lower two horizontal segments.
    // The number 4 is made with 4 semgnemts, which is a unique count. And we
    // know what B, C, and F are, so whatever remains is D.
    const signalsForFour =
      this.signals.filter(signal => signal.length === 4)[0].split('');

    signalsForFour.forEach(signal => {
      // If we do not know which segment this signal maps to, it is D.
      if (!this.lookup(signal, this.segmentMap)) {
        this.updateSegmentMap('d', signal);
      }
    });

    // Whatever segment is not accounted for in our map is the signal for G.
    const knownSignals = Object.values(this.segmentMap).filter(signal => signal);
    const allSegments = Object.keys(this.segmentMap);

    allSegments.forEach(segment => {
      if (!knownSignals.includes(segment)) {
        // This segment isn't accounted for, so we know it is the signal for G.
        this.updateSegmentMap('g', segment);
      }
    })

    console.log('Count of input signals');
    console.log(allInputSignalsCounted);
    console.log('Count of output segment usage');
    console.log(allOutputSegmentsCounted);
  }
}
