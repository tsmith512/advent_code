//  ___              _ _ _     ___          _     ___
// |   \ __ _ _  _  / | | |   | _ \__ _ _ _| |_  |_  )
// | |) / _` | || | | |_  _|  |  _/ _` | '_|  _|  / /
// |___/\__,_|\_, | |_| |_|   |_| \__,_|_|  \__| /___|
//            |__/
//
// "Docking Data"
//
// Challenge:
// Lol.
//
// Okay so the bitmask applies to the _address_ now, not the value. Apply the
// mask to the memory location just prior to writing time. Mask rules changed:
//
// Mask bit 0 -> the corresponding address bit unchanged.
// Mask bit 1 -> the corresponding address bit = 1.
// Mask bit X -> :sigh:
//
// Permute all positions marked "X" for all possible values. So the new number
// will be written to many locations:
//
// input:   000000000000000000000000000000 1 0101 0  (decimal 42)
// mask:    000000000000000000000000000000 X 1001 X
// result:  000000000000000000000000000000 X 1101 X  <-- Do each combo for X:
//          000000000000000000000000000000 0 1101 0  (decimal 26)
//          000000000000000000000000000000 0 1101 1  (decimal 27)
//          000000000000000000000000000000 1 1101 0  (decimal 58)
//          000000000000000000000000000000 1 1101 1  (decimal 59)

package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

var filename string = "docking_sample2.txt"

func main() {
	// Open the file
	file, err := os.Open(filename);
	if err != nil { panic(err) }
	defer file.Close()

	// Scan the file
	scanner := bufio.NewScanner(file)

	// Declare our bitmasks at this level so they can be used until replaced
	var mask string
	var on uint64

	// Make a map we can store assignments in
	boatMemory := make(map[uint64]uint64)

	for scanner.Scan() {
		line := scanner.Text()

		if strings.HasPrefix(line, "mask") {
			// Record a new mask string and get the ON mask (the 1s).
			mask = line[7:len(line)]
			on = getMemoryOnMask(mask)
			fmt.Printf("New mask definition: %s / %b\n", mask, on)
		} else {
			// This line is an assignment; get the new value and "starting" address
			at, val := decodeAssignment(line)
			fmt.Printf("Assign %d @ %s -> %d\n", val, mask, at)

			// @TODO: All the shit with "at"
			// new := applyMasksTo(val, on, off) // Need all the places we might store
			// boatMemory[at] = new              // Need to store in all those places.
		}
	}


	// Sum the total stored in the map.
	var total uint64 = 0

	for _, contents := range boatMemory {
		total += contents
	}

	fmt.Printf("Sum of stored numbers: %d\n", total)
}

// The 1's turn stuff on, so let's make the AND map.
func getMemoryOnMask(mask string) (on uint64) {
	maskOn  := strings.ReplaceAll(mask, "X", "0") // AND map. All the 1s are on.
	on,    _ = strconv.ParseUint(maskOn,  2, 64)

	return
}

// Unchanged from Part One.
func decodeAssignment(line string) (at uint64, val uint64) {
	parserExp := regexp.MustCompile(`\[(\d+)\] = (\d+)`)
	values := parserExp.FindStringSubmatch(line)

	at,  _ = strconv.ParseUint(values[1], 10, 64)
	val, _ = strconv.ParseUint(values[2], 10, 64)

	return
}

// Probably not needed in Part Two?
func applyMasksTo(in uint64, on uint64, off uint64) (out uint64) {
	out = (on | in) & off
	return
}
