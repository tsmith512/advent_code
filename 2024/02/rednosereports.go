//  ___               __ ___
// |   \ __ _ _  _   /  \_  )
// | |) / _` | || | | () / /
// |___/\__,_|\_, |  \__/___|
//            |__/
//
// "Red-Nose Reports"
//
// Given an input of "reports" (lines) each with numeric values for "levels"
// (space-separated digits), find the ones that are "safe." That is:
// - All "levels" are in ascending or descending order
// - Any adjacent "levels" are 1 - 3 (inclusive) numbers apart

package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

const FILENAME = "sample.txt"
const DEBUG = true

func main() {
	var reports [][]int

	file, err := os.Open(FILENAME)
	if err != nil {
		panic(err)
	}
	defer file.Close()

	// Process input and get the reports with each level
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		digits := strings.Split(line, " ")

		report := make([]int, 5)

		for i, v := range digits {
			n, err := strconv.Atoi(v)

			if err != nil {
				panic(err)
			}

			report[i] = n
		}

		reports = append(reports, report)
	}

	safeReports := 0

REPORTS:
	for i, report := range reports {
		DebugPrint("Report %d: %v\n", i, report)

		// Assume safe and check
		safe := true

		if sort.IntsAreSorted(report) {
			DebugPrint("- #%d is ordered.\n", i)
		} else {
			rev := ReverseInts(report)
			if sort.IntsAreSorted(rev) {
				DebugPrint("- #%d is reverse-ordered.\n", i)
			} else {
				DebugPrint("- NO: #%d is out of order.\n", i)
				safe = false
				continue
			}
		}

	DIGITS:
		for j, n := range report {
			DebugPrint("- %d:%d = %d\n", i, j, n)
			if j == 0 {
				continue DIGITS
			} else {
				d := report[j-1] - n
				if d < 0 {
					d = -d
				}

				if d < 1 || 3 < d {
					DebugPrint("  NO: report %d indexes %d (%d) and %d (%d) off by %d.\n", i, j, report[j], j-1, report[j-1], d)
					safe = false
					continue REPORTS
				}
			}
		}

		if safe {
			DebugPrint("  YES: Report %d is safe.\n", i)
			safeReports++
		}
	}

	fmt.Printf("Total safe reports: %d\n", safeReports)
}

func ReverseInts(x []int) []int {
	out := make([]int, len(x))

	for i, v := range x {
		out[len(x)-i-1] = v
	}

	return out
}

// Simple wrapper for debug printing
func DebugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}
