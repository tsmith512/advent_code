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
    last_turn = @@said.length
    my_turn = @@said.length + 1
    last = @@said.last

    puts "\n\nStarting turn #{my_turn} with #{last}"
    puts "Numbers spoken: #{@@said}"

    lookback = @@said.reverse.each_with_index.filter_map { |x, i|  i + 1 if x == last }
    puts "Turns when #{last} was said: #{lookback} (total times #{lookback.length})"

    if lookback.length > 1
      puts "We'd said #{last} before"
      out = lookback[1] - lookback[0]
      puts "#{out} = #{lookback[1]} - #{lookback[0]}"
    else
      puts "New Number #{last} --> 0"
      out = 0
    end

    @@said.push(out)
    puts "#{@@said}"
    out
  end

  def start(input)
    seq = input.split(',')
    seq.each { |i| @@said.push(i.to_i) }
    @@turn = seq.length
    do_turn
    do_turn
    do_turn
    do_turn
    do_turn
  end
end


game = MemoryGame.new
game.start(File.read("memory_sample.txt").strip)
