//  ___               __  _ _
// |   \ __ _ _  _   /  \| | |
// | |) / _` | || | | () |_  _|
// |___/\__,_|\_, |  \__/  |_|
//            |__/
//
// "Scratchcards"
//
// Given a list of cards in the format `Card X: NN NN NN | MM MM MM`. Winning
// numbers you NEED are left of the separator, numbers you HAVE are on the right.
// Determine which numbers you have that are in the list. The first match is
// worth 1 point, each subsequent match doubles the points.

package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

const FILENAME = "sample.txt"
const DEBUG = true

// Simple wrapper for debug printing
func debugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}

func main() {
	file, err := os.Open(FILENAME)
	if err != nil {
		panic(err)
	}

	defer file.Close()
	scanner := bufio.NewScanner(file)

	totalScore := 0

	// For each "scratch card" (line in the input file)
	for scanner.Scan() {
		line := scanner.Text()

		// Parse the line into its pieces
		re := regexp.MustCompile(` (?P<card>\d+):  ?(?P<winners>(\d+\s*)+)\|  ?(?P<mine>(\d+\s*)+)`)
		matches := re.FindAllStringSubmatch(line, -1)

		// And convert the strings into int and []int
		card := numbersFromString(matches[0][re.SubexpIndex("card")])[0]
		winners := numbersFromString(matches[0][re.SubexpIndex("winners")])
		mine := numbersFromString(matches[0][re.SubexpIndex("mine")])
		score := scratchTheCard(mine, winners)

		totalScore += score

		debugPrint("Card %d has %v (winning numbers %v)\n", card, mine, winners)
		debugPrint("Score: %d\n\n", score)
	}

	fmt.Printf("Total Score: %d\n", totalScore)
}

// Given a string with spaces and numbers, return a slice of the integers
func numbersFromString(input string) (output []int) {
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

	debugPrint("%v", output)
	return
}

// Utility function to find an int in a slide of ints
func sliceContains(haystack []int, needle int) bool {
	for _, h := range haystack {
		if h == needle {
			return true
		}
	}
	return false
}

// Given a slice of numbers and a slice of winning numbers, score the card
func scratchTheCard(mine []int, winning []int) (score int) {
	score = 0

	for _, n := range mine {
		if sliceContains(winning, n) {
			if score == 0 {
				score = 1
			} else {
				score *= 2
			}
		}
	}

	return
}
