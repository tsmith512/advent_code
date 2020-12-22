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
*/

mathHomework("homework_sample.txt");

function mathHomework($input) {
  $handle = fopen($input, "r");

  if ($handle) {
    while (($line = fgets($handle)) !== false) {
      doProblem(trim($line));
      print "\n\n";
    }
  }
}

function doProblem($problem) {
  print "Input: $problem\n";

  while (strpos($problem, "(") !== false) {
    if (($open = strpos($problem, "(")) !== false) {
      $close = strpos($problem, ")", $open + 1);
      $openNext = strpos($problem, "(", $open + 1);
      if ($openNext === false || $close < $openNext) {
        # Good, we don't have a nested parenthetical. Get this one, without the
        # encapsulating parentheses.
        $subProblem = substr($problem, $open + 1, ($close - $open - 1));
        $subSolution = doProblem($subProblem);

        $problem = substr($problem, 0, $open) . $subSolution . substr($problem, $close + 1);
        print "$subProblem = $subSolution\n";
        print "$problem\n";
      }
    }
  }

  $pieces = explode(" ", $problem);
  $first = intval(array_shift($pieces));
  $value = array_reduce($pieces, "doStep", $first);

  print "Problem value: $value\n";

  return $value;
}

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
