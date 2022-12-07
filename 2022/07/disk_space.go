//  ___               __ ____
// |   \ __ _ _  _   /  \__  |
// | |) / _` | || | | () |/ /
// |___/\__,_|\_, |  \__//_/
//            |__/
//
// "No Space Left On Device"
//
// Given the console log of a directory traversal, capture the file tree
// structure, determine a mechanism for, essentially, a `du -s`. Report the sum
// total of the disk size for each directory of at MOST 100,000 units.


package main

import (
	"bufio"
	"fmt"
	"os"
  "regexp"
  "strconv"
)

const filename string = "sample.txt"

func main() {
	file, err := os.Open(filename)
	if err != nil { panic(err) }
	defer file.Close()

	scanner := bufio.NewScanner(file)

	// We need to keep track of where we are...
	var cd []string

	for scanner.Scan() {
		line := scanner.Text()

		// Process a new command mode. We need to catch and process a `cd`, and just
		// ignore an `ls` so it doesn't get interpreted as a directory member.
		if string(line[0]) == "$" {
			switch string(line[2:4]) {
			case "cd":
				dir := string(line[5:])

				if dir == "/" {
					// Root directory
					cd = []string{"/"}
				} else if dir == ".." {
					// Back up one
					cd = cd[:len(cd) - 1]
				} else {
					// Go into a new one
					cd = append(cd, dir)
				}

				fmt.Println("cd to ", cd)
			case "ls":
				fmt.Println("ls of ", cd)
			}
		} else {
			// This is `ls` output
			var filename string
			if string(line[0:3]) == "dir" {
				// It's a directory
				filename = string(line[4:])
				fmt.Printf("Directory %s\n", filename)
			} else {
				rex := `(\d+) (.+)`
				captures := regexp.MustCompile(rex).FindStringSubmatch(line)
				filename = captures[2]
				filesize, err := strconv.Atoi(captures[1])

				if err != nil {
					panic(err)
				}

				fmt.Printf("File %s of size %d\n", filename, filesize)
			}
		}
  }
}
