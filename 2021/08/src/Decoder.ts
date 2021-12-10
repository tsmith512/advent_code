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

  updateSegmentMap(segment: string, letter: string) {
    if (this.segmentMap.hasOwnProperty(segment)) {
      this.segmentMap[segment] = letter;
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

  resolve() {
    const allInputSignals = this.signals.map(s => s.split('')).flat();

    const one = this.findDigit(1);
    const seven = this.findDigit(7);

    // If we have 1, we can deduce C and F by frequency.
    if (one) {
      const pair = one.split('');
      const onesSignals = this.getCounts(allInputSignals.filter(n => pair.includes(n)));
      Object.entries(onesSignals).forEach(signal => {
        switch (signal[1]) {
          case 8:
            // Segment C is used 8 times in digits 0-9
            this.updateSegmentMap('c', signal[0])
            break;
            case 9:
            // Segment C is used 8 times in digits 0-9
            this.updateSegmentMap('f', signal[0])
            break;
        }
      });
    }

    // If we have 1 and 7, we know what A is.
    if (one && seven) {
      const combo = [one.split(''), seven.split('')].flat();
      const counts = this.getCounts(combo);
      const unique: string = Object.entries(counts).filter(e => e[1] === 1)[0][0];
      this.updateSegmentMap('a', unique);
    }
  }
}
