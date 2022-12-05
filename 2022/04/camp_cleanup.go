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
  "strconv"
  // "strings"
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

  for _, pair := range pairs {
    displayElves(pair)
    if isOverlapped(pair) {
      overlappedPairs += 1
    }
  }

  // Part One: There are 542 pairs where one set fully contains the other.
  fmt.Printf("\nThere are %d pairs where one set fully contains the other.\n", overlappedPairs)
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
