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

const inputFile = 'ticket_notes.txt';

const main = () => {
  const sections = readSections();
  const { rules, mine, nearby } = splitInfo(sections);

  // Part One rather pointedly explained that the "invalid tickets" would be
  // obviously out of range rather than requiring field-level validation. I can
  // only assume that horror comes in Part Two...
  let sum = simpleTicketValidation(nearby, rules);

  console.log("The sum of invalid ticket numbers is: " + sum);
  // Part One solution:
  //   The sum of invalid ticket numbers is: 27802
}

const readSections = () => {
  const rawInput = fs.readFileSync(inputFile, 'utf8');
  const sections = rawInput.trim().split("\n\n");
  const ticketData = {
    rules: sections[0].split("\n"),
    mine: sections[1].split("\n")[1],
    nearby: sections[2].split("\n").splice(1),
  };
  return ticketData;
}

const splitInfo = (sections) => {
  let { rules, mine, nearby } = sections;

  // Validation Rules. Make a new object to contain named rules rather than
  // nested arrays that get weird to traverse.
  rulesProcessed = {};
  rules.forEach((line, index) => {
    // Split the rule into its key and value pars
    const parts = line.split(':');

    // Trim the name
    const name = parts[0].trim();

    // Split the string into separate ranges, then into [low, high] pairs
    const ranges = parts[1].trim().split(' or ').map(x => x.split('-').map(y => parseInt(y)));

    rulesProcessed[name] = ranges;
  });

  // Split up the ticket field values into ints in nested arrays.
  mine = [mine.split(',').map(y => parseInt(y))];
  nearby = nearby.map(x => x.split(',').map(y => parseInt(y)));

  return { rules: rulesProcessed, mine, nearby };
}

const simpleTicketValidation = (ticketPool, rules) => {
  let sum = 0;

  ticketPool.forEach((ticket) => {
    ticket.forEach((value) => {
      if (! inRange(value, rules)) {
        sum += value;
      }
    })
  });

  return sum;
}

const inRange = (number, rules) => {
  for (const rule in rules) {
    for (const pair of rules[rule]) {
      if (pair[0] <= number && number <= pair[1]) {
        return true;
      }
    }
  }
  return false;
}

(main)();
