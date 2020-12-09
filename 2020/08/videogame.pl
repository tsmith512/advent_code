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

# Here's a thing you're not supposed to use in production code. You bet!
use experimental 'smartmatch';

my $filename = "game_sample.txt";

# Container for the steps
my @steps = ();

open my $filehandle, "<", $filename or die $!;

while (my $line = <$filehandle>) {
  chomp $line;
  push @steps, $line;
}

close($filehandle);

# Game stats
my @visited_steps = ();
my ($accumulator, $current_step) = (0, 0);
my ($action, $direction, $value);

until ($current_step ~~ @visited_steps) {
  # Split the instruction line into the action, positive/negative, and the offset/value
  ($action, $direction, $value) = ($steps[$current_step] =~ /(\w{3})\s+?([+-])(\d+)/);

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

print "** PART ONE:\n";
print "Boot Loop! Current Accumulator Value: " . $accumulator . "\n\n";
# Part One solution:
# Boot Loop! Current Accumulator Value: 1262


#  ___          _     ___
# | _ \__ _ _ _| |_  |_  )
# |  _/ _` | '_|  _|  / /
# |_| \__,_|_|  \__| /___|
#
# Apparently the instructions set should terminate at the last line once the
# "corruption" is fixed. I need to swap one "nop" for a "jmp" (for vice versa)
# so that the script terminates at the end of the set.

# Reset
($current_step, $accumulator) = (0, 0);
my ($total_attempts, $adjusted_line_yet, $completed) = (0, 0, 0);
my @adjusted_lines = ();

until ($completed or $total_attempts > 10) {
  # Start the game over
  print "Starting fix attempt: $total_attempts\n";
  $total_attempts++;
  ($current_step, $accumulator, $adjusted_line_yet) = (0, 0, 0);
  @visited_steps = ();

  # The content of this loop controls the iterator:
  for ($current_step = 0; $current_step < (scalar @steps); $current_step) {
    # Split the instruction line
    ($action, $direction, $value) = ($steps[$current_step] =~ /(\w{3})\s+?([+-])(\d+)/);

    print "Current instruction: $current_step : $action / $direction / $value \n";

    last if ($current_step ~~ @visited_steps);
    push @visited_steps, $current_step;

    switch ($action) {
      case "acc" {
        $accumulator = ($direction eq "+") ? ($accumulator + $value) : ($accumulator - $value);
        $current_step++;
      }
      case "jmp" {
        if (($current_step ~~ @adjusted_lines) or $adjusted_line_yet) {
          $current_step = ($direction eq "+") ? ($current_step + $value) : ($current_step - $value);
        }
        else {
          print "* Running a jump as a nop. $current_step\n";
          push @adjusted_lines, $current_step;
          $adjusted_line_yet = 1;
          $current_step++;
        }
      }
      case "nop" {
        if (($current_step ~~ @adjusted_lines) or $adjusted_line_yet) {
          $current_step++;
        }
        else {
          print "* Running a nop as a jmp. $current_step\n";
          push @adjusted_lines, $current_step;
          $adjusted_line_yet = 1;
          $current_step = ($direction eq "+") ? ($current_step + $value) : ($current_step - $value);
        }
      }
      else {
        $current_step++;
      }
    }

    # Are we done?
    if ($current_step == (scalar @steps)) {
      print "Program complete.\n";
      $completed = 1;
      last;
    };
  }

  print "Boot Loop! Execution #$total_attempts ended at $current_step. Accumulator value: $accumulator\n" if not $completed;
  print "\n\n" if not $completed;
}

print "Complete! Execution #$total_attempts ended at $current_step. Accumulator value: $accumulator\n" if $completed;
print "\n\n";
