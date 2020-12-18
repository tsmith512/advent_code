#!/usr/bin/env ruby

=begin
 ___              _ ___
|   \ __ _ _  _  / | __|
| |) / _` | || | | |__ \
|___/\__,_|\_, | |_|___/
           |__/

"Rambunctious Recitation"

Challenge:
Transportation elves play a memory game that is a recitation of numbers.
Starting from a given sequence (puzzle input), follow the rules and report the
2020th number in the sequence.

On a turn, the speaker considers the most recently spoken number, and:
- If the number had not been spoken before, the player says 0.
- Else, the player says how many turns ago that number was previously spoken.

=end

class MemoryGame
  # Keep a running list of the number's we've said, in order
  @@said = []

  def do_turn()
    last = @@said.last

    # Make a list of turn numbers when we said the last number
    lookback = @@said.reverse.each_with_index.filter_map { |x, i|  i + 1 if x == last }

    if lookback.length > 1
      # Gap between turns
      out = lookback[1] - lookback[0]
    else
      # New number
      out = 0
    end

    puts "Ended turn #{@@said.length + 1}: #{last} -> #{out}"
    @@said.push(out)
  end

  def start(input, count)
    seq = input.split(',')
    seq.each { |i| @@said.push(i.to_i) }

    while @@said.length < count
      do_turn
    end
  end
end


game = MemoryGame.new
game.start(File.read("memory_start.txt").strip, 30000000)
# Part One solution:
#   Ended turn 2020: 128 -> 662
