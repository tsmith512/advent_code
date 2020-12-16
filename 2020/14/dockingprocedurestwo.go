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
// input:   000000000000000000000000000000101010  (decimal 42)
// mask:    000000000000000000000000000000X1001X
// result:  000000000000000000000000000000X1101X  <-- Do each combo for X:
//          000000000000000000000000000000011010  (decimal 26)
//          000000000000000000000000000000011011  (decimal 27)
//          000000000000000000000000000000111010  (decimal 58)
//          000000000000000000000000000000111011  (decimal 59)

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
	var on uint64
	var off uint64

	// Make a map we can store assignments in
	boatMemory := make(map[uint64]uint64)

	for scanner.Scan() {
		line := scanner.Text()
		println(line)

		if strings.HasPrefix(line, "mask") {
			// This line contains a replacement bitmask pair
			on, off = decodeMemoryMask(line[7:len(line)])
		} else {
			// This line is an assignment; apply mask and save
			at, val := decodeAssignment(line)
			new := applyMasksTo(val, on, off)
			boatMemory[at] = new
		}
	}
	var total uint64 = 0

	for _, contents := range boatMemory {
		total += contents
	}

	fmt.Printf("Sum of stored numbers: %d\n", total)
}

func decodeMemoryMask(mask string) (on uint64, off uint64) {
	maskOn  := strings.ReplaceAll(mask, "X", "0") // AND map. All the 1s are on.
	on,    _ = strconv.ParseUint(maskOn,  2, 64)

	// @TODO: 0's are unchanged. X's need to run all possible combos.

	on,  _ = strconv.ParseUint(maskOn,  2, 64)
	// off, _ = strconv.ParseUint(maskOff, 2, 64)

	return
}


func decodeAssignment(line string) (at uint64, val uint64) {
	parserExp := regexp.MustCompile(`\[(\d+)\] = (\d+)`)
	values := parserExp.FindStringSubmatch(line)

	at,  _ = strconv.ParseUint(values[1], 10, 64)
	val, _ = strconv.ParseUint(values[2], 10, 64)

	return
}

func applyMasksTo(in uint64, on uint64, off uint64) (out uint64) {
	out = (on | in) & off
	return
}
