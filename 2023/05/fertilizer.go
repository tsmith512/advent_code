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

const FILENAME = "sample.txt"
const DEBUG = true

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

	for _, section := range almanacRaw[1:] {
		title, rules := AlmanacProcessor(section)

		almanac[title] = rules
	}

	for _, seed := range seeds {
		soil := AlmanacGet(almanac, "seed", "soil", seed)
		DebugPrint("For seed %d we need soil %d.\n", seed, soil)
	}
}

// Take one of the almanac sections and return its title and the integers as-is
// [input-start output-start range-length]. Don't interpolate and expand.
func AlmanacProcessor(input string) (title string, rules [][]int) {
	content := strings.Split(input, ":\n")

	title = strings.Replace(content[0], " map", "", -1)
	DebugPrint("%v\n", title)

	rows := strings.Split(content[1], "\n")

	for _, row := range rows {
		rules = append(rules, NumbersFromString(row))
	}
	DebugPrint("%v\n", rules)

	return
}

func AlmanacGet(almanac map[string][][]int, inputType string, outputType string, value int) (mappedValue int) {
	// Unless we find a match, the input is unchanged
	mappedValue = value

	section, ok := almanac[inputType+"-to-"+outputType]
	if ok {
		for _, rule := range section {
			// If the value is between input-start and input-start+range...
			if rule[0] <= value && value <= rule[0]+rule[2] {
				// determine the difference between input and output, add to the value
				mappedValue = value + (rule[0] - rule[1])
			}
		}
	} else {
		DebugPrint("We did not have a mapping for %s to %s", inputType, outputType)
	}

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
