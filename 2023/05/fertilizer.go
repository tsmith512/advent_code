//  ___               __  ___
// |   \ __ _ _  _   /  \| __|
// | |) / _` | || | | () |__ \
// |___/\__,_|\_, |  \__/|___/
//            |__/
//
// "If You Give A Seed A Fertilizer"
//
// Given a set of starting numbers (seeds) and a series of translation mappings
// (e.g. seed-to-soil, soil-to-fertilizer, ..., -to-location) determine the
// lowest value for "location" (final translation map type) given the inputs.

package main

import (
	"errors"
	"fmt"
	"os"
	"strconv"
	"strings"
)

const FILENAME = "sample.txt"
const DEBUG = false
const DO_PART_TWO = true

const INPUTTYPE = "seed"
const OUTPUTTYPE = "location"

// Simple wrapper for debug printing
func DebugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}

func main() {
	data, err := os.ReadFile(FILENAME)
	if err != nil {
		panic(err)
	}

	DebugPrint("SETUP:\n")

	almanacRaw := strings.Split(string(data), "\n\n")

	// We were tasked with finding the lowest location number
	lowestLocation := -1

	// What seed numbers do we have?
	seeds := NumbersFromString(strings.Split(almanacRaw[0], ":")[1])
	DebugPrint("We have seeds: %v\n", seeds)

	// ## ALMANAC PROCESSING ## //

	// Break the rest of the almanac sections into mapped slices we can use:
	almanac := make(map[string][][]int)
	for _, section := range almanacRaw[1:] {
		title, rules := AlmanacProcessor(section)

		almanac[title] = rules
	}

	// Obviously, input-to-output isn't going to be doable directly, find the
	// order of types we can map directly into a chain:
	chain := AlmanacPaths(almanac)
	DebugPrint("Possible translations: %v\n", chain)

	// What translaitons are we gonna have to make?
	iStart := SliceIndex(chain, INPUTTYPE)
	iStop := SliceIndex(chain, OUTPUTTYPE)

	// I feel like this is dumb. There should be a way to make a slice by
	// inclusively addressing the last element in it...
	var path []string
	if iStop < len(chain) {
		path = chain[iStart : iStop+1]
	} else {
		path = chain[iStart:]
	}

	DebugPrint("Translation chain for requested types: %v\n", path)

	DebugPrint("\n\nPART ONE:\n")

	// For each seed input, figure out the requested output, track the lowest
	for _, seed := range seeds {
		value := seed

		// Mark our input and start:
		DebugPrint("%s %d ", path[0], value)

		// For each step in the chain, do a conversion we know until we have the
		// requested output type
		for i := 0; i < len(path)-1; i++ {
			value, err = AlmanacGet(almanac, path[i], path[i+1], value)

			// We asked for a translation we can't map directly
			if err != nil {
				panic(err)
			}

			DebugPrint("> %s %d ", path[i+1], value)
		}
		DebugPrint("\n")

		if lowestLocation == -1 || value < lowestLocation {
			lowestLocation = value
		}
	}

	// Part One:
	// Lowest location seen: 51580674
	fmt.Printf("Lowest location seen: %d\n\n", lowestLocation)

	if !DO_PART_TWO {
		return
	}

	//  ___          _     ___
	// | _ \__ _ _ _| |_  |_  )
	// |  _/ _` | '_|  _|  / /
	// |_| \__,_|_|  \__| /___|
	//
	// Oh good. The seeds input array isn't an array of seeds, it was a series of
	// touples describing start and length of seed RANGES. I assume I should
	// NOT brute force this, but I'm gonna.
	DebugPrint("\n\nPART TWO:\n")

	// Reset
	lowestLocation = -1

	// For each pair of input numbers...
	for i := 0; i < len(seeds); i += 2 {
		startSeed := seeds[i]
		plantHowMany := seeds[i+1]
		DebugPrint("Set %d (start at %d and plant %d)\n", i, startSeed, plantHowMany)

		// For each seed in the range
		for s := 0; s <= plantHowMany; s++ {
			value := startSeed + s

			// Mark our input and start type:
			DebugPrint("%s %d ", path[0], value)

			// For each step in the chain, do a conversion we know until we have the
			// requested output type
			for step := 0; step < len(path)-1; step++ {
				value, err = AlmanacGet(almanac, path[step], path[step+1], value)

				// We asked for a translation we can't map directly
				if err != nil {
					panic(err)
				}

				DebugPrint("> %s %d ", path[step+1], value)
			}
			DebugPrint("\n")

			if lowestLocation == -1 || value < lowestLocation {
				lowestLocation = value
			}
		}
	}

	// WRONG ANSWER: This answer is too high, but it's what I keep getting...
	// Lowest location seen when considering seeds as ranges: 99751241
	// real    59m45.991s
	// user    62m59.411s
	// sys     1m54.714s
	//
	// STILL THE WRONG ANSWER but by getting "figure-out-translation-path" out of
	// the loop and doing it ahead of time, I reduced the time it took to get the
	// wrong answer by about 80%.
	// Lowest location seen when considering seeds as ranges: 99751241
	// real    10m9.755s
	// user    10m10.148s
	// sys     0m0.664s
	fmt.Printf("Lowest location seen when considering seeds as ranges: %d\n\n", lowestLocation)
}

