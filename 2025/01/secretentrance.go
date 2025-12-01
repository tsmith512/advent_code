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
const DEBUG = false
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
		if dial < 0 {
			dial += 100
		} else if dial > 99 {
			dial -= 100
		}

		// NB: Separate this from the if/elif above because the wrap can make dial
		// land on zero.
		if dial == 0 {
			zeroes++ // Part One answer
		}

		DebugPrint(" Now at %d\n", dial)
	}

	fmt.Printf("Dial at: %d.\nStopped at zero %d times.\n", dial, zeroes)
}

// Simple wrapper for debug printing
func DebugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}
