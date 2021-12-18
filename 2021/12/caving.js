#!/usr/bin/env node

/**
 *  ___              _ ___
 * |   \ __ _ _  _  / |_  )
 * | |) / _` | || | | |/ /
 * |___/\__,_|\_, | |_/___|
 *            |__/
 *
 * "Passage Pathing"
 *
 * Challenge:
 * Given a list of passages connecting points (upper or lowercase letters), map
 * out how many ways there are to get from `start` to `end` without going thru
 * any lowercase point twice.
 */

const fs = require('fs');
const input = fs.readFileSync('short.txt').toString().trim().split('\n');

// Map out which caves lead to which caves.
const paths = {};
input.forEach((pathway) => {
  const [start, end] = pathway.split('-');

  if (paths.hasOwnProperty(start)) {
    paths[start].push(end);
  } else {
    paths[start] = [end];
  }

  // These passages are two-way:
  if (paths.hasOwnProperty(end)) {
    paths[end].push(start);
  } else {
    paths[end] = [start];
  }

});

// Map out paths from start to end (or dead ends)
const routes = [];
const traverse = (start = 'start', route = ['start'], partTwo = false) => {
  // Where can we go from here, per the rules?
  const options = paths[start]
    .filter(x => {
      if (x === 'start') {
        // Don't go back to the start.
        return false;
      } else if (x === 'end') {
        // Keep 'end' as a valid option.
        return true;
      } else if (x === x.toUpperCase()) {
        // Upper Case caves can be revisited.
        return true;
      } else if (partTwo) {
        /**
         *  ___          _     ___
         * | _ \__ _ _ _| |_  |_  )
         * |  _/ _` | '_|  _|  / /
         * |_| \__,_|_|  \__| /___|
         *
         * You can visit any one lower-case cave a second time. Each route may
         * contain no more than one lower-case cave twice.
         */
        return route.filter(y => y === x).length < 2;
        // @TODO: ^^ Solves the wrong problem. This checks to see if _this_ cave
        // has been seen more than once. Need to see if _any_ have.
      } else {
        // FOR PART ONE: Lower Case caves can only be visited one.
        return !route.includes(x);
      }
    });

  if (!options) {
    // Dead end. Bail.
    return;
  }

  options.forEach((next) => {
    // Make a _copy_ of the current route because objects pass by reference.
    const thisPath = Array.from(route);

    // Add this option to the new route array.
    thisPath.push(next);

    if (next === 'end') {
      routes.push(thisPath);
    } else {
      traverse(next, thisPath, partTwo);
    }
  });
};

traverse();

console.log(`There are ${routes.length} routes through the caves.`);

// Part One:
// There are 4775 route through the caves.

routes.length = 0;
traverse('start', ['start'], true);
console.log(routes.map(r => r.join('-')));
console.log(`And ${routes.length} routes if you double-back once.`);
