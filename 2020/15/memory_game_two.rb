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

    if @@said[last] != nil
      # Gap between turns. @TODO I did not need two cases for this in the Part
      # One, but without this I didn't get the right answers. What am I missing
      # to consolidate this logic?
      if @@said[last].length > 1
        out = @@turn - 1 - @@said[last][1]
      else
        out = @@turn - 1 - @@said[last][0]
      end
    else
      # New number
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
    seq = input.split(',')
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
game.start(File.read("memory_start.txt").strip, 2020)
# Part One solution:
#   Ended turn 2020: 128 -> 662
