//  ___               __   __
// |   \ __ _ _  _   /  \ / /
// | |) / _` | || | | () / _ \
// |___/\__,_|\_, |  \__/\___/
//            |__/
//
// "Wait for It"
//
// In a simulated boatrace, you are given a deadline and a distance to cover.
// The "boat" will only move by being charged after the race starts. For each
// ms of "charge time" afte race start, the boat's movement speed increases by
// one mm per ms. Thus, the first sample (7ms, 9mm) can be achieved several ways:
//
// - 1 ms charge --> 6 ms travel @ 1 --> 6mm (fail)
// - 2 ms charge --> 5 ms travel @ 2 --> 10mm
// - 3 ms charge --> 4 ms travel @ 3 --> 12mm
// - 4 ms charge --> 3 ms travel @ 4 --> 12mm
// - 5 ms charge --> 2 ms travel @ 5 --> 10mm
// - 6 ms charge --> 1 ms travel @ 6 --> 6mm (fail)
//
// Charge values lower or higher don't leave enough travel time or speed.
//
// Determine how many ways there are to win each race, multiply these.

package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

const FILENAME = "sample.txt"
const DEBUG = true

var InputParser = regexp.MustCompile(`((\d+\s*)+)`)

func main() {
	data, err := os.ReadFile(FILENAME)
	if err != nil {
		panic(err)
	}

	pieces := InputParser.FindAllStringSubmatch(string(data), -1)

	times := NumbersFromString(pieces[0][0])
	distances := NumbersFromString(pieces[1][0])

	DebugPrint("Race times: %v\n", times)
	DebugPrint("Race distances: %v\n\n", distances)

	var options []int

	for i := 0; i < len(times); i++ {
		min, max := RaceSolver(times[i], distances[i])

		option := max - min + 1 // (+1 because the range is inclusive)
		options = append(options, option)

		DebugPrint("So we have %d options\n\n", option)
	}

	product := options[0]

	for j := 1; j < len(options); j++ {
		product *= options[j]
	}

	fmt.Printf("Across %d races, a combined product of %d possible options.\n", len(times), product)
}

// Given time and distance, return the min and max charge times
func RaceSolver(time int, distance int) (minCharge int, maxCharge int) {
	DebugPrint("Race to %d mm in less than %d ms.\n", distance, time)

	// To "win" a race, we need travel time at travel speed to be > distance.
	// charge time == travel speed -> X
	// distance traveled = (time - X) * X

	// I feel like this would be easy if I had taken calculus, but instead let's
	// search from the outside inward and stop when we get a working combo.

	for maxCharge = time - 1; maxCharge > 0; maxCharge-- {
		X := maxCharge
		if ((time - X) * X) > distance {
			break
		}
	}

	for minCharge = 1; minCharge < time; minCharge++ {
		X := minCharge
		if ((time - X) * X) > distance {
			break
		}
	}

	DebugPrint("Max charge: %d. Min charge: %d.\n", maxCharge, minCharge)

	return
}

// Simple wrapper for debug printing
func DebugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}

// Given a string with spaces and numbers, return a slice of the integers
func NumbersFromString(input string) (output []int) {
	pieces := strings.Split(input, " ")

	for _, s := range pieces {
		s = strings.TrimSpace(s)

		if len(s) == 0 {
			continue
		}

		n, err := strconv.Atoi(s)

		if err != nil {
			panic(err)
		}

		output = append(output, int(n))
	}

	return
}
