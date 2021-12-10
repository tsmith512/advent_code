import * as fs from 'fs';
import { join } from "path";

export class SignalInput {
  private raw: string[][];

  constructor(filename: string) {
    this.raw = fs
      .readFileSync(join(process.cwd(), `lib/${filename}`), 'utf8')
      .toString()
      .trim()
      .split("\n")
      .map(r => r.split(' | '))
  }

  getOutputDigits(): string[][] {
    return this.raw.map(r => r[1]).map(o => o.split(' '));
  }
}
