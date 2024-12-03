//  ___               __  _
// |   \ __ _ _  _   /  \/ |
// | |) / _` | || | | () | |
// |___/\__,_|\_, |  \__/|_|
// 					 |__/
//
// "Historian Hysteria"
//
// Given two lists of numbers (where each lines[] --> listA[]   listB[]), pair
// the numbers in the left and right lists in ascending order. Within each pair
// get the difference between the pair and sum all differences.

package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"sort"
	"strconv"
)

const FILENAME = "input.txt"
const DEBUG = true

var InputParser = regexp.MustCompile(`(\d+)\s+(\d+)`)

func main() {
	file, err := os.Open(FILENAME)

	var listA []int
	var listB []int

	if err != nil {
		panic(err)
	}

	defer file.Close()
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		line := scanner.Text()
		data := InputParser.FindStringSubmatch(line)

		a, err := strconv.Atoi(data[1])
		if err != nil {
			panic(err)
		}

		b, err := strconv.Atoi(data[2])
		if err != nil {
			panic(err)
		}

		listA = append(listA, a)
		listB = append(listB, b)
	}

	sort.Ints(listA)
	sort.Ints(listB)

	DebugPrint("Sorted lists: \n%v\n%v\n", listA, listB)

	var diffs []int
	sumDiff := 0

	for i := 0; i < len(listA); i++ {
		diff := listB[i] - listA[i]

		// Ah ha. Sample didn't have negative differences.
		if diff < 0 {
			diff = -diff
		}

		sumDiff += diff
		diffs = append(diffs, diff)
	}

	DebugPrint("Differences: %v\n", diffs)

	fmt.Printf("Sum of differences between pairs: %d\n", sumDiff)
	// Part One:
	// Sum of differences between pairs: 2430334
}

// Simple wrapper for debug printing
func DebugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}
