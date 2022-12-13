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

	var x int = 1 // Current "addx" value
	var i int = 0 // Current step

	for scanner.Scan() {
		line := scanner.Text()

		fmt.Printf("Step %d: ", i)

		if string(line[0:4]) == "noop" {
			fmt.Printf("noop\n")
		} else if string(line[0:4]) == "addx" {
			n, err := strconv.Atoi(string(line[5:]))
			if err != nil {
				fmt.Printf("Error parsing number from line %s\n", line)
				break
			}
			x += n // YES THIS IS WRONG; need to delay this two cycles
			fmt.Printf("Current %d new %d\n", x, n)
		}

		i += 1
	}
}