// Take one of the almanac sections and return its title and the integers as-is
// [output-start input-start range-length]. Don't interpolate and expand.
func AlmanacProcessor(input string) (title string, rules [][]int) {
	content := strings.Split(input, ":\n")

	title = strings.Replace(content[0], " map", "", -1)

	rows := strings.Split(content[1], "\n")

	for _, row := range rows {
		values := NumbersFromString(row)

		// Last line in the file is blank
		if len(values) > 0 {
			rules = append(rules, values)
		}
	}

	return
}

func AlmanacGet(almanac map[string][][]int, inputType string, outputType string, value int) (int, error) {
	section, ok := almanac[inputType+"-to-"+outputType]
	if ok {
		for _, rule := range section {
			// If the value is between input-start and input-start+range...
			// WATCH OUT: THE OUTPUT-START IS INDEX 0 IN THAT STUPID MAP.
			if rule[1] <= value && value <= rule[1]+rule[2] {
				// determine the difference between input and output, add to the value
				diff := rule[0] - rule[1]
				DebugPrint("(%d)", diff)
				value = value + diff
				break
			}
		}
	} else {
		return -1, errors.New("No mapping from " + inputType + "-to-" + outputType)
	}

	return value, nil
}

// Given an almanac, figure out what the conversion paths are and return the
// chain of what conversions we can do
func AlmanacPaths(almanac map[string][][]int) (chain []string) {
	var mappings [][]string

	for section := range almanac {
		mappings = append(mappings, strings.Split(section, "-to-"))
	}

	// We know we start with seeds.
	chain = append(chain, "seed")
	for len(chain) <= len(mappings) {
		last := chain[len(chain)-1]

		for _, mapping := range mappings {
			if mapping[0] == last {
				chain = append(chain, mapping[1])
			}
		}
	}

	// DebugPrint("Conversion chain we support: %v\n", chain)

	return
}

// Given a string with spaces and numbers, return a slice of the integers
func NumbersFromString(input string) (output []int) {
	pieces := strings.Split(input, " ")

	for _, s := range pieces {
		s = strings.TrimSpace(s)

		if len(s) == 0 {
			continue
		}

		n, err := strconv.Atoi(s)

		if err != nil {
			panic(err)
		}

		output = append(output, n)
	}

	return
}

// Utility function to find left-most string in a slice of strings
func SliceIndex(haystack []string, needle string) int {
	for i, h := range haystack {
		if h == needle {
			return i
		}
	}
	return -1
}
