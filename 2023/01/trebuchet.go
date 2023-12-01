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

// There are also sample.txt and sample2.txt
const FILENAME string = "input.txt"

// Print each line and its transformations?
const DEBUG bool = true

// In Part 2, account for digits as words
const PARTTWO bool = true

var DIGITWORDS = map[string]string{
	"one":   "1",
	"two":   "2",
	"three": "3",
	"four":  "4",
	"five":  "5",
	"six":   "6",
	"seven": "7",
	"eight": "8",
	"nine":  "9",
}

func main() {
	file, err := os.Open(FILENAME)
	if err != nil {
		panic(err)
	}

	defer file.Close()
	scanner := bufio.NewScanner(file)

	// Aggregate total
	total := 0

	digitFinder := regexp.MustCompile(`\d`)

	for scanner.Scan() {
		line := scanner.Text()

		if DEBUG {
			fmt.Printf("\nLINE: %s\n", line)
		}

		//  ___          _     ___
		// | _ \__ _ _ _| |_  |_  )
		// |  _/ _` | '_|  _|  / /
		// |_| \__,_|_|  \__| /___|
		//
		// Oh wait, some of the "digits" are actually spelled out with letters.
		// Filter for numbers and converted words, then continue like Part 1.
		if PARTTWO {
			line = digitsFromString(line)

			if DEBUG {
				fmt.Printf("  rewrite: %s\n", line)
			}
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
			fmt.Println("  digits: ", digitsAsStrings)
			fmt.Printf("  value:   [%d ... %d] --> %d\n", first, last, value)
			fmt.Printf("  %d + %d = %d\n\n", total, value, total+value)
		}

		total += value
	}

	// Part One: Sum of calibration values: 55538
	// Part Two: Sum of calibration values: 54875
	fmt.Printf("Sum of calibration values: %d\n", total)
}

// Find all digits or words in a string, repeating until there are none left.
// Return a string that joins them all to the existing Part 1 code.
// @TODO: That's dumb, just sum them and return it.
func digitsFromString(input string) string {
	index := 0
	digit := ""
	output := []string{}

	for index < len(input) {
		digit, index = getNextDigit(input, index)
		if digit != "" {
			output = append(output, digit)
		}

	}

	if DEBUG {
		fmt.Printf("  > %v\n", output)
	}

	return strings.Join(output, "")
}

// Given a string and starting index, find the left-most number (presented as a
// numerical digit or an English word) and return it and the next index to check.
func getNextDigit(input string, start int) (string, int) {
	numberFinder := regexp.MustCompile(`(\d|one|two|three|four|five|six|seven|eight|nine)`)

	if DEBUG {
		fmt.Printf("  Inspect %s from %d", input, start)
	}

	fragment := input[start:]
	index := numberFinder.FindStringIndex(fragment)

	// We didn't find a match
	if index == nil {
		if DEBUG {
			fmt.Printf(". (Done)\n")
		}
		return "", len(input)
	}

	// Get the digit either as the number or the word
	digit := fragment[index[0]:index[1]]

	// Assume a one-character string is the number, otherwise lookup the word
	if len(digit) != 1 {
		digit = DIGITWORDS[digit]
	}

	if DEBUG {
		fmt.Printf(" --> found %s at %d\n", digit, index[0]+start)
	}

	return digit, index[0] + start + 1
}
