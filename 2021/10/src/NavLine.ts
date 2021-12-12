// This is wholly unnecessary, but I've never played with literal string types
// and it did make for some nice IDE suggestions and warnings about typos.
type chunkOpener = '<' | '['       | '{'     | '(';
type chunkCloser = '>' | ']'       | '}'     | ')';
type chunkType = 'tag' | 'bracket' | 'brace' | 'paren';
type chunker = chunkOpener | chunkCloser;
type lineCheck = 'valid' | 'corrupt' | 'incomplete';

export class NavLine {
  /**
   * The input as we got it.
   */
  raw: string;

  /**
   * The characters we would need to add to complete an incomplete line.
   */
  completion: string;

  /**
   * Is this line valid, corrupt, or incomplete?
   */
  valid?: lineCheck;

  /**
   * If this is a corrupt line, what was wrong with it?
   */
  corruptChunk: chunkType | false;

  constructor(line: string) {
    this.raw = line;
    this.corruptChunk = false;
    this.completion = '';

    this.process();
  }

  /**
   * Iterate over characters in the input string to determine if is corrupted
   * or can be completed. Populates this.valid and this.completion.
   */
  process() {
    // Let's keep a tally of what is open
    const openChunks: chunkType[] = [];

    // Go character at a time
    try {
      this.raw.split('').forEach((x, i) => {
        const char = x as chunker;

        if (this.opens(char)) {
          // Opening a new chunk, add it to the list of what's open
          openChunks.push(this.type(char));
        } else {
          // Closing a chunk. Pull the most recent
          const lastType = openChunks.pop();
          const thisType = this.type(char);

          // Close character is the wrong type? :bomb:
          if (lastType !== thisType) {
            this.valid = 'corrupt';
            this.corruptChunk = thisType;
            throw new Error();
          }
        }
      });

      // PART TWO JAZZ: If an error wasn't thrown, we need to complete the seq.
      if (openChunks.length === 0) {
        // If nothing is open, then the line is valid.
        this.valid = 'valid';
        return;
      }

      this.valid = 'incomplete';

      openChunks.reverse().forEach((type, i) => {
        this.completion += this.close(type);
      });
    } catch (e) {
      // This is just to break the forEach. Does not need to be reported.
    }
  }

  /**
   * Return true if this character opens a new chunk. False if it closes.
   *
   * @param x (chunker) any open or closing chuck delimiter
   */
  opens(x: chunker): boolean {
    if ('<[{('.includes(x)) {
      return true;
    }
    return false;
  }

  /**
   * Provide the closing character for the given type.
   *
   * @param type (chunkType) type to close
   * @returns (chunkClose) the appropraite closing character
   */
  close(type: chunkType): chunkCloser {
    return {
      paren: ')',
      bracket: ']',
      brace: '}',
      tag: '>',
    }[type] as chunkCloser;
  }

  /**
   * Return the name of the chunk type given a character that opens or closes it
   */
  type(x: chunker): chunkType {
    return {
      '<': 'tag',
      '>': 'tag',
      '[': 'bracket',
      ']': 'bracket',
      '{': 'brace',
      '}': 'brace',
      '(': 'paren',
      ')': 'paren',
    }[x] as chunkType;
  }

  /**
   * Score this line based either on its invalid character or completion string.
   *
   * @returns (number) the score
   */
  score(): number {
    // Score an invalid character?
    if (this.corruptChunk) {
      return {
        paren: 3,
        bracket: 57,
        brace: 1197,
        tag: 25137,
      }[this.corruptChunk];
    }

    // PART TWO:
    // Tally the score of the completion string
    return this.completion.split('').reduce((score, current) => {
      const closer = current as chunkCloser;
      return (score * 5) + {
        ')': 1,
        ']': 2,
        '}': 3,
        '>': 4,
      }[closer];
    }, 0);
  }
}
