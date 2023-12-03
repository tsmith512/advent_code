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

const FILENAME = "sample.txt"
const DEBUG = true

var reNumber = regexp.MustCompile(`\d+`)
var reSymbols = regexp.MustCompile(`[^0-9\.]`)

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
		debugPrint("%d: %v\n", row, partLocations)

		for _, cols := range partLocations {
			partNumber, err := strconv.Atoi(data[cols[0]:cols[1]])
			if err != nil {
				panic(err)
			}

			allParts = append(allParts, []int{partNumber, row, cols[0], cols[1]})
		}

		debugPrint("%v\n", allParts)
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

		// And if any start/end marker
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
		debugPrint("\n\nArea %v is [rows %d-%d cols %d-%d]:\n", partLoc, top, bottom, left, right)
		// Get the first two rows of the search area
		for _, text := range schematic[top:bottom] {
			field = append(field, text[left:right])
		}

		// Get the last row of the search area of `bottom` isn't out of range
		if bottom < len(schematic) {
			field = append(field, schematic[bottom][left:right])
		}

		debugPrint("%v\n", strings.Join(field, "\n"))

		// Does this field have a symbol in it that isn't a period or a digit?
		if reSymbols.MatchString(strings.Join(field, "")) {
			debugPrint("Part %d matches\n", partNumber)
			realPartNumbers = append(realPartNumbers, partNumber)
			sumRealPartNumbers += partNumber
		}
	}

	debugPrint("Real part numbers: %v\n", realPartNumbers)
	debugPrint("Sum of these numbers: %d\n", sumRealPartNumbers)
}
