//  ___               __  ___
// |   \ __ _ _  _   /  \| __|
// | |) / _` | || | | () |__ \
// |___/\__,_|\_, |  \__/|___/
//            |__/
//
// "If You Give A Seed A Fertilizer"
//
// ... hell if I know ... more flavor text and a complicated problem statement
// has me a little lost so I'm gonna see if I can start the string processing

package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

const FILENAME = "input.txt"
const DEBUG = true

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

	almanacRaw := strings.Split(string(data), "\n\n")

	// What seeds do we have?
	seeds := NumbersFromString(strings.Split(almanacRaw[0], ":")[1])

	DebugPrint("We have seeds: %v\n", seeds)

	// Break the rest of the almanac sections into mapped slices we can use:
	almanac := make(map[string][][]int)

	// We were tasked with finding the lowest location number
	lowestLocation := -1

	for _, section := range almanacRaw[1:] {
		title, rules := AlmanacProcessor(section)

		almanac[title] = rules
	}

	for _, seed := range seeds {
		output := AlmanacGet(almanac, INPUTTYPE, OUTPUTTYPE, seed)
		DebugPrint("For %s %d we need %s %d.\n\n", INPUTTYPE, seed, OUTPUTTYPE, output)

		if lowestLocation == -1 || output < lowestLocation {
			lowestLocation = output
		}
	}

	// Part One:
	// Lowest location seen: 51580674
	DebugPrint("Lowest location seen: %d\n", lowestLocation)
}

// Take one of the almanac sections and return its title and the integers as-is
// [input-start output-start range-length]. Don't interpolate and expand.
func AlmanacProcessor(input string) (title string, rules [][]int) {
	content := strings.Split(input, ":\n")

	title = strings.Replace(content[0], " map", "", -1)
	// DebugPrint("%v\n", title)

	rows := strings.Split(content[1], "\n")

	for _, row := range rows {
		values := NumbersFromString(row)

		// Last line in the file is blank
		if len(values) > 0 {
			rules = append(rules, values)
		}
	}
	// DebugPrint("%v\n", rules)

	return
}

func AlmanacGet(almanac map[string][][]int, inputType string, outputType string, value int) int {
	section, ok := almanac[inputType+"-to-"+outputType]
	if ok {
		for _, rule := range section {
			// If the value is between input-start and input-start+range...
			// WATCH OUT: THE OUTPUT-START IS INDEX 0 IN THAT STUPID MAP.
			if rule[1] <= value && value <= rule[1]+rule[2] {
				// determine the difference between input and output, add to the value
				diff := rule[0] - rule[1]
				DebugPrint("(diff %d) ", diff)
				value = value + diff
				break
			}
		}
	} else {
		DebugPrint("We did not have a mapping for %s to %s directly.\n", inputType, outputType)

		chain := AlmanacPaths(almanac)

		iStart := SliceIndex(chain, inputType)
		iStop := SliceIndex(chain, outputType)

		// I feel like this is dumb. There should be a way to make a slice by
		// addressing the last element in it...
		var path []string
		if iStop < len(chain) {
			path = chain[iStart : iStop+1]
		} else {
			path = chain[iStart:]
		}

		DebugPrint("So we can do that via %v\n", path)

		for i := 0; i < len(path)-1; i++ {
			DebugPrint("%s %d --> ", path[i], value)
			value = AlmanacGet(almanac, path[i], path[i+1], value)
			DebugPrint("%s %d\n", path[i+1], value)
		}
	}

	return value
}

// Given an almanac, figure out what the conversion paths are and return the
// chain of what conversions we can do
func AlmanacPaths(almanac map[string][][]int) (chain []string) {
	var mappings [][]string

	for section := range almanac {
		mappings = append(mappings, strings.Split(section, "-to-"))
	}

	// DebugPrint("Mappings we know: %v\n", mappings)

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

	DebugPrint("Conversion chain we support: %v\n", chain)

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
