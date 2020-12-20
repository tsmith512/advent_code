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
  const columnMappingOptions = determineColumnMappingOptions(validTickets, rules);

  // Can we determine which columns go where?
  const columnsOrdered = finalizeColumnMappings(columnMappingOptions);

  // Resolve "my ticket" against the column mapping we determined
  const myTicket = mine[0].reduce((t, value, i) => ({ ...t, [columnsOrdered[i]]: value }));

  const requestedFields = Object.keys(myTicket).filter(x => x.indexOf('departure') === 0);
  const product = requestedFields.reduce((acc, field) => acc * myTicket[field], 1);
  console.log(`The product of departure keys is: ${product}`);
  // Part Two solution:
  //   The product of departure keys is: 279139880759
};

const simpleTicketInvalidation = (ticketPool, rules) => {
  const invalidIDs = [];

  ticketPool.forEach((ticket, ticketID) => {
    ticket.forEach((value) => {
      if (!inRange(value, rules)) {
        invalidIDs.push(ticketID);
      }
    });
  });

  return invalidIDs;
};

const determineColumnMappingOptions = (ticketPool, rules) => {
  // Rotate [[ticket],[ticket],...] --> [[field 0 vals], [field 1 vals],...]
  const firstTicket = ticketPool[0];
  const ticketColumns = firstTicket.map((value, index) => ticketPool.map((row) => row[index]));

  const possibleColumns = {};

  // For each rule, validate all column members to see which columns could map
  // to any given rule.
  // eslint-disable-next-line guard-for-in, no-restricted-syntax
  for (const name in rules) {
    const ranges = rules[name];
    possibleColumns[name] = [];

    // @TODO: Should this be a forEach? map wants a return value, this iterates.
    ticketColumns.map((column, index) => {
      // Filter current column into values that fit the rule we're looking at
      const filtered = column.filter((number) => meetsRule(number, ranges));

      if (filtered.length === column.length) {
        // Every value in this column satisfied the rule we were looking at.
        possibleColumns[name].push(index);
      }
    });
  }

  return possibleColumns;
};

const meetsRule = (number, ranges) => {
  // eslint-disable-next-line no-restricted-syntax
  for (const pair of ranges) {
    if (pair[0] <= number && number <= pair[1]) {
      return true;
    }
  }
};

const finalizeColumnMappings = (options) => {
  const mapping = options;
  const knownColumns = [];

  // Whittle down the map of {field: [possible columns]} until there's only one
  // option for each field.
  while (knownColumns.length < Object.keys(options).length) {
    // eslint-disable-next-line guard-for-in, no-restricted-syntax
    for (const field in mapping) {
      const columnOptions = mapping[field];

      // Special treatment once there's only one column that will fit this field
      if (columnOptions.length === 1) {
        // Have we found a new column mapping?
        if (knownColumns.indexOf(columnOptions[0]) === -1) {
          knownColumns.push(columnOptions[0]);
        }
      } else {
        // Remove every column we've already identified from the remaining options
        // for this field, then try again.
        mapping[field] = columnOptions.filter(x => knownColumns.indexOf(x) === -1);
      }
    }
  }

  // Now we have an mapping = {fieldName: index} but we need to be able to apply
  // it. Flip the key/values into an array of [firstField, secondField, ...]
  const indices = [];

  for (name in mapping) {
    indices[mapping[name]] = name;
  }

  return indices;
};

(main)(inputFile);
