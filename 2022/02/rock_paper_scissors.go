//  ___               __ ___
// |   \ __ _ _  _   /  \_  )
// | |) / _` | || | | () / /
// |___/\__,_|\_, |  \__/___|
// 					 |__/
// "Rock Paper Scissors"
//
// You're given instructions for a rock paper scissors tournament
// so you know what you should play and in what order.
//
// Column 1: opponent will play A (Rock), B (Paper), C (Scissors)
// Column 2: you should respond with X (Rock), Y (Paper), Z (Scissors)
//
// Scoring for each round is:
// - Your play (Rock = 1; Paper = 2; Scissors = 3)
// - PLUS Outcome (Loss = 0; Draw = 3; Win = 6)

package main

import (
	"bufio"
	"fmt"
	"os"
)

const filename string = "sample.txt"

const ROCK = 1
const PAPER = 2
const SCISSORS = 3

var moveCodes = map[string]int {
	"A": ROCK,
	"B": PAPER,
	"C": SCISSORS,
	"X": ROCK,
	"Y": PAPER,
	"Z": SCISSORS,
}

var moveNames = []string {
	"ROCK", "PAPER", "SCISSORS",
}

func main() {
	file, err := os.Open(filename)
	if err != nil { panic(err) }
	defer file.Close()

	scanner := bufio.NewScanner(file)
	total := 0

	for scanner.Scan() {
		line := scanner.Text()
		them := moveCodes[string(line[0])]
		me   := moveCodes[string(line[2])]

		points, explaination := score(them, me)
		total += points
		fmt.Printf("%-8s vs %8s -> %-7s %d points.\n", label(them), label(me), explaination, points)
	}

	fmt.Printf("Total score: %d\n", total)
}

func score (them int, me int) (points int, explain string) {
	// Score "my" part
	points = me

	// Who won?
	if them == me {
		explain = "Draw."
		points += 3
	} else if ((them + 1) % 3) == me {
		explain = "I won."
		points += 6
	} else {
		// Loss; points unchanged
		explain = "I lost."
	}

	return
}

func label (move int) string {
	return moveNames[move - 1]
}
