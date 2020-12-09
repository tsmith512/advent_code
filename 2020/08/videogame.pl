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

# Switch.pm required for this. `sudo apt-get install libswitch-perl`
use Switch;

# Here's a thing you're not supposed to use in production code. Awesome!
use experimental 'smartmatch';

my $filename = "game_steps.txt";

# Container for the steps
my @steps = ();

# Game stats
my $current_step = 0;
my @visited_steps = ();
my $accumulator = 0;

open my $filehandle, "<", $filename or die $!;

while (my $line = <$filehandle>) {
  chomp $line;
  push @steps, $line;
}

close($filehandle);

my $step;
my $action;
my $direction;
my $value;

until ($current_step ~~ @visited_steps) {
  # Split the instruction line into the action, positive/negative, and the offset/value
  ($action, $direction, $value) = ($steps[$current_step] =~ /(\w{3})\s+?([+-])(\d+)/);

  # Record that we have visited $current_step so we know if we've started a loop
  push @visited_steps, $current_step;

  switch ($action) {
    case "acc" {
      $accumulator = ($direction eq "+") ? ($accumulator + $value) : ($accumulator - $value);
      $current_step++;
    }
    case "jmp" {
      $current_step = ($direction eq "+") ? ($current_step + $value) : ($current_step - $value);
    }
    else {
      $current_step++;
    }
  }

  # If we've gone beyond the bounds of the instruction set, wrap around.
  $current_step = $current_step % scalar @steps;
}

print "Boot Loop!\n";
print "Current Accumulator Value: " . $accumulator . "\n";

# Boot Loop!
# Current Accumulator Value: 1262
