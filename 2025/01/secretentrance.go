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

		// If we ended last loop at 0, don't double-count that.
		if dial == 0 {
			iPassingZeroes--
		}

		// What are we doing this loop?
		DebugPrint("At %2d: Turn %c %3d.", dial, dir, num)

		// Spin the wheel...
		switch dir {
		case 'L':
			dial -= num
		case 'R':
			dial += num
		}

		DebugPrint(" Now at %3d", dial)

		// But make it a circle

		// How many times will we pass zero?
		// This will include stopping on a multiple of 100 (dial would be 0) but it
		// won't include if dial === 0, so count that too.
		iPassingZeroes += abs(dial / 100)
		if dial == 0 {
			iPassingZeroes++
		}

		// Where is the dial now?
		dial = dial % 100

		// If new value is less than 100, we passed 0 once more going left, wrap it
		// and count it.
		if dial < 0 {
			iPassingZeroes++
			dial = 100 + dial
		}

		// If we end on zero this loop, count it (Part 1).
		if dial == 0 {
			zeroes++ // Part One answer
		}

		DebugPrint(" -> %2d.", dial)

		// Report on ZeroMania
		if dial == 0 {
			// Landed on zero this loop
			DebugPrint(" (Stopped zeroes: %2d)", zeroes)
		}
		if iPassingZeroes > 0 {
			// Passed over zero this loop
			DebugPrint(" (Passed zero %2d times this rotation)", iPassingZeroes)
			passingZeroes += iPassingZeroes
		}
		DebugPrint("\n")
	}

	// Part One:
	// Dial at: 25.
	// Stopped at zero 1145 times.
	fmt.Printf("Dial at: %d.\nStopped at zero %d times.\n", dial, zeroes)

	fmt.Printf("Dial passed or stopped at zero %d times.\n", passingZeroes)
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
