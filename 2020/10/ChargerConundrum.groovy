//  ___              _  __
// |   \ __ _ _  _  / |/  \
// | |) / _` | || | | | () |
// |___/\__,_|\_, | |_|\__/
//          |__/
//
// "Adapter Array"
//
// Challenge:
// (This problem narrative was harder for me to parse. Here's what I think.)
// The starting point is 0. Each number in the puzzle input represents a widget.
// A widget can take an input 1, 2, or 3 lower than it is. Using every number
// in the input, order them such that they fall in this pattern and collect the
// distribution of increments between them.

class ChargerConundrum {
  static final String inputFile = "chargers_sample_small.txt"
  static def chargersList = []

  static Map collectIntervalDistributions(Collection x) {
    def map = [:]

    x.eachWithIndex { value, index ->
      def difference = false

      // Look back to the previous "charger" in the list.
      if (index) {
        difference = value - x.get(index - 1)
        if (map.get(difference)) map.put(difference, (map.get(difference) + 1))
        else map.put(difference, 1)
      }
      // The input to the first widget (i = 0) is 0, so its difference is itself
      else {
        map.put(value, 1)
      }
    }

    // For narrative reasons, there's an extra increment-3 element
    map.put(3, (map.get(3) + 1))

    map
  }

  static void debugPrint(Collection x) {
    x.eachWithIndex{ value, index -> println "$index: $value" }
  }

  static void main(String... args) {
    chargersList = new File(inputFile).collect {it as int}

    println "Total Chargers in input list: " + chargersList.size()
    chargersList.sort()

    def intervals = collectIntervalDistributions(chargersList)

    println "Count of 1-Jolt Increases: " + intervals.get(1)
    println "Count of 3-Jolt Increases: " + intervals.get(3)
    println "Product: " + (intervals.get(1) * intervals.get(3))

    // Part One solution:
    //   Total Chargers in input list: 94
    //   Count of 1-Jolt Increases: 66
    //   Count of 3-Jolt Increases: 29
    //   Product: 1914


    //  ___          _     ___
    // | _ \__ _ _ _| |_  |_  )
    // |  _/ _` | '_|  _|  / /
    // |_| \__,_|_|  \__| /___|
    //
    // omg wat?!
    // Uhhhhhhhh. Okay to English about this...
    //
    // Challenge: How many combinations would work?
    // - Same rules as Part One.
    // - Index -1 = 0. Index n+1 = Max+3.
    // - Chargers still have to go in order.
    // - Chargers still must be an increment of 1, 2, or 3
    // - Puzzle input contains ~100 lines. Narrative contained a warning that
    //   there could be trillions+ combos.
    //
    // Actual question:
    // What is the total number of distinct ways you can arrange the adapters to
    // connect the charging outlet to your device?
    //
    // A way that sounds good on paper...
    // - Start at min.
    // - For each increment, decide what each next step could be, based on what
    //   can be skipped.
    //   - Recursively run each option. Add an incrementor to tally each completion.
    // - Evan did that, his gaming computer crashed after 6 hours.
    // (I suppose I could call up one of a few friends at internationally recognized supercomputing centers...)
    //
    // Another option...
    // - Start at 0
    // - Just figure out how many [next] items would be valid................
    //   .......but how do I know what I skipped
    //
    // Backwards?
    //
    // [Insert whiteboarding with George]
    // - Set adapter list as the keys for a Map (reverse the order?)
    //   - Add min and max values to that list, to keep it together
    // - Map.eachWithIndex (plus bs about splitting "value" into k/v) _downward_
    //   - Increment the value of "adapters I can reach from here" by current
    //     adapter's "how many ways can we get here" number
    // - By the end of the Map, we should have a counter on the [min] value (0)g
    def min = 0
    def max = chargersList.get(chargersList.size() - 1) + 3
  }
}
