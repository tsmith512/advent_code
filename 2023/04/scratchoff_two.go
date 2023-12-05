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

	// Keep a tally of how many total copies we have of every card as an array
	// like [copies of card 1, copies of card 2, ...]
	howManyCards := []int{0}

	for scanner.Scan() {
		line := scanner.Text()

		// Parse the line into its pieces just like Part One
		matches := CardParser.FindStringSubmatch(line)
		card := NumbersFromString(matches[CardParser.SubexpIndex("card")])[0]
		winners := NumbersFromString(matches[CardParser.SubexpIndex("winners")])
		mine := NumbersFromString(matches[CardParser.SubexpIndex("mine")])

		DebugPrint("Card %d has %v (winning numbers %v)\n", card, mine, winners)

		// We know we have at least one copy of this card plus any we "won"
		if len(howManyCards) >= card {
			// We have bonus copies
			howManyCards[card-1]++
		} else {
			// We didn't start with bonuses, it's just the one
			howManyCards = append(howManyCards, 1)
		}

		thisCount := howManyCards[card-1]
		DebugPrint("You have %d copies of this card, ", thisCount)

		// For each copy of this card we have, score it
		for copy := 0; copy < thisCount; copy++ {
			bonuses := countWinners(mine, winners)

			if copy == 0 {
				DebugPrint("each granting %d bonuses.\n", bonuses)
			}

			// Divvy out the new bonuses into the array of upcoming copies.
			// (Start with index `card` because `card` is one-based)
			for i := card; i < card+bonuses; i++ {
				if len(howManyCards) > i {
					howManyCards[i]++
				} else {
					howManyCards = append(howManyCards, 1)
				}
			}
		}

		DebugPrint("Upcoming copies: %v\n\n", howManyCards)
	}

	// Now we just count up how many copies of each card we ended up with.
	totalCards := 0
	for _, i := range howManyCards {
		totalCards += i
	}

	// Part Two:
	// Total Cards: 8549735
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
