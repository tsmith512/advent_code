//  ___               __ ____
// |   \ __ _ _  _   /  \__  |
// | |) / _` | || | | () |/ /
// |___/\__,_|\_, |  \__//_/
//            |__/
//
// "Camel Cards"
//
// Given a list of "camel cards" (poker) hands and bids (bets), sort and score
// the hands, determine total winnings based on the bids.
//
// - Cards are in order in the string they're presented
// - Card rank (desc): A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, 2
// - No suits
// - Hands are scored first by type: 5X, 4X, FH, 3X, 2P, 1P, HC
//   and then by the value of which card is _first in the hand_ (then second, ...)

package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

const FILENAME = "input.txt"
const DEBUG = true
const PART_TWO = true // Part 2 makes some scoring changes

const HAND_SIZE = 5

var CardValues = map[string]int{
	"2": 2,
	"3": 3,
	"4": 4,
	"5": 5,
	"6": 6,
	"7": 7,
	"8": 8,
	"9": 9,
	"T": 10,
	"J": 11,
	"Q": 12,
	"K": 13,
	"A": 14,
}

var HandRank = map[string]int{
	"5X": 7,
	"4X": 6,
	"FH": 5,
	"3X": 4,
	"2P": 3,
	"1P": 2,
	"HC": 1,
}

type hand struct {
	cards    string // The string of what cards are in a hand
	category string // The type of a hand ("type" is a reserved word)
	bid      int    // the initial bid (bet) on the hand
}

var InputParser = regexp.MustCompile(`([A-Z0-9]+) (\d+)`)

func main() {
	if PART_TWO {
		// In part two, this is a Joker, not a Jack, with a value of 1 on its own,
		// but it's wild.
		CardValues["J"] = 1
	}

	file, err := os.Open(FILENAME)
	if err != nil {
		panic(err)
	}

	defer file.Close()
	scanner := bufio.NewScanner(file)

	var hands []hand

	// For each "scratch card" (line in the input file)
	for scanner.Scan() {
		line := scanner.Text()

		data := InputParser.FindStringSubmatch(line)

		bid, err := strconv.Atoi(data[2])
		if err != nil {
			panic(err)
		}

		cat := Categorize(data[1])
		if err != nil {
			panic(err)
		}

		DebugPrint("Hand: %s | Category: %s | Bid: %d\n", data[1], cat, bid)

		hand := hand{
			cards:    data[1],
			category: cat,
			bid:      bid,
		}

		hands = append(hands, hand)
	}

	DebugPrint("\n\n")

	// Sort the hands array so we can determine the winnings:
	sort.SliceStable(hands, func(i int, j int) bool {
		// If they are different category hands, we know their rank
		if HandRank[hands[i].category] != HandRank[hands[j].category] {
			return HandRank[hands[i].category] < HandRank[hands[j].category]
		}

		// Would this be easier of a hand.cards was a []rune instead?
		iCards := strings.Split(hands[i].cards, "")
		jCards := strings.Split(hands[j].cards, "")

		// The cards are pre-sorted and the instructions say to evaluate them in
		// order, so return the sorter boolean on the first pair of cards that differ
		for k, _ := range iCards {
			if iCards[k] != jCards[k] {
				return CardValues[iCards[k]] < CardValues[jCards[k]]
			}
		}

		// If we made it here, the hands were identical...
		return false
	})

	var totalWinnings int
	for i, h := range hands {
		winnings := (i + 1) * h.bid
		DebugPrint("#%d: %v --> %d\n", i+1, h, winnings)

		totalWinnings += winnings
	}

	// Part One:
	// Total winnings: 248569531
	//
	// Part Two:
	// Total winnings: 250382098
	fmt.Printf("Total winnings: %d\n", totalWinnings)
}

// Given a card string, determine what type/category a hand falls into.
func Categorize(cards string) string {
	// Count up how many of each rank card we have:
	var cardCounts = map[string]int{}
	for _, c := range strings.Split(cards, "") {
		cardCounts[c] += 1
	}

	// We can't sort a map, so sort the cards we have by how many we have
	keys := make([]string, 0, len(cardCounts))
	for key := range cardCounts {
		keys = append(keys, key)
	}
	sort.SliceStable(keys, func(i int, j int) bool {
		if !PART_TWO {
			return cardCounts[keys[i]] > cardCounts[keys[j]]
		}

		// In part two, we'll also want to order the keys by their card value
		// in the case of a tie. (e.g. if we have 2x K and 2x Q, we'd want to apply
		// any wild cards we get to the Ks.)
		if cardCounts[keys[i]] == cardCounts[keys[j]] {
			return CardValues[keys[i]] > CardValues[keys[j]]
		}

		return cardCounts[keys[i]] > cardCounts[keys[j]]
	})

	if PART_TWO {
		j := SliceIndex(keys, "J")

		if j == 0 {
			// Okay we have more Jokers than anything else
			DebugPrint("%s: %#v\n", cards, cardCounts)

			// If all we have is jokers, then leave it as-is. Otherwise, shift all the
			// jokers to whatever we have the next-most of.
			if len(keys) > 1 {
				cardCounts[keys[1]] += cardCounts[keys[j]]
				keys = keys[1:]
			}
		}
		if j > 0 {
			// Make jokers count for the card we had the most of
			cardCounts[keys[0]] += cardCounts[keys[j]]
			keys = append(keys[:j], keys[j+1:]...)
		}
	}

	if cardCounts[keys[0]] == 5 {
		return "5X"
	} else if cardCounts[keys[0]] == 4 {
		return "4X"
	} else if cardCounts[keys[0]] == 3 && cardCounts[keys[1]] == 2 {
		return "FH"
	} else if cardCounts[keys[0]] == 3 {
		return "3X"
	} else if cardCounts[keys[0]] == 2 && cardCounts[keys[1]] == 2 {
		return "2P"
	} else if cardCounts[keys[0]] == 2 {
		return "1P"
	} else {
		return "HC"
	}
}

// Simple wrapper for debug printing
func DebugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}

// Utility function to find left-most string in a slice of strings
func SliceIndex(haystack []string, needle string) int {
	for i, h := range haystack {
		if h == needle {
			return i
		}
	}
	return -1
}
