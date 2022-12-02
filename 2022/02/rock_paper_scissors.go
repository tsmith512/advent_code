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
	var total uint64 = 0

	for scanner.Scan() {
		line := scanner.Text()
		them := moveCodes[string(line[0])]
		me   := moveCodes[string(line[2])]

		points, explaination := score(them, me)
		total += uint64(points)
		fmt.Printf("%-8s vs %8s -> %-7s %d points.\n", label(them), label(me), explaination, points)
	}

	// Part One: Total score: 11603
	fmt.Printf("Total score: %d\n", total)

  //  ___          _     ___
  // | _ \__ _ _ _| |_  |_  )
  // |  _/ _` | '_|  _|  / /
  // |_| \__,_|_|  \__| /___|
	//
	// Actually Column 2 describes not _what_ you should play, but how you should
	// make the round end.
	//
	// X = Play to lose
	// Y = Draw
	// Z = Play to win

	file.Seek(0, 0)
	scanner = bufio.NewScanner(file)
	total = 0

	for scanner.Scan() {
		line := scanner.Text()

		// Their move uses the same logic.
		them := moveCodes[string(line[0])]

		// My move is now determined by how I'm supposed to play
		me, intention := how(them, string(line[2]))

		// And this is the same from Part 1
		points, explaination := score(them, me)
		total += uint64(points)

		// But include the intention anyway.
		fmt.Printf("%-20s %-8s vs %8s -> %-7s %d points.\n", intention, label(them), label(me), explaination, points)
	}

	fmt.Printf("Total score, part 2: %d\n", total)
}

func score (them int, me int) (points int, explain string) {
	// Score "my" part
	points = me

	// Who won?
	if them == me {
		explain = "Draw."
		points += 3
	} else if ((them + 1) % 3) == (me % 3) {
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

func how (them int, goal string) (me int, explain string) {
	// Modulo in Go doesn't work on negative ints, so bump this up so we end up
	// with 3, 4, or 5, which (x % 3) => 0, 1, or 2.
	them += 2

	switch goal {
	case "X":
		explain = "Intentionally lose."
		me = (them - 1) % 3
	case "Y":
		explain = "Seek a draw."
		me = them % 3
	case "Z":
		explain = "Play to win."
		me = (them + 1) % 3
	}

	// The existing scoring function expects `me` to be a 1-based code
	me += 1

	return
}
