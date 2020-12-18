#!/usr/bin/env ruby

=begin
 ___              _ ___    ___          _     ___
|   \ __ _ _  _  / | __|  | _ \__ _ _ _| |_  |_  )
| |) / _` | || | | |__ \  |  _/ _` | '_|  _|  / /
|___/\__,_|\_, | |_|___/  |_| \__,_|_|  \__| /___|
           |__/

"Rambunctious Recitation"

Challenge:
- Same as part one, but get the 30,000,000th number.

=end

class MemoryGame
  # Keep a running map of the number's we've said, and when
  @@said = []
  @@turn = 0

  def do_turn(last)
    last = @@said.last
    @@turn  += 1

    if @@said.includes?(last)
      # Gap between turns. We know $last was spoken at X turn and Y turn (the
      # last turn), so getting the difference between those is just Y - X
      out = @@turn - @@said[last]

    else
      # New number
      out = 0
    end

    puts "Ended turn #{@@turn}: #{last} -> #{out}"
    @@said[out] = @@turn
  end

  def start(input, count)
    seq = input.split(',')
    seq.each { |i| @@said.push(i.to_i) }

    while @@turn < count
      do_turn
    end
  end
end


game = MemoryGame.new
game.start(File.read("memory_start.txt").strip, 2020)
# Part One solution:
#   Ended turn 2020: 128 -> 662
