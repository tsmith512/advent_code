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
  @@said = []

  def turn()
    lookback = @@said.reverse
    last = lookback.shift
    puts "Starting a turn with #{last}"

    if lookback.include?(last)
      how_long = lookback.index(last)
      puts "We'd said #{last} before #{how_long} turns ago / #{lookback}"
      out = how_long
    else
      puts "New Number #{last} --> 0"
      out = 0
    end

    @@said.push(out)
    puts @@said
    out
  end

  def start(input)
    seq = input.split(',')
    seq.each { |i| @@said.push(i.to_i) }
    turn
    turn
    turn
  end
end


game = MemoryGame.new
game.start(File.read("memory_sample.txt").strip)
