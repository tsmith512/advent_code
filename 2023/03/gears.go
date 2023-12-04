//  ___               __ ____
// |   \ __ _ _  _   /  \__ /
// | |) / _` | || | | () |_ \
// |___/\__,_|\_, |  \__/___/
//            |__/
//
// "Gear Ratios"
//
// Given a known number of cubes of three different colors [red, green, blue]
// determine if it's possible for given sequence of combinations to be presented.
//

package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

const FILENAME = "input.txt"
const DEBUG = false

var reNumber = regexp.MustCompile(`\d+`)
var reSymbols = regexp.MustCompile(`[^0-9\.]`)
var reAsterisk = regexp.MustCompile(`\*`)

// ^^ This is dumb, but writing a strings.Index() wrapper that supports
// multiple results would be annoying and not a lot faster at this scale.

// Simple wrapper for debug printing
func debugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}

func main() {
	file, err := os.Open(FILENAME)
	if err != nil {
		panic(err)
	}

	defer file.Close()
	scanner := bufio.NewScanner(file)

	// We can't process line-at-a-time, read the whole thing:
	var schematic []string
	for scanner.Scan() {
		schematic = append(schematic, scanner.Text())
	}

	// Find the row and start/end cols for each "part number" in the schematic:
	var allParts [][]int
	for row, data := range schematic {
		partLocations := reNumber.FindAllStringSubmatchIndex(data, -1)
		debugPrint("Input row %d:", row)

		for _, cols := range partLocations {
			partNumber, err := strconv.Atoi(data[cols[0]:cols[1]])
			if err != nil {
				panic(err)
			}

			allParts = append(allParts, []int{partNumber, row, cols[0], cols[1]})
			debugPrint(" %d at %d:%d,", partNumber, cols[0], cols[1])
		}

		debugPrint("\n")
	}

	var realPartNumbers []int
	sumRealPartNumbers := 0

	// Now for each part, find the adjacent characters:
	for _, partLoc := range allParts {
		// Make these easier to read
		partNumber := partLoc[0]
		top := partLoc[1] - 1
		bottom := partLoc[1] + 1
		left := partLoc[2] - 1
		right := partLoc[3] + 1

		// And if any start/end marker is out of bounds, crop the search area
		if top < 0 {
			top = 0
		}

		if left < 0 {
			left = 0
		}

		if right > len(schematic[0]) {
			right = len(schematic[0])
		}

		if bottom > len(schematic) {
			bottom = len(schematic)
		}

		// Something about inclusive-exclusive slicing makes doing this with a range
		// problematic. I'd like to figure out a better way to do this.
		var field []string
		debugPrint("\n\nArea %v is [rows %d-%d cols %d-%d]:\n", partNumber, top, bottom, left, right)
		// Get the first two rows of the search area
		for _, text := range schematic[top:bottom] {
			field = append(field, text[left:right])
		}

		// Get the last row of the search area if `bottom` isn't out of range
		if bottom < len(schematic) {
			field = append(field, schematic[bottom][left:right])
		}

		debugPrint("  %v\n", strings.Join(field, "\n  "))

		// Does this field have a symbol in it that isn't a period or a digit?
		if reSymbols.MatchString(strings.Join(field, "")) {
			debugPrint("  REAL\n")
			realPartNumbers = append(realPartNumbers, partNumber)
			sumRealPartNumbers += partNumber
		}
	}

	debugPrint("\n")

	// Part One:
	// Count of part numbers: 1084
	// Sum of these numbers: 539713
	fmt.Printf("Count of part numbers: %v\n", len(realPartNumbers))
	fmt.Printf("Sum of these numbers: %d\n", sumRealPartNumbers)

	//
	//  ___          _     ___
	// | _ \__ _ _ _| |_  |_  )
	// |  _/ _` | '_|  _|  / /
	// |_| \__,_|_|  \__| /___|
	//
	// Now we need to find the "gears" -- an asterisk which is adjacent to exactly
	// two part numbers. The "gear ratio" is the product of those two adjacent
	// numbers; report the sum of all the ratios.

	var allGears [][]int
	sumGearRatios := 0

	// Find the row and col for each asterisk in the schematic:
	for row, data := range schematic {
		gearLocations := reAsterisk.FindAllStringSubmatchIndex(data, -1)

		for _, cols := range gearLocations {
			allGears = append(allGears, []int{row, cols[0]})
		}
	}

	debugPrint("\nFound gears at coords:\n%v\n", allGears)

	// Cycle through each and see if there are exactly two neighboring part numbers.
	for _, gear := range allGears {
		debugPrint("\nSearching around %v\n", gear)
		var neighbors []int

		for _, part := range allParts {
			top := part[1] - 1
			bottom := part[1] + 1
			left := part[2] - 1
			right := part[3] + 1

			if top <= gear[0] && gear[0] <= bottom && left <= gear[1] && gear[1] < right {
				debugPrint("Gear at %v is a neighbor to %v\n", gear, part)
				neighbors = append(neighbors, part[0])
			}
		}

		if len(neighbors) == 2 {
			ratio := neighbors[0] * neighbors[1]
			debugPrint("Ratio: %d\n", ratio)
			sumGearRatios += ratio
		}
	}

	// Part Two:
	// Sum of all gear ratios: 84159075
	fmt.Printf("\nSum of all gear ratios: %d\n", sumGearRatios)
}
