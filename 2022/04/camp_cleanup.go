//  ___               __  _ _
// |   \ __ _ _  _   /  \| | |
// | |) / _` | || | | () |_  _|
// |___/\__,_|\_, |  \__/  |_|
//            |__/
//
// "Camp Cleanup"
//
// Given a list of range pairs (`A-B,X-Y`), count the number of pairs wherein
// one of the ranges completely contains the other.
//

package main

import (
  "bufio"
  "fmt"
  "os"
  "regexp"
  "sort"
  "strconv"
)

const filename string = "input.txt"

type sectionRange struct {
  low int
  high int
}

type elfCleaners struct {
  a sectionRange
  b sectionRange
}

func main() {
	file, err := os.Open(filename)
	if err != nil { panic(err) }
	defer file.Close()

	scanner := bufio.NewScanner(file)

  var pairs []*elfCleaners

	for scanner.Scan() {
		line := scanner.Text()
    pairs = append(pairs, getRanges(line))
  }

  var overlappedPairs int = 0
  var partiallyOverlapped int = 0 // Part 2

  for _, pair := range pairs {
    displayElves(pair)
    if isOverlapped(pair) {
      overlappedPairs += 1
    } else if isPartiallyOverlapped(pair) { // Part 2
      partiallyOverlapped += 1
    }
  }

  // Part One: There are 542 pairs where one set fully contains the other.
  fmt.Printf("\nThere are %d pairs where one set fully contains the other.\n", overlappedPairs)

  //  ___          _     ___
  // | _ \__ _ _ _| |_  |_  )
  // |  _/ _` | '_|  _|  / /
  // |_| \__,_|_|  \__| /___|
	//
	// What about a partial overlap? (Edited loop above)
  total := partiallyOverlapped + overlappedPairs
  // Part two: And 358 pairs overlap partially. In total: 900.
  fmt.Printf("And %d pairs overlap partially. In total: %d.\n", partiallyOverlapped, total)
}

func newRange(low int, high int) sectionRange {
  r := sectionRange{ low: low, high: high }
  return r
}

func newPair(a sectionRange, b sectionRange) *elfCleaners {
  p := elfCleaners{ a: a, b: b }
  return &p
}

func displayElves(pair *elfCleaners) {
  template := "Elf A: %03d - %03d | Elf B: %03d - %03d"
  fmt.Printf(template, pair.a.low, pair.a.high, pair.b.low, pair.b.high)

  if isOverlapped(pair) {
    fmt.Printf(" (Overlapped)")
  } else if isPartiallyOverlapped(pair) { // Part two
    fmt.Printf(" (Partial)")
  }

  fmt.Printf("\n")
}

func getRanges(input string) (pair *elfCleaners) {
  // Pick the Low and High for Elf 1 and Elf 2 from the known pattern
  rex := `(?P<ALow>\d+)-(?P<AHigh>\d+),(?P<BLow>\d+)-(?P<BHigh>\d+)`
  captures := regexp.MustCompile(rex).FindStringSubmatch(input)

  // Type cast matches to int
  al, err := strconv.Atoi(captures[1])
  ah, err := strconv.Atoi(captures[2])
  bl, err := strconv.Atoi(captures[3])
  bh, err := strconv.Atoi(captures[4])

  // This isn't a problem in the sample, but I have a feeling this is the kind
  // of trick the real input might pull on me.
  if al > ah || bl > bh {
    panic("A range is out of order.")
  }

  // When in Rome...
  if err != nil {
    panic(err)
  }

  // Make Elf pairs and ship 'em
  pair = newPair(newRange(al, ah), newRange(bl, bh))
  return
}

// OH HELL. I wrote this whole thing out before I stopped to think about the
// math... Set comparison is like ... a solved problem. This would have been an
// easy thing to accomplish in R. Oh well.
func isOverlapped(pair *elfCleaners) bool {
  if pair.a.low <= pair.b.low && pair.b.high <= pair.a.high {
    // Does A fully contain B
    return true
  } else if pair.b.low <= pair.a.low && pair.a.high <= pair.b.high {
    // Does B fully contain A
    return true
  } else {
    return false
  }
}

// This is only ever called if an elsif after isOverlapped returns false, so we
// know this will only include sets that _don't_ overlap completely.
func isPartiallyOverlapped(pair *elfCleaners) bool {
  // Cases that should return true here:
  //
  //   aaaaa
  //     Bbbbb
  //
  //     aaaaa
  //   bbbbB
  //
  //   aaaaaA
  //     bbbbbb
  //
  //     Aaaaa
  //   bbbbb
  //
  // So really, can short-hand this by checking if any of the following sets
  // are in sorted numerical order [ALow,BLow,AHigh], [BLow,ALow,BHigh], ...
  if sort.IntsAreSorted([]int{pair.a.low, pair.b.low, pair.a.high}) {
    // Does B start within A
    return true
  } else if sort.IntsAreSorted([]int{pair.b.low, pair.a.low, pair.b.high}) {
    // Does A start within B
    return true
  } else if sort.IntsAreSorted([]int{pair.a.low, pair.b.high, pair.a.high}) {
    // Does B end within A
    return true
  } else if sort.IntsAreSorted([]int{pair.b.low, pair.a.high, pair.b.high}) {
    // Does A end within B
    return true
  } else {
    return false
  }
}
