//  ___               __   __
// |   \ __ _ _  _   /  \ / /
// | |) / _` | || | | () / _ \
// |___/\__,_|\_, |  \__/\___/
// 					 |__/
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

// FOR PART ONE, USE 4. FOR PART TWO, USE 14.
const frame = 14

func main() {
	file, err := os.Open(filename)
	if err != nil { panic(err) }
	defer file.Close()

	// Where we are. @TODO: can we get this from the file pointer?
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

func checkMark(window []byte) bool {
	duplicates := make(map[byte]bool, len(window))

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