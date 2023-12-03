//  ___               __ ___
// |   \ __ _ _  _   /  \_  )
// | |) / _` | || | | () / /
// |___/\__,_|\_, |  \__/___|
//            |__/
// "Cube Conundrum"
//
// Given a known number of cubes of three different colors [red, green, blue]
// determine if it's possible for given sequence of combinations to be presented.
//
// In other words, with only 12 red cubes, 13 green cubes, and 14 blue cubes is
// it possible to show `Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green`?
// For possible combinations, sum the game IDs.
//
//  ___          _     ___
// | _ \__ _ _ _| |_  |_  )
// |  _/ _` | '_|  _|  / /
// |_| \__,_|_|  \__| /___|
//
// And for part two, for each game, figure out the minimum required count of
// each color cube. Multiply these together for the game's "power," and sum
// the power total across all games (possible or not in Part 1).

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

var BAG = map[string]int{
	"red":   12,
	"green": 13,
	"blue":  14,
}

var reNumber = regexp.MustCompile(`\d+`)
var reCubes = regexp.MustCompile(`((\d+) (\w+),?)`)

func main() {
	file, err := os.Open(FILENAME)
	if err != nil {
		panic(err)
	}

	defer file.Close()
	scanner := bufio.NewScanner(file)

	// PART ONE:
	idsOfPossibleGames := []int{}
	sumIdsOfPossibleGames := 0

	// PART TWO:
	sumOfCubeCountProducts := 0

	// For each "game" (line in the input file)
	for scanner.Scan() {
		line := scanner.Text()

		game := strings.Split(line, ":")

		// PART ONE: Assume a game is possible until we find a problem.
		possible := true

		// PART TWO: Start with an empty "bag"
		gameBag := map[string]int{
			"red":   0,
			"green": 0,
			"blue":  0,
		}

		// Get the game ID
		id, err := strconv.Atoi(reNumber.FindStringSubmatch(game[0])[0])
		if err != nil {
			panic(err)
		}

		debugPrint("GAME %d\n", id)

		// Get the game's presentations
		presentations := strings.Split(game[1], ";")

		for i, str := range presentations {
			debugPrint(" - Presentation %d\n", i)

			// Determine how many we were shown of what color
			cubes := reCubes.FindAllStringSubmatch(str, -1)
			for _, color := range cubes {
				name := color[3]
				count, err := strconv.Atoi(color[2])
				if err != nil {
					panic(err)
				}

				debugPrint("   - Shown %d of %s\n", count, name)

				// PART ONE:
				if BAG[name] < count {
					debugPrint("     NOPE, you don't have this. Moving on.\n")
					possible = false
				}

				// PART TWO:
				if gameBag[name] < count {
					gameBag[name] = count
				}
			}
		}

		// PART ONE: If the game didn't get marked as impossible, add/sum its ID
		if possible {
			debugPrint(" YES, Game %d is a possible combination.\n", id)
			idsOfPossibleGames = append(idsOfPossibleGames, id)
			sumIdsOfPossibleGames += id
		}

		// PART TWO: What was the minimum of each we'd need for these combos
		debugPrint(" Minimum required cubes for this game: %v\n", gameBag)
		bagProduct := gameBag["red"] * gameBag["green"] * gameBag["blue"]
		debugPrint(" Product of these counts: %d\n", bagProduct)
		sumOfCubeCountProducts += bagProduct
	}

	// Part One:
	// Games [1 3 5 14 20 21 22 24 29 31 33 34 35 37 39 42 45 46 47 53 54 58 59 62 63 64 67 71 74 75 77 81 84 91 95 97 100] were possible. Sum of IDs: 1853
	fmt.Printf("Games %v were possible. Sum of IDs: %d\n", idsOfPossibleGames, sumIdsOfPossibleGames)

	// Part Two:
	fmt.Printf("Sum of each game's minimum cube counts multiplied: %d\n", sumOfCubeCountProducts)
}

// Simple wrapper for debug printing
func debugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}
