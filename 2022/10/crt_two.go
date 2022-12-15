//  ___              _  __    ___          _     ___
// |   \ __ _ _  _  / |/  \  | _ \__ _ _ _| |_  |_  )
// | |) / _` | || | | | () | |  _/ _` | '_|  _|  / /
// |___/\__,_|\_, | |_|\__/  |_| \__,_|_|  \__| /___|
//            |__/
//
// "Cathode-Ray Tube"
//
// Instead of determining the signal strength (cycle number * register value)
// at specific cycle numbers, use the instructions and the same processing
// pattern to determine the image that is being drawn. The register value is the
// horizontal position of a three-pixel-wide sprite. If the cycle number is part
// of the [r-1, r, r+1] set, the pixel (cycle #) "illuminates." Each row is 40
// pixels wide, 6 rows --> 240 cycles.

package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

const filename string = "sample2.txt"
const cycle int = 5

func main() {
	file, err := os.Open(filename)
	if err != nil { panic(err) }
	defer file.Close()

	scanner := bufio.NewScanner(file)

	register := 1 // Current "addx" value
	i := 1 // Current cycle (pixel in the screen)

	window := []int{0} // List of what we're gonna have to add
	screen := make([]bool, 240) // Cycle 1 draws Pixel 0

	for scanner.Scan() {
		line := scanner.Text()

		// Cycle starts with reading the line and queueing the instruction
		if string(line[0:4]) == "noop" {
			window = append(window, 0)
		} else if string(line[0:4]) == "addx" {
			n, err := strconv.Atoi(string(line[5:]))
			if err != nil {
				panic("Error parsing number")
			}
			window = append(window, n, 0)
		}

		// Then "DURING" the cycle (before anything is added), CRT draws the pixel.
		screen[i - 1] = sprite((i - 1) % 40, register)
		fmt.Printf("Cycle %3d, register starts at %2d (%s)", i, register, pixel(i, register))

		// Cycle ends by applying the next addx (or noop skip) instruction
		fmt.Printf(" adding %3d", window[0])
		register += window[0]
		window = window[1:]
		i += 1
		fmt.Printf(" -> ends at %3d\n", register)
	}

	// Do the runout.
	for j, _ := range window {
		// Stop when we're out of pixels.
		if i >= 240 {
			break
		}
		screen[i - 1] = sprite((i - 1) % 40, register)
		fmt.Printf("Cycle %3d, register starts at %2d (%s)", i, register, pixel(i, register))
		register += window[j]
		fmt.Printf(" adding %3d", window[j])
		i += 1
		fmt.Printf(" -> ends at %3d\n", register)
	}

	television(screen)
}

func sprite(n int, r int) bool {
	if r - 1 <= n && n <= r + 1 {
		return true
	}
	return false
}

func pixel(n int, r int) string {
	if sprite(n, r) {
		return "#"
	} else {
		return " "
	}
}

func television(s []bool) {
	width := 40

	for i, v := range s {
		if v {
			fmt.Printf("#")
			} else {
			fmt.Printf(".")
		}

		if (i + 1) % width == 0 {
			fmt.Printf("\n")
		}
	}
}
