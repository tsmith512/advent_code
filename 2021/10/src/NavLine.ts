// This is wholly unnecessary, but I've never played with literal string types
// and it did make for some nice IDE suggestions and warnings about typos.
type chunkOpener = '<' | '['       | '{'     | '(';
type chunkCloser = '>' | ']'       | '}'     | ')';
type chunker = chunkOpener | chunkCloser;
type chunkType = 'tag' | 'bracket' | 'brace' | 'paren';
type lineCheck = 'valid' | 'corrupt' | 'incomplete';

export class NavLine {
  /**
   * The input as we got it.
   */
  raw: string;

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

    this.process();
  }

  /**
   * Iterate over characters in the input string to find out how this line is
   * borked, if it is. @TODO: Does not yet confirm incomplete/complete.
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
    } catch (e) {
      // This is just to break the forEach. Does not need to be reported.
    }
  }

  /**
   * Return true if this character opens a new chunk. False if it closes.
   * @param x
   */
  opens(x: chunker): boolean {
    if ('<[{('.includes(x)) {
      return true;
    }
    return false;
  }

  /**
   * Return the name of the chunk type given a character that opens or closes it
   */
  type(x: chunker): chunkType {
    switch (x) {
      case '<':
      case '>':
        return 'tag';
      case '[':
      case ']':
        return 'bracket';
      case '{':
      case '}':
        return 'brace';
      case '(':
      case ')':
        return 'paren';
    }
  }

  /**
   * If this line is corrupted, return its score based on the corruptChunk type.
   *
   * @returns (number) the score
   */
  score(): number {
    switch (this.corruptChunk) {
      case 'paren':
        return 3;
      case 'bracket':
        return 57;
      case 'brace':
        return 1197;
      case 'tag':
        return 25137;
      default:
        return 0;
    }
  }
}
