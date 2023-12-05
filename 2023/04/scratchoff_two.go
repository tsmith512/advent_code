//  ___               __  _ _
// |   \ __ _ _  _   /  \| | |
// | |) / _` | || | | () |_  _|
// |___/\__,_|\_, |  \__/  |_|
//            |__/
//
// "Scratchcards"
//
// Trying to see if a Go Module will let me reuse utility functions and constants
// from the part 1 file, this feels a little messy.
//
//  ___          _     ___
// | _ \__ _ _ _| |_  |_  )
// |  _/ _` | '_|  _|  / /
// |_| \__,_|_|  \__| /___|
//
// The scoring mechanism has changed. Instead of cards being worth n^2 points,
// points are meaningless. Cards grant 1 extra copy of each subsequent card for
// the number of winning numbers they have. So if Card 1 wins 5, you get two
// copies of cards 2 through 6.
//
// How many scratch cards did you end up with in all?

package main

import (
	"bufio"
	"fmt"
	"os"
)

func PartTwo() {
	// Just restarting the whole buffer rather than trying to parallel both parts
	file, err := os.Open(FILENAME)
	if err != nil {
		panic(err)
	}

	defer file.Close()
	scanner := bufio.NewScanner(file)

	// How many cards have we scratched?
	totalCards := 0

	// Keep a tally of how many bonus copies we have of upcoming cards.
	bonusCards := []int{0}

	for scanner.Scan() {
		line := scanner.Text()

		// Parse the line into its pieces just like Part One
		matches := CardParser.FindAllStringSubmatch(line, -1)
		card := NumbersFromString(matches[0][CardParser.SubexpIndex("card")])[0]
		winners := NumbersFromString(matches[0][CardParser.SubexpIndex("winners")])
		mine := NumbersFromString(matches[0][CardParser.SubexpIndex("mine")])

		DebugPrint("Card %d has %v (winning numbers %v)\n", card, mine, winners)

		// We know we have at least one copy of this card...
		thisCount := 1

		// ... but do we have any bonus copies?
		if len(bonusCards) > 0 {
			thisCount += bonusCards[0]
		}

		DebugPrint("You have %d copies of this card. ", thisCount)

		// For each copy of this card we have, score it
		for copy := 0; copy < thisCount; copy++ {
			bonuses := countWinners(mine, winners)

			if copy == 0 {
				DebugPrint("It grants %d bonuses.\n", bonuses)
			}

			// Divvy out the new bonuses into the array we grab from in the next round.
			// Start with index 1 because index 0 is the card we're working on now.
			for i := 1; i <= bonuses; i++ {
				if len(bonusCards) > i {
					bonusCards[i]++
				} else {
					bonusCards = append(bonusCards, 1)
				}
			}

			totalCards++

		}
		DebugPrint("Upcoming bonuses: %v\n\n", bonusCards)

		// Shift the current card count out of the slice.
		// Game instructions state that the input is designed such that there will
		// NOT be any bonus cards beyond the initial stack.
		if len(bonusCards) > 0 {
			bonusCards = bonusCards[1:]
		}
	}

	fmt.Printf("Total Cards: %d\n", totalCards)
}

// Given a slice of numbers and a slice of winning numbers, count how many
// winning numbers we have
func countWinners(mine []int, winning []int) (score int) {
	score = 0

	for _, n := range mine {
		if SliceContains(winning, n) {
			score++
		}
	}

	return
}
