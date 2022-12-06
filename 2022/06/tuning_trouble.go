//  ___               __   __
// |   \ __ _ _  _   /  \ / /
// | |) / _` | || | | () / _ \
// |___/\__,_|\_, |  \__/\___/
//            |__/
//
// "Tuning Trouble"
//
// Given a longer-than-shit string of letters that represents a "radio signal,"
// find the "start-of-packet" marker --- the address within the string where the
// latest 4 characters are all unique. Report the one-based address of the end
// of the start marker.

package main

import (
	// "bufio"
	"fmt"
	"os"
)

const filename string = "input.txt"


//  ___          _     ___
// | _ \__ _ _ _| |_  |_  )
// |  _/ _` | '_|  _|  / /
// |_| \__,_|_|  \__| /___|
//
// For part two, report instead on the "Start of Message" marker, which is a
// similar window of unique characters, but it's a run of 14 unique characters.
// Lucky me, my Part 1 solution works for Part 2 by abstracting this to a var.
//
// FOR PART ONE, USE 4. FOR PART TWO, USE 14.
const frame = 14

func main() {
	file, err := os.Open(filename)
	if err != nil { panic(err) }
	defer file.Close()

	// Where we are, which could technically be retrieved from file.Seak(0,0) but
	// is easier just store and bring along for the ride.
	address := 0

	// Make a 1-charcter buffer so the reader only advances that much
	buffer := make([]byte, 1)

	// But our window is the most recent 4 (or, pt 2, 14)
	window := make([]byte, frame)

	for {
		n, err := file.Read(buffer)

		if err != nil {
			// assume EOF; could be something else
			break
		}

		address += n

		// Shift and push to slide the window along
		window = append(window[1:], buffer[0])

		if checkMark(window) {
			// Part One: Packet Start at 1760: msnw
			name := "Packet Start"
			// Part Two: Message Start at 2974: zjhgdqsfnwbmlc
			if frame == 14 {
				name = "Message Start"
			}
			fmt.Printf("%s at %d: %s\n", name, address, window)
			break
		}
	}
}

// Determine if the given slice of bytes contains any empty or duplicate values
func checkMark(window []byte) bool {
	// Make a map with a max-size of the frame length to record what we've seen
	duplicates := make(map[byte]bool, len(window))

	// Run through the window and check off what we've seen. If we hit a duplicate
	// or empty value, bail out.
	for _, char := range window {
		_, exists := duplicates[char]

		if char == 0 {
			// The current index in the window doesn't have anything in it, so this
			// isn't our marker. (Happens at the start or end of a file.)
			return false
		}

		if exists {
			// We knew about this character already, so it's a duplicate
			return false
		} else {
			duplicates[char] = true
		}
	}

	return true
}
