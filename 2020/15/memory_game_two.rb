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
        # If it has only been said once, then last time was the first time it
        # was spoken. The output is 0.
        puts "\n\nTurn: #{@@turn}"
        puts "Turn when #{last} was most recently spoken (said.last) #{@@said[last]}"
        out = 0
        puts "#{out} = #{@@turn} - 1 - #{@@said[last][0]}"
      end
    else
      out = 0
    end

    if @@said[out] != nil
      @@said[out].unshift(@@turn)
    else
      @@said[out] = [@@turn]
    end
    # puts "Ended turn #{@@turn}: #{last} -> #{out}\n" if @@turn % 1000 == 0

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
game.start(File.read("memory_start.txt"), 2020)
# Part Two solution:
#   Ended turn 30000000: 10091 -> 37312
#   Ended turn 30000000: 37312
