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

// import { readSections, splitInfo, simpleTicketValidation } from './ticketing.js';
const { readSections, splitInfo, simpleTicketValidation } = require('./ticketing.js');

const inputFile = 'ticket_sample.txt';

const main = (input) => {
  const sections = readSections(input);
  const { rules, mine, nearby } = splitInfo(sections);

  let sum = simpleTicketValidation(nearby, rules)
  console.log("The sum of invalid ticket numbers is: " + sum);
}

(main)(inputFile);
