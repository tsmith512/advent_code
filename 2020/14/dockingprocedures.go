//  ___              _ _ _
// |   \ __ _ _  _  / | | |
// | |) / _` | || | | |_  _|
// |___/\__,_|\_, | |_| |_|
// 					 |__/
//
// "Docking Data"
//
// Challenge:
// Part one is to build a map of values given numbers and "masks" to apply to
// them. After getting unstuck on some of the stuff in the instructions, Part
// One seems easy (so I assume I'm screwed for Part Two).
//
// Things I learned on Wikipedia
// Turn a thing on: Y OR 1 = 1
// Turn a thing off: Y AND 0 = 0
// If you AND with 1s, it stays the same. If you OR with 0s, it stays the same.
//
// So here's what I think I need to do:
//
// value:  00001011 -- get from decimal, read each from file
// mask:   X1XXXX0X -- use the most recently defined, and split it:
// 				 01000000 --   1s ONLY for an OR (to turn stuff ON)
// 				 11111101 --   0s ONLY for an AND (to turn stuff OFF)
// result: 01001001 -- save the number back to its "address space"
//
// And that "address space" is just its place in the storage mechanism.
//
// WARNING: The "address space" is 36-bits, each holding a 36-bit number. That's
// a lot of data. Don't use a statically allocated array or your computer melts.

package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

var filename string = "docking_sample.txt"

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

		if strings.HasPrefix(line, "mask") {
			// This line contains a replacement bitmask pair
			on, off = decodeMask(line[7:len(line)])
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

func decodeMask(mask string) (on uint64, off uint64) {
	maskOn  := strings.ReplaceAll(mask, "X", "0")
	maskOff := strings.ReplaceAll(mask, "X", "1")

	on,  _ = strconv.ParseUint(maskOn,  2, 64)
	off, _ = strconv.ParseUint(maskOff, 2, 64)

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
