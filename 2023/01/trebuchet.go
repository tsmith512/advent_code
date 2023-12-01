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
)

// There are also sample.txt and sample2.txt
const FILENAME string = "input.txt"

// Print each line and its transformations?
const DEBUG bool = true

// For part two
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

var digitFinder = regexp.MustCompile(`\d`)
var numberFinder = regexp.MustCompile(`(\d|one|two|three|four|five|six|seven|eight|nine)`)

func main() {
	file, err := os.Open(FILENAME)
	if err != nil {
		panic(err)
	}

	defer file.Close()
	scanner := bufio.NewScanner(file)

	// Aggregate total
	total := 0

	for scanner.Scan() {
		line := scanner.Text()

		if DEBUG {
			fmt.Printf("\nLINE: %s\n", line)
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
	fmt.Printf("Sum of calibration values: %d\n", total)

	//  ___          _     ___
	// | _ \__ _ _ _| |_  |_  )
	// |  _/ _` | '_|  _|  / /
	// |_| \__,_|_|  \__| /___|
	//
	// Oh wait, some of the "digits" are actually spelled out with letters.
	// Rewind and filter for numbers and converted words.
	file.Seek(0, 0)
	scanner = bufio.NewScanner(file)
	total = 0

	for scanner.Scan() {
		line := scanner.Text()

		if DEBUG {
			fmt.Printf("\nLINE: %s\n", line)
		}

		digits := digitsFromString(line)
		value := (digits[0] * 10) + digits[len(digits)-1]

		if DEBUG {
			fmt.Printf("  This line: %d\n", value)
		}

		total += value
	}

	// Part Two: Sum of calibration values accounting for words: 54875
	fmt.Printf("Sum of calibration values accounting for words: %d\n", total)
}

// Find all digits or words in a string, repeating until there are none left,
// account for overlaps. Return as an array of integers.
func digitsFromString(input string) []int {
	index := 0
	digit := -1
	output := []int{}

	for index < len(input) {
		digit, index = getNextDigit(input, index)
		if digit > -1 {
			output = append(output, digit)
		}
	}

	if DEBUG {
		fmt.Printf("  > %v\n", output)
	}

	return output
}

// Given a string and starting index, find the left-most number (presented as a
// numerical digit or an English word) and return it and the next index to check.
func getNextDigit(input string, start int) (int, int) {
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
		return -1, len(input)
	}

	// Get the digit either as the number or the word
	digit := fragment[index[0]:index[1]]

	// Assume a one-character string is the number, otherwise lookup the word
	if len(digit) != 1 {
		digit = DIGITWORDS[digit]
	}

	if DEBUG {
		fmt.Printf(" --> found %s at %d\n", digit, start+index[0])
	}

	output, err := strconv.Atoi(digit)

	if err != nil {
		panic(err)
	}

	// Return the digit as an int and where it was to minimize subsequent searches
	return output, start + index[0] + 1
}
