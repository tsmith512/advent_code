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

const filename string = "sample.txt"
const cycle int = 5

func main() {
	file, err := os.Open(filename)
	if err != nil { panic(err) }
	defer file.Close()

	scanner := bufio.NewScanner(file)

	register := 1 // Current "addx" value
	// addxDelay := 2
	i := 1 // Current step

	window := []int{0}// List of what we're gonna have to add

	for scanner.Scan() {
		line := scanner.Text()

		fmt.Printf("Cycle %d: ", i)
		fmt.Printf("register is %d", register)

		if string(line[0:4]) == "noop" {
			fmt.Printf(" - noop - ")
			window = append(window, 0)
		} else if string(line[0:4]) == "addx" {
			n, err := strconv.Atoi(string(line[5:]))
			if err != nil {
				fmt.Printf("Error parsing number from line %s\n", line)
				break
			}
			window = append(window, n, 0)
			fmt.Printf(" - addx %d - ", n)
		}

		// Apply the addx value in the window, drop it, and push the new one
		fmt.Printf("now adding %d", window[0])
		register += window[0]
		window = window[1:]

		fmt.Printf(" - new value %d", register)
		fmt.Printf(" - window holds %#v\n", window)
		i += 1
	}

	for j := range window {
		fmt.Printf("Cycle %d: ", i)
		fmt.Printf("register is %d", register)
		fmt.Printf(" - runout - ")
		fmt.Printf("now adding %d", window[j])
		register += window[j]
		i += 1
		fmt.Printf(" - new value %d", register)
		fmt.Printf(" - window holds %#v\n", window[j + 1:])

	}
}
