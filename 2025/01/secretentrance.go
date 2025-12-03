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

const FILENAME = "input.txt"
const DEBUG = true
const START = 50

func main() {
	file, err := os.Open(FILENAME)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	dial := START
	zeroes := 0        // Part One: anytime we _land_ on a zero
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

		// Count how many times we pass on OR STOP ON zero this loop (Part 2)
		iPassingZeroes := 0

		DebugPrint("At %2d: Turn %c %3d.", dial, dir, num)

		// Spin the wheel...
		// DAMMIT: I did this three different ways that all didn't work somehow so
		// here's the dumb way to do it. And I swear...
		switch dir {
		case 'L':
			for num > 0 {
				dial--
				num--

				// OKAY HERE'S WHAT DID IT:
				// 0 & 100 are the same (see case 'R' below), but 0 and 99 are NOT. Need
				// to count the 0 when we hit it, but handle the wrap on -1.
				if dial == 0 {
					iPassingZeroes++
				} else if dial == -1 {
					dial = 99
				}
			}
		case 'R':
			for num > 0 {
				dial++
				num--

				if dial == 100 {
					dial = 0
					iPassingZeroes++
				}
			}
		}

		// Part 1: Count how often we land on zero
		if dial == 0 {
			zeroes++
		}

		// Part 2: Count how often we point at zero.
		// This will double-count stopping at zero, so do NOT add Part 1 + Part 2.
		passingZeroes += iPassingZeroes

		DebugPrint(" Now at %3d", dial)

		// Report on ZeroMania
		if dial == 0 {
			DebugPrint(" (Zeroes: %2d)", zeroes)
		}
		if iPassingZeroes > 0 {
			// Passed over zero this loop
			DebugPrint(" (Pointed at zero %2d times this rotation)", iPassingZeroes)
		}
		DebugPrint("\n")
	}

	// Part One:
	// Dial at: 25.
	// Stopped at zero 1145 times.
	fmt.Printf("Dial at: %d.\nStopped at zero %d times.\n", dial, zeroes)

	// Dial pointed at zero 6561 times.
	fmt.Printf("Dial pointed at zero %d times.\n", passingZeroes)
}

// Handle absolute value of an int
func abs(input int) int {
	if input < 0 {
		return -input
	}
	return input
}

// Simple wrapper for debug printing
func DebugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}
