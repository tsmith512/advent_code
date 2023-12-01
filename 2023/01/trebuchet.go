//  ___               __  _
// |   \ __ _ _  _   /  \/ |
// | |) / _` | || | | () | |
// |___/\__,_|\_, |  \__/|_|
//            |__/
//
// "Trebuchet?!"
//
// Decode "calibration value" from embellished (junk-filled) rows in the input.
// The first digit and last digit of a line, concat'd, make the value for that
// line. Return the sum for each value of all lines.

package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

const FILENAME string = "sample2.txt"
const DEBUG bool = true
const PARTTWO bool = true

func main() {
	file, err := os.Open(FILENAME)
	if err != nil {
		panic(err)
	}

	defer file.Close()
	scanner := bufio.NewScanner(file)

	// Aggregate total. (Just watch this need to be a bigger type for the real input...)
	total := 0

	digitFinder := regexp.MustCompile(`\d`)

	for scanner.Scan() {
		line := scanner.Text()

		if DEBUG {
			fmt.Printf("Line: %s\n", line)
		}

		//  ___          _     ___
		// | _ \__ _ _ _| |_  |_  )
		// |  _/ _` | '_|  _|  / /
		// |_| \__,_|_|  \__| /___|
		//
		// Oh wait, some of the "digits" are actually spelled out with letters.
		if PARTTWO {
			line = digitsFromLetters(line)
			fmt.Printf("Rewritten line: %s\n", line)
		}

		digitsAsStrings := digitFinder.FindAllString(line, -1)

		first, err := strconv.Atoi(digitsAsStrings[0])
		last, err := strconv.Atoi(digitsAsStrings[len(digitsAsStrings)-1])

		if err != nil {
			panic(err)
		}

		// This is the "calibration value" for the row
		value := ((first * 10) + last)

		if DEBUG {
			fmt.Println(digitsAsStrings)
			fmt.Printf("First: %d, Last: %d, Value: %d\n", first, last, value)
		}

		total += value
	}

	// Part One: Sum of calibration values: 55538
	fmt.Printf("Sum of calibration values: %d\n", total)
}

// There is probably a much cooler looking way to do this, but...
func digitsFromLetters(input string) (output string) {
	output = strings.Replace(input, "one", "1", -1)
	output = strings.Replace(output, "two", "2", -1)
	output = strings.Replace(output, "three", "3", -1)
	output = strings.Replace(output, "four", "4", -1)
	output = strings.Replace(output, "five", "5", -1)
	output = strings.Replace(output, "six", "6", -1)
	output = strings.Replace(output, "seven", "7", -1)
	output = strings.Replace(output, "eight", "8", -1)
	output = strings.Replace(output, "nine", "9", -1)
	return
}
