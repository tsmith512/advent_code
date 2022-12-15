//  ___              _  __
// |   \ __ _ _  _  / |/  \
// | |) / _` | || | | | () |
// |___/\__,_|\_, | |_|\__/
//            |__/
//
// "Cathode-Ray Tube"
//
// Given a starting point (x = 1), a set of instructions, and keeping track of
// the cycle number where:
//
// - noop : a cycle where nothing happens
// - addx X : add (or subtract) X to/from `x` _two cycles later_
//
// Determine the "signal strength" (x * cycle number) at various points.

package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

const filename string = "input.txt"
const cycle int = 5

func main() {
	file, err := os.Open(filename)
	if err != nil { panic(err) }
	defer file.Close()

	scanner := bufio.NewScanner(file)

	register := 1 // Current "addx" value
	i := 1 // Current step

	window := []int{0} // List of what we're gonna have to add
	checking := []int{20, 60, 100, 140, 180, 220} // Cycles to report on
	saved := []int{}

	for scanner.Scan() {
		line := scanner.Text()

		if contains(checking, i) {
			fmt.Printf("Cycle %d: register is %d and signal strength is %d.\n", i, register, i * register)
			// ^^ instruction/example says "during cycle" is this; before addx

			saved = append(saved, i * register)
		}

		if string(line[0:4]) == "noop" {
			window = append(window, 0)
		} else if string(line[0:4]) == "addx" {
			n, err := strconv.Atoi(string(line[5:]))
			if err != nil {
				panic("Error parsing number")
			}
			window = append(window, n, 0)
		}

		// Apply the addx value in the window, drop it, and push the new one
		register += window[0]
		window = window[1:]
		i += 1
	}

	// Now we have to run out any remaining instructions in the window, continuing
	// the cycle count above but without input. Since we're running a range over
	// window, I'm gonna just index it with j rather than shift it (although that
	// did work correctly, it seems weird to mutate a slice while iterating it.)
	for j := range window {
		if contains(checking, i) {
			fmt.Printf("Cycle %d: register is %d and signal strength is %d.\n", i, register, i * register)
			// ^^ instruction/example says "during cycle" is this; before addx

			saved = append(saved, i * register)
		}

		register += window[j]
		i += 1
	}

	fmt.Printf("The sum of these signal strengths is %d.\n", sum(saved))

	// Part One:
	// Cycle 20: register is 21 and signal strength is 420.
	// Cycle 60: register is 24 and signal strength is 1440.
	// Cycle 100: register is 17 and signal strength is 1700.
	// Cycle 140: register is 29 and signal strength is 4060.
	// Cycle 180: register is 21 and signal strength is 3780.
	// Cycle 220: register is 21 and signal strength is 4620.
	// The sum of these signal strengths is 16020.
}

// So https://stackoverflow.com/a/71181131 says this is in an experimental lib
// available now, but I do try to see how far I can get with the stdlib first
func contains(h []int, n int) bool {
	for _, x := range h {
		if x == n {
			return true
		}
	}

	return false
}

// See above note... there's also not a good reducer? Although this isn't hard
func sum(h []int) (s int) {
	for _, v := range h {
		s += v
	}

	return
}
