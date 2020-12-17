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
	"math"
	"os"
	"regexp"
	"strconv"
	"strings"
)

var filename string = "docking_seq.txt"

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
		} else {
			// This line is an assignment; get the new value and "starting" address
			at, val := decodeAssignment(line)

			// How many X's are left in the mask?
			howManyXs := strings.Count(mask, "X")

			// And were we to make a binary number to account for that many digits,
			// what would its value be? (Yes, this already seems like a bad way...)
			maxVal := int(math.Exp2(float64(howManyXs)))

			// For all binary numbers 0000... --> 1111...
			for i := 0; i < maxVal; i++ {
				// What set of 1s & 0s to use for this permutation? Split to runes
				replacements := []rune(fmt.Sprintf("%0*b", howManyXs, i))

				// Get this mask variant by applying the "on mask" (for 1s) to the given
				// memory address. Then --> string --> rune list
				maskVariant := []rune(fmt.Sprintf("%036b", at | on))

				// Run over the mask string to get addresses of X's to replace into the
				// maskVariant we just determined.
				ix := 0
				for x, c := range mask {
					if (c == 'X') {
						maskVariant[x] = replacements[ix]
						ix++
					}
				}

				// And flatten the bitmasked-runereplaced back into a decimal
				at, _ := strconv.ParseUint(string(maskVariant), 2, 64)
				boatMemory[at] = val
			}
		}
	}


	// Sum the total stored in the map.
	var total uint64 = 0

	for _, contents := range boatMemory {
		total += contents
	}

	fmt.Printf("Sum of stored numbers: %d\n", total)
	// Part Two solution:
	//   Sum of stored numbers: 4275496544925
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
