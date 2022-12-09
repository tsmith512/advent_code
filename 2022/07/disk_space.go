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
	"sort"
	"strconv"
	"strings"
)

const filename string = "input.txt"

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

// Define a tree root (newDir without a parent)
func newRoot(name string) *dirNode {
	dir := dirNode{name: name}
	return &dir
}

// Add a subdirectory to d and mark parent/child bidirectionally
func (d *dirNode) newDir(name string) *dirNode {
	dir := dirNode{parent: d, name: name}
	d.subdirs = append(d.subdirs, &dir)
	return &dir
}

// Add a file to a directory and mark parent/child bidirectionally
func (d *dirNode) newFile(name string, size int) *fileNode {
	file := fileNode{name: name, size: size, parent: d}
	d.files = append(d.files, &file)
	return &file
}

// Retrieve a child subdirectory pointer by name, within the context of a parent
func (d *dirNode) dir(name string) *dirNode {
	for _, dir := range d.subdirs {
		if dir.name == name {
			return dir
		}
	}

	return nil
}

// Retrieve a child file pointer by name, within the context of a parent
func (d *dirNode) file(name string) *fileNode {
	for _, file := range d.files {
		if file.name == name {
			return file
		}
	}

	return nil
}

// Traverse a directory and pretty-print an indented tree of child dirs/files
// including cumulative directory sizes.
func (d *dirNode) examine(args ...int) int {
	var indent int
	var size int

	if (len(args) > 0) {
		indent = args[0]
	} else {
		indent = 0
	}

	fmt.Printf("%s- %s/\n", strings.Repeat(" ", indent), d.name)

	for _, sub := range(d.subdirs) {
		size += sub.examine(indent + 2)
	}

	for _, file := range(d.files) {
		size += file.size
		fmt.Printf("%s- %s (%d)\n", strings.Repeat(" ", indent + 2), file.name, file.size)
	}

	fmt.Printf("%s  (%s Total size: %d)\n", strings.Repeat(" ", indent + 2), d.name, size)
	return size
}

// Similar to examine() but does the weird Part 1 request of "keep a tally of
// the small directories". In the Part 1 example, both "a" and "e" were counted
// even though "e" is a subdirectory of "a," so this can be simple-ish.
func (d *dirNode) sumSmallDirectorySizes(args ...int) (size int, total int) {

	if (len(args) > 0) {
		size = args[0]
	} else {
		size = 0
	}

	// Get the total size for everything in this level:
	for _, sub := range(d.subdirs) {
		x, y := sub.sumSmallDirectorySizes()
		size += x
		total += y
	}

	for _, file := range(d.files) {
		size += file.size
	}

	if (size <= 100000) {
		total += size
	}

	return size, total
}

func main() {
	file, err := os.Open(filename)
	if err != nil { panic(err) }
	defer file.Close()

	scanner := bufio.NewScanner(file)

	// Start a tree
	root := newRoot("C:")

	// `cd` will mark where we are, start it at the root
	cd := root

	for scanner.Scan() {
		line := scanner.Text()

		// Process a new command: We need to catch and process a `cd`, and just
		// ignore an `ls` so it doesn't get interpreted as a directory member.
		if string(line[0]) == "$" {
			switch string(line[2:4]) {
			case "cd":
				dir := string(line[5:])

				if dir == "/" {
					// Root directory
					cd = root
				} else if dir == ".." {
					// Back up one
					cd = cd.parent
				} else {
					// Go into a directory that...

					if cd.dir(dir) != nil {
						// ... already exists
						cd = cd.dir(dir)
					} else {
						// ... doesn't exist
						cd = cd.newDir(dir)
					}
				}

			case "ls":
				// Ignore this case. It's the other command in the text, but doesn't
				// require any action because `cd` is set and `ls` output is assumed.
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

	// With the full tree assembled, pretty-print it because _darnit_ I'm proud of
	// this mess.
	sizeUsed := root.examine()

	// Part One: Sum of all directories less than 100,000: 1086293
	_, sizeLimited := root.sumSmallDirectorySizes()
	fmt.Printf("\n\n-- Part One:\n")
	fmt.Printf("Sum of all directories less than 100,000: %d\n", sizeLimited)

	//  ___          _     ___
	// | _ \__ _ _ _| |_  |_  )
	// |  _/ _` | '_|  _|  / /
	// |_| \__,_|_|  \__| /___|
	//
	// Given a max drive capacity of 70,000,000, and a need to have 30,000,000
	// free space, find the smallest directory that could be deleted to free up
	// the needed space.
	sizeCap := 70000000
	sizeNeeded := 30000000
	sizeFree := sizeCap - sizeUsed
	sizeNeedToFree := sizeNeeded - sizeFree
	sizeUsedPercent := (float32(sizeUsed) / float32(sizeCap) * 100)
	fmt.Printf("\n\n-- Part Two:\n")
	fmt.Printf("Currently used: %10d of %10d (%.2f%%)\n", sizeUsed, sizeCap, sizeUsedPercent)
	fmt.Printf("Space needed:   %10d\n", sizeNeeded)
	fmt.Printf("Free space:     %10d\n", sizeFree)
	fmt.Printf("Need to free:   %10d\n", sizeNeedToFree)

	_, sizesAll := root.getAllDirectorySizes()

	sort.Slice(sizesAll, func(i, j int) bool {
		return sizesAll[i].size < sizesAll[j].size
	})

	for _, report := range sizesAll {
		if report.size >= sizeNeedToFree {
			fmt.Printf("Delete %-8s(%10d) to free enough space", report.dir.name, report.size)
			fmt.Printf("\n")
			break
		}
	}

	// -- Part Two:
	// Currently used:   40358913 of   70000000 (57.66%)
	// Space needed:     30000000
	// Free space:       29641087
	// Need to free:       358913
	// Delete ptgn    (    366028) to free enough space
}

// Need to be able to note sizes of directories, but it felt weird to add that
// to the directory struct itself...
type dirSizeNote struct {
	dir *dirNode
	size int
}

// Yet another frankenfunction that travels like dirNode.examine() but builds
// a slice of all subdirs and their aggregate sizes.
func (d *dirNode) getAllDirectorySizes(args ...int) (size int, total []dirSizeNote) {

	if (len(args) > 0) {
		size = args[0]
	} else {
		size = 0
	}

	// Collect the sizes for all contained subdirectories
	for _, sub := range(d.subdirs) {
		x, y := sub.getAllDirectorySizes()
		size += x
		total = append(total, y...)
	}

	for _, file := range(d.files) {
		size += file.size
	}

	return size, append(total, dirSizeNote{ dir: d, size: size})
}
