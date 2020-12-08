#!/bin/env perl

#  ___               __  ___
# |   \ __ _ _  _   /  \( _ )
# | |) / _` | || | | () / _ \
# |___/\__,_|\_, |  \__/\___/
#            |__/
#
# "Handheld Halting"
#
# Challenge:
# Given {accumulator = 0} a list of instructions:
#   - nop: continue to the next step
#   - acc (signed int): increase/decrease accumulator
#   - jmp (signed int): advanced/rewind by int, resume execution
# The instruction list is ultimately circular. Report accumulator value before
# the infinite loop begins.

use warnings;
use strict;

my $filename = "game_sample.txt";

open(my $filehandle, "<", $filename) or die $!;

while(my $line = <$filehandle>){
  print $line;
}
