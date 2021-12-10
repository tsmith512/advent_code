import { signalPair } from "./SignalInput";
import { SevenSeg, signalToDigitMap } from "./SevenSeg";

/**
 * Our map of output segment to input signal.
 */
export interface segmentToSignalMap {
  [key: string]: string | false,
}

/**
 * A way to tally [key] (letter representing an input signal or output segment)
 */
export interface memberCounts {
  [key: string]: number,
}

export class Decoder {
  /**
   * The ten sample signals that describe the scrambled signal-to-segments
   */
  private signals!: string[];

  /**
   * The scrambled outputs that represent answer digits from this Decoder
   */
  private outputs!: string[];

  /**
   * THE ANSWER: The fixed outputs that represent signals for SevenSeg digits
   */
  translatedOutputs?: string[];

  /**
   * For our signals, what digits do they represent?
   */
  private signalMap: signalToDigitMap;

  /**
   * THE ANSWER KEY: For A-G, which signals map to which segments?
   */
  segmentMap: segmentToSignalMap;

  /**
   * Start a Decoder from a row in the input
   *
   * @param pair (object: signalPair) signals/outputs pair from SignalInput
   */
  constructor(pair: signalPair) {
    Object.assign(this, pair);

    // Make an object with each input signal we got. And if we can figure out
    // what digit it represents based on its length, include that as its value.
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

    // Start our decode map!
    this.segmentMap = {
      a: false,
      b: false,
      c: false,
      d: false,
      e: false,
      f: false,
      g: false,
    };

    return this;
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
   * Which input signals for this Deocer are used to display a number?
   *
   * @param n (number)
   * @returns (string) which segments illuminate to show this number
   */
  findDigit(n: number): string | false  {
    const search = Object.entries(this.signalMap)
      .filter(signal => signal[1] === n);

    // We found one signal result for that digit, return its key (the signal).
    if (search.length === 1) {
      return search[0][0];
    }

    return false;
  }

  /**
   * Count members of an input array to determine how often they appear.
   *
   * @param x (string[]) Array of things to count
   * @returns (memberCounts) Array keys mapped to how often they occurred
   */
  getCounts(x: string[]): memberCounts {
    return x.reduce((counts: any, y) => {
      counts[y] = counts[y] || 0;
      counts[y]++;
      return counts;
    }, {});
  }

  /**
   * Find a value in an object and return the key that points to it.
   *
   * @param needle (string | number) The value to look for
   * @param haystack (any object) The object to look in
   * @returns (string | false) The key for the value, or false if not found
   */
  lookup(needle: string | number, haystack: any): string | false {
    const key = Object.keys(haystack).find(key => haystack[key] === needle);
    return (key) ? key : false;
  }

  /**
   * Through some leaps in logic, populate the segmentMap's list of output
   * segments with the input signal that point to them.
   */
  resolve(): this {
    // Gimme an array with all the input signals we get, separated
    const allInputSignals = this.signals.map(s => s.split('')).flat();

    // We start knowing the output digit for these signals:
    const one = this.findDigit(1);
    const four = this.findDigit(4);
    const seven = this.findDigit(7);

    // Some segments are used a unique number of times across digits 0-9.
    // Those counts are 4, 6, and 9 --> segments E, B, and F.

    // Count how many times we see each letter across all Input Signals...
    const allInputSignalsCounted =
      this.getCounts(allInputSignals);

    // ...and how many times we see each letter across all Output Segments
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

    // If we have 1 and 7, we can find A because the top-bar will be used once.
    if (one && seven) {
      const combo = [one.split(''), seven.split('')].flat();
      const counts = this.getCounts(combo);
      const unique = this.lookup(1, counts);

      if (unique) {
        this.updateSegmentMap('a', unique);
      }
    }

    // If we have 1 and F, we can deduce C by how frequently it is used overall.
    if (one && this.segmentMap.f) {
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
    if (four) {
      four.split('').forEach(signal => {
        // If we do not know which segment this signal maps to, it is D.
        if (!this.lookup(signal, this.segmentMap)) {
          this.updateSegmentMap('d', signal);
        }
      });
    }

    // Whatever segment is not accounted for yet is the signal for G.
    const knownSignals = Object.values(this.segmentMap).filter(signal => signal);
    const allSegments = Object.keys(this.segmentMap);

    allSegments.forEach(segment => {
      if (!knownSignals.includes(segment)) {
        // This segment isn't accounted for, so we know it is the signal for G.
        this.updateSegmentMap('g', segment);
      }
    });

    // :party-popper: tada.
    return this;
  }

  /**
   * With a resolved segmentMap, translate the output signals into real output
   * segments that can be passed back over to something in SevenSeg.
   *
   * @returns (string[]) array of translated signals
   */
  translateOutput(): string[] {
    this.translatedOutputs = this.outputs.map(inputSignal => {
      return inputSignal.split('').map(before => {
        return this.lookup(before, this.segmentMap);
      }).sort().join('');
    });

    return this.translatedOutputs;
  }
}
