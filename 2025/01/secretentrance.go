//  ___               __  _
// |   \ __ _ _  _   /  \/ |
// | |) / _` | || | | () | |
// |___/\__,_|\_, |  \__/|_|
//            |__/
//
// "Secret Entrance"
//
// Given a rotary dial that starts at 50 and can turn left (decrese) or right
// (increase), with a total range of 0-99. Take a list of rotations `[LR]\d`
// to spin left or right. Count the number of times the dial would stop at 0.

package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

const FILENAME = "sample.txt"
const DEBUG = true
const START = 50

func main() {
	file, err := os.Open(FILENAME)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	dial := START
	zeroes := 0 // Part One: anytime we _land_ on a zero
	passingZeroes := 0 // Part Two: anytime we _pass_ a zero

	fmt.Printf("Dial starts at %d.\n", dial)

	// Read from the input by line
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		dir := line[0]
		num, err := strconv.Atoi(line[1:])

		if err != nil {
			panic(err)
		}

		// Count how many times we pass zero this loop
		iPassingZeroes := 0

		// If we ended up zero last loop, don't double-count passing zero this loop
		if dial == 0 {
			iPassingZeroes--
		}

		DebugPrint("Turn %c %d.", dir, num)

		switch dir {
		case 'L':
			dial -= num
			break;
		case 'R':
			dial += num
			break;
		}

		// But make it a circle
		// Ah, in production input, some of the rotations are big; might loop
		// multiple times.
		for (dial < 0 || dial > 99) {
			DebugPrint("dial at %d need to wrap", dial)
			if dial != 100 {
				iPassingZeroes++ // We looped to get here
			}
			if dial < 0 {
				dial += 100
			} else if dial > 99 {
				dial -= 100
			}
		}

		if dial == 0 {
			zeroes++ // Part One answer
		}

		DebugPrint(" Now at %d.", dial)

		// Report on ZeroMania
		if dial == 0 {
			// Landed on zero this loop
			DebugPrint(" (Zeroes: %d)", zeroes)
		}
		if iPassingZeroes > 0 {
			// Passed over zero this loop
			DebugPrint(" (Passed zero %d times this rotation)", iPassingZeroes)
			passingZeroes += iPassingZeroes
		}
		DebugPrint("\n")
	}

	// Part One:
	// Dial at: 25.
	// Stopped at zero 1145 times.
	fmt.Printf("Dial at: %d.\nStopped at zero %d times.\n", dial, zeroes)

	fmt.Printf("Dial passed zero %d times (passthru %d, stopped %d).\n", passingZeroes + zeroes, passingZeroes, zeroes)
}

// Simple wrapper for debug printing
func DebugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}
