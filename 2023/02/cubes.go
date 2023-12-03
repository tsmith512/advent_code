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

	idsOfPossibleGames := []int{}
	sumIdsOfPossibleGames := 0

	// For each "game" (line in the input file)
	for scanner.Scan() {
		line := scanner.Text()

		game := strings.Split(line, ":")

		// Assume a game is possible until we find a problem.
		possible := true

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

				// @TODO: If I could break out of the loop when a game fails, that could
				// save some cycles but named breaks were giving me trouble.
				if BAG[name] < count {
					debugPrint("     NOPE, you don't have this. Moving on.\n")
					possible = false
				}
			}
		}

		// If the game didn't get marked as impossible, add/sum its ID
		if possible {
			debugPrint(" YES, Game %d is a possible combination.\n", id)
			idsOfPossibleGames = append(idsOfPossibleGames, id)
			sumIdsOfPossibleGames += id
		}
	}

	fmt.Printf("Games %v were possible. Sum of IDs: %d\n", idsOfPossibleGames, sumIdsOfPossibleGames)
}

// Simple wrapper for debug printing
func debugPrint(template string, data ...interface{}) {
	if DEBUG {
		fmt.Printf(template, data...)
	}
}
