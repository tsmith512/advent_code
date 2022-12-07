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
	"strings"
)

const filename string = "sample.txt"

type dirNode struct {
	parent *dirNode
	subdirs []*dirNode
	files []*fileNode
	name string
}

type fileNode struct {
	parent *dirNode
	name string
	size int
}

func newRoot(name string) *dirNode {
	dir := dirNode{name: name}
	return &dir
}

func (d *dirNode) newDir(name string) *dirNode {
	dir := dirNode{parent: d, name: name}
	d.subdirs = append(d.subdirs, &dir)
	return &dir
}

func (d *dirNode) newFile(name string, size int) *fileNode {
	file := fileNode{name: name, size: size, parent: d}
	d.files = append(d.files, &file)
	return &file
}

func (d *dirNode) dir(name string) *dirNode {
	for _, dir := range d.subdirs {
		if dir.name == name {
			return dir
		}
	}

	return nil
}

func (d *dirNode) file(name string) *fileNode {
	for _, file := range d.files {
		if file.name == name {
			return file
		}
	}

	return nil
}

func (d *dirNode) examine(args ...int) {
	var indent int
	if (len(args) > 0) {
		indent = args[0]
	} else {
		indent = 0
	}

	fmt.Printf("%s- %s/\n", strings.Repeat(" ", indent), d.name)

	for _, sub := range(d.subdirs) {
		sub.examine(indent + 2)
	}

	for _, file := range(d.files) {
		fmt.Printf("%s- %s (%d)\n", strings.Repeat(" ", indent + 2), file.name, file.size)
	}
}

func main() {
	file, err := os.Open(filename)
	if err != nil { panic(err) }
	defer file.Close()

	scanner := bufio.NewScanner(file)

	// We need to keep track of where we are...
	var workingPath []*dirNode
	var cd *dirNode

	root := newRoot("C:")
	cd = root

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
					workingPath = []*dirNode{root}
				} else if dir == ".." {
					// Back up one
					workingPath = workingPath[:len(workingPath) - 1]
				} else {
					// Go into a directory that...

					if cd.dir(dir) != nil {
						// ... already exists
						workingPath = append(workingPath, cd.dir(dir))
					} else {
						// ... doesn't exist
						workingPath = append(workingPath, cd.newDir(dir))
					}
				}

				// Now that workingPath is updated, set the cd pointer too
				cd = workingPath[len(workingPath) - 1]

			case "ls":
				// Ignore this case for now.
			}
		} else {
			// This is `ls` output denoting a new...
			var filename string
			if string(line[0:3]) == "dir" {
				// ... directory: add it to the tree
				filename = string(line[4:])
				cd.newDir(filename)
			} else {
				// ... file: get its size and add it to the tree
				rex := `(\d+) (.+)`
				captures := regexp.MustCompile(rex).FindStringSubmatch(line)
				filename = captures[2]
				filesize, err := strconv.Atoi(captures[1])

				// Sure why not
				if err != nil {
					panic(err)
				}

				cd.newFile(filename, filesize)
			}
		}
  }

	// With the full tree assembled, pretty-print it
	root.examine()
}
