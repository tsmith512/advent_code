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
	zeroes := 0

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
		// Ah, in production input, some of the rotations are big; might loop =
		// multiple times.
		for (dial < 0 || dial > 99) {
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

		// Keep count of the zeroes
		if dial == 0 {
			DebugPrint(" (Zeroes: %d)\n", zeroes)
		} else {
			DebugPrint("\n")
		}
	}


	// Part One:
	// Dial at: 25.
	// Stopped at zero 1145 times.
	fmt.Printf("Dial at: %d.\nStopped at zero %d times.\n", dial, zeroes)
}

// Simple wrapper for debug printing
func DebugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}
