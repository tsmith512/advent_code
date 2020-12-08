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
use experimental 'smartmatch';

my $filename = "game_sample.txt";

# Container for the steps
my @steps = ();

# Game stats
my $current_step = 0;
my @visited_steps = ();
my $accumulator = 0;

open(my $filehandle, "<", $filename) or die $!;

while (my $line = <$filehandle>) {
  chomp($line);
  push(@steps, $line);
}

print @steps;
