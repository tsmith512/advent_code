//  ___              _ _ _
// |   \ __ _ _  _  / | | |
// | |) / _` | || | | |_  _|
// |___/\__,_|\_, | |_| |_|
// 					 |__/
//
// "Docking Data"
//
// Challenge:
// Part one is to build a map of values given numbers and "masks" to apply to
// them. After getting unstuck on some of the stuff in the instructions, Part
// One seems easy (so I assume I'm screwed for Part Two).
//
// Things I learned on Wikipedia
// Turn a thing on: Y OR 1 = 1
// Turn a thing off: Y AND 0 = 0
// If you AND with 1s, it stays the same. If you OR with 0s, it stays the same.
//
// So here's what I think I need to do:
//
// value:  00001011 -- get from decimal, read each from file
// mask:   X1XXXX0X -- use the most recently defined, and split it:
// 				 01000000 --   1s ONLY for an OR (to turn stuff on)
// 				 11111101 --   0s ONLY for an AND (to turn stuff off)
// result: 01001001 -- save the number back to its "address space"
//
// And that "address space" is just its place in the storage mechanism.
//
// WARNING: The "address space" is 36-bits, each holding a 36-bit number. That's
// a lot of data. Don't use a statically allocated array or your computer melts.

package main

import (
	"fmt"
)

func main() {
	fmt.Println("Hello, World!")
}
