#!/usr/bin/env node

/**
 *   ___              _  __    ___          _     ___
 *  |   \ __ _ _  _  / |/ /   | _ \__ _ _ _| |_  |_  )
 *  | |) / _` | || | | / _ \  |  _/ _` | '_|  _|  / /
 *  |___/\__,_|\_, | |_\___/  |_| \__,_|_|  \__| /___|
 *             |__/
 *
 * "Ticket Translation"
 *
 * - Discard tickets determined to be invalid in Part One
 * - Determine which ticket value indices correspond to which fields
 * - Once these are understood, report the product of all my own ticket values
 *   whose name starts with "departure."
 */

const { readSections, splitInfo, inRange } = require('./ticketing.js');

const inputFile = 'ticket_notes.txt';

const main = (input) => {
  // Parse the input file into a structure we can deal with.
  const sections = readSections(input);
  const { rules, mine, nearby } = splitInfo(sections);

  // Per instructions, we can toss any tickets we determined invalid in Part One
  const invalidTicketsIDs = simpleTicketInvalidation(nearby, rules);
  const validTickets = nearby.filter((t, i) => invalidTicketsIDs.indexOf(i) === -1);

  // Figure out which columns (yes columnS...) satisfy which rule's range limits
  const mapColumnsToIndex = determineColumnMappingOptions(validTickets, rules);

  console.log(mapColumnsToIndex);
}

const simpleTicketInvalidation = (ticketPool, rules) => {
  let invalid = [];

  ticketPool.forEach((ticket, index) => {
    ticket.forEach((value) => {
      if (! inRange(value, rules)) {
        invalid.push(index);
      }
    })
  });

  return invalid;
}

const determineColumnMappingOptions = (ticketPool, rules) => {
  const firstTicket = ticketPool[0];
  const ticketColumns = firstTicket.map((value, index) => ticketPool.map(row => row[index]));

  let possibleColumns = {};

  for (const name in rules) {
    const ranges = rules[name];
    possibleColumns[name] = [];

    ticketColumns.map((column, index) => {
      // Filter current column into values that fit the rule we're looking at
      const filtered = column.filter(number => meetsRule(number, ranges));

      if (filtered.length === column.length) {
        // Every value in this column satisfied the rule we were looking at.
        possibleColumns[name].push(index);
      }
    });
  }

  return possibleColumns;
}

const meetsRule = (number, ranges) => {
  for (const pair of ranges) {
    if (pair[0] <= number && number <= pair[1]) {
      return true;
    }
  }
}

(main)(inputFile);
