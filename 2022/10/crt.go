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

const filename string = "sample2.txt"
const cycle int = 5

func main() {
	file, err := os.Open(filename)
	if err != nil { panic(err) }
	defer file.Close()

	scanner := bufio.NewScanner(file)

	register := 1 // Current "addx" value
	i := 1 // Current step

	window := []int{0}// List of what we're gonna have to add

	for scanner.Scan() {
		line := scanner.Text()

		fmt.Printf("Cycle %d: ", i)
		fmt.Printf("register is %d", register)
		// ^^ instruction/example says "during cycle" is this value

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

		fmt.Printf(" - next value %d\n", register)
	}

	for j := range window {
		fmt.Printf("Cycle %d (runout): ", i)
		fmt.Printf("register is %d", register)
		register += window[j]
		i += 1
		fmt.Printf(" - next value %d\n", register)
	}
}
