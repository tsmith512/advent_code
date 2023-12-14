//  ___               __  ___
// |   \ __ _ _  _   /  \( _ )
// | |) / _` | || | | () / _ \
// |___/\__,_|\_, |  \__/\___/
//            |__/
//
// "Haunted Wasteland"
//
// Given a list of forks to take (left, right) as well as a map of the fork
// options `START = (LEFT, RIGHT)`, traverse the tree. The list of forks to
// take may stop short; repeat it until you reach the end. Report the number of
// steps taken to reach the end point.

package main

import (
	"fmt"
	"os"
	"regexp"
	"strings"
)

const FILENAME = "sample.txt"
const DEBUG = true

var InputParser = regexp.MustCompile(`(?P<start>[A-Z]+) = \((?P<left>[A-Z]+), (?P<right>[A-Z]+)`)

type fork struct {
	L string
	R string
}

func main() {
	data, err := os.ReadFile(FILENAME)
	if err != nil {
		panic(err)
	}

	parts := strings.Split(string(data), "\n\n")

	var position string
	var destination string

	stepsTaken := 0
	steps := strings.Split(parts[0], "")

	tree := map[string]fork{}
	lines := strings.Split(strings.TrimSpace(parts[1]), "\n")

	for i, line := range lines {
		thisFork := InputParser.FindStringSubmatch(line)

		if len(thisFork) < 3 {
			continue
		}

		name := thisFork[InputParser.SubexpIndex("start")]
		left := thisFork[InputParser.SubexpIndex("left")]
		right := thisFork[InputParser.SubexpIndex("right")]

		DebugPrint("%d: %s --> %s or %s\n", i, name, left, right)
		tree[string(name)] = fork{
			L: string(left),
			R: string(right),
		}

		if i == 0 {
			position = name
		}

		if i == len(lines)-1 {
			destination = name
		}
	}

	DebugPrint("\n\nStarting at: %s\n", position)

	for i, step := range steps {
		DebugPrint("%d - %s: from %s", i, step, position)

		// `step` will be L or R, but Go sems not to like tree[position][step]...
		if step == "R" {
			position = tree[position].R
		} else if step == "L" {
			position = tree[position].L
		}
		stepsTaken++

		DebugPrint(" to %s\n", position)
	}

	DebugPrint("In %d steps, ", stepsTaken)

	if position == destination {
		DebugPrint("we arrived at ")
	} else {
		DebugPrint("we didn't make it to ")
	}

	DebugPrint("destination: %s\n", destination)
}

// Simple wrapper for debug printing
func DebugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}
