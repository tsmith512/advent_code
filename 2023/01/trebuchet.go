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

const FILENAME string = "sample2.txt"
const DEBUG bool = true
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
		// Oh wait, some of the "digits" are actually spelled out with letters. Swap
		// out the words with their numbers, then continue like Part 1.
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

// Find and fix digit-words in a string, repeating until there are none left.
func digitsFromLetters(input string) (output string) {
	words := true
	output = input

	for words {
		output, words = fixDigitFromLetters(output)
	}

	return
}

// Find the left-most word in an input string that is a digit and swap it out
// with the digit iself (as a string). Return the resulting string and a boolean:
// true if a substitution was made, false if none was needed (string unchanged)
func fixDigitFromLetters(input string) (string, bool) {
	numberFinder := regexp.MustCompile(`(one|two|three|four|five|six|seven|eight|nine)`)

	firstIndex := numberFinder.FindStringIndex(input)

	// Didn't find a matching word
	if len(firstIndex) == 0 {
		return input, false
	}

	// Break string into "before the first word, the word, and the rest"
	prefix := input[:firstIndex[0]]
	word := input[firstIndex[0]:firstIndex[1]]
	suffix := input[firstIndex[1]:]

	// Swap out the word for the digit is spells and return the whole string
	return prefix + DIGITWORDS[word] + suffix, true
}
