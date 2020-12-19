#!/usr/bin/env node

/**
 *   ___              _  __
 *  |   \ __ _ _  _  / |/ /
 *  | |) / _` | || | | / _ \
 *  |___/\__,_|\_, | |_\___/
 *             |__/
 *
 * "Ticket Translation"
 *
 * Challenge:
 *
 * Given a train ticket in a "language I can't understand," parse what it means
 * based on notes about other tickets to get what fields are and what ranges
 * they might have.
 *
 * Given each line in the input is an unlabeled CSV of numbers, columns are
 * always in the same order.
 *
 * Given rules like `class: 1-3 or 5-7` means the `class` field accepts values
 * 1-3 or 5-7 inclusive (so 3 is okay, 4 is not).
 *
 * Determine which tickets are invalid (they have values that do not correspond
 * to any field validation rules). Capture the values which are not valid and
 * report the sum.
 */

const fs = require('fs');

const inputFile = 'ticket_sample.txt';

const main = () => {
  console.log(parseFile())
}

const parseFile = () => {
  const rawInput = fs.readFileSync(inputFile, 'utf8');
  const sections = rawInput.trim().split("\n\n");
  const ticketData = {
    rules: sections[0].split("\n"),
    mine: sections[1].split("\n").splice(1),
    nearby: sections[2].split("\n").splice(1),
  };
  console.log(ticketData)
}

(main)();
