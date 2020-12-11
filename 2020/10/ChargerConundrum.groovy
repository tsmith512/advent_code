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
      if (index) difference = value - x.get(index-1)
      if (difference) {
        if (map.get(difference)) map.put(difference, (map.get(difference) + 1))
        else map.put(difference, 1)
      }
    }
    map
  }

  static void debugPrint(Collection x) {
    x.eachWithIndex{ value, index -> println "$index: $value" }
  }

  static void main(String... args) {
    def inputReader = new Scanner(new File(inputFile));

    while (inputReader.hasNext()) {
      chargersList.add(inputReader.next() as int)
    }

    chargersList.sort()

    println collectIntervalDistributions(chargersList)
  }
}
