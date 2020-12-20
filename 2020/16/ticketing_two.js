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

const inputFile = 'ticket_sample.txt';

const main = (input) => {
  const sections = readSections(input);
  const { rules, mine, nearby } = splitInfo(sections);
  const invalidTickets = simpleTicketInvalidation(nearby, rules);
  const validTickets = nearby.filter((t, i) => invalidTickets.indexOf(i) === -1);

  const mapColumnsToIndex = determineColumnMapping(nearby, rules);

  // console.log(mapColumnsToIndex);
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

const determineColumnMapping = (ticketPool, rules) => {
  const firstTicket = ticketPool[0];
  const ticketColumns = firstTicket.map((value, index) => ticketPool.map(row => row[index]));

  console.table(ticketColumns);
}

(main)(inputFile);
