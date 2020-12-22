#!/usr/bin/env php
<?php
/*
 ___              _ ___
|   \ __ _ _  _  / ( _ )
| |) / _` | || | | / _ \
|___/\__,_|\_, | |_\___/
           |__/

"Operation Order"

Challenge:
Help a kid do his math homework. They broke PMDAS. Execute parentheses first,
then all remaining operations left-to-right.

Examples:
1 + 2 * 3 + 4 * 5 + 6
    3 * 3 + 4 * 5 + 6
        9 + 4 * 5 + 6
           13 * 5 + 6
               65 + 6
                   71

1 + (2 * 3) + (4 * (5 + 6))
1 +      6  + (4 * (5 + 6))
         7  + (4 * (5 + 6))
         7  + (4 *     11)
         7  +          44
                       51

Resolve each line in the input and report the sum.

 ___          _     ___
| _ \__ _ _ _| |_  |_  )
|  _/ _` | '_|  _|  / /
|_| \__,_|_|  \__| /___|

Challenge:

Update to the math rules, parens are still resolved first, but then it's
addition before multiplication.
*/

mathHomework("homework_assignment.txt", 2);
// Part One solution:
//   Total sum 4491283311856
//
// Part Two solution:
//   Total sum 68852578641904

function mathHomework($input, $puzzle) {
  $handle = fopen($input, "r");
  $total = 0;

  if ($handle) {
    while (($line = fgets($handle)) !== false) {
      $problem = trim($line);
      print "New problem: $problem\n";

      $value = doProblem($problem, $puzzle);
      $total += $value;

      print "Problem solution $value\n";
      print "Total sum $total\n\n";
    }
  }
}

/**
 * Accept a problem statement and solve it, if parentheses are encountered, get
 * them resolved by doParens.
 */
function doProblem($problem, $puzzle) {
  while (strpos($problem, "(") !== false) {
    doParens($problem, $puzzle);
  }

  if ($puzzle == 2) {
    while (strpos($problem, "+") !== false) {
      doAddition($problem, $puzzle);
    }
  }

  $pieces = explode(" ", $problem);
  $first = intval(array_shift($pieces));
  $value = array_reduce($pieces, "doStep", $first);

  return $value;
}

/**
 * Given a problem string, find the first close-paren, then find the last
 * open-parent preceding it, and resolve that set by with doProblem and
 * splicing it back into the problem string.
 */
function doParens(&$problem, $puzzle) {
  if (($close = strpos($problem, ")")) !== false) {
    $length = strlen($problem);
    $open = strrpos($problem, "(", - $length + $close - 1);

    $subProblem = substr($problem, $open + 1, ($close - $open - 1));
    $subSolution = doProblem($subProblem, $puzzle);

    $problem = substr($problem, 0, $open) . $subSolution . substr($problem, $close + 1);
  }
}

/**
 * As a reducer for doProblem, we receive the aggregated value so far and one
 * array item. It will either be a number (to do math with) or an operator (to
 * do math by on the next number.)
 */
function doStep($current, $piece) {
  static $mode = NULL;

  if (is_numeric($piece)) {
    switch ($mode) {
      case "+":
        return $current + intval($piece);
        break;
      case "*":
        return $current * intval($piece);
        break;
    }
  }

  if (in_array($piece, array('+', '*'))) {
    $mode = $piece;
  }

  return $current;
}

/**
 * Given a problem, resolve the first addition problem we find. This uses regex
 * matching (to handle numbers with multiple digits) and string splicing like
 * doParens does. @TODO: Ditch the regex??
 */
function doAddition(&$problem) {
  $matches = array();
  preg_match('/(\d+) \+ (\d+)/', $problem, $matches);

  $patchStart = strpos($problem, $matches[0]);
  $patchLength = strlen($matches[0]);
  $subSolution = intval($matches[1]) + intval($matches[2]);

  $problem = substr($problem, 0, $patchStart) . $subSolution . substr($problem, $patchStart + $patchLength);
}
