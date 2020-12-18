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
  @@said = {}
  @@turn = 0

  def do_turn(last)
    @@turn  += 1

    if @@said[last] != nil && @@said[last].length > 1
      # We'd said that number before, so substract when that happened from the
      # last turn number.
      out = @@turn - 1 - @@said[last][1]
    else
      # This is either the first time a number was said or last time was the
      # first time a number was said.
      out = 0
    end

    if @@said[out] != nil
      @@said[out].unshift(@@turn)
    else
      @@said[out] = [@@turn]
    end

    puts "Ended turn #{@@turn}: #{last} -> #{out}\n" if @@turn % 1000 == 0

    out
  end

  def start(input, count)
    seq = input.strip.split(',')
    seq.each.with_index(1) { |val, index| @@said[val.to_i] = [index] }

    puts "Input Seq: #{seq}"
    puts "Init map: #{@@said}"

    out = seq.last.to_i
    @@turn = seq.length

    puts "Start #{@@turn} with #{out}.\n\n"


    while @@turn < count
      out = do_turn(out)
    end

    puts "Ended turn #{@@turn}: #{out}\n\n"
  end
end


game = MemoryGame.new
game.start(File.read("memory_start.txt"), 30_000_000)
# Part Two solution:
#   Ended turn 30000000: 10091 -> 37312
#   Ended turn 30000000: 37312
