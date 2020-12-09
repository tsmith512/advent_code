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

my $filename = "game_sample.txt";

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

print "** PART ONE:\n";
print "Boot Loop!\n";
print "Current Accumulator Value: " . $accumulator . "\n\n\n";
# Part One solution:
# Boot Loop!
# Current Accumulator Value: 1262

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
my $total_attempts = 0;
my @adjusted_lines = ();
my $adjusted_line_yet = 0;
my $completed = 0;

until ($completed or $total_attempts > 10) {
  # Start the game over
  print "Starting fix attempt: $total_attempts\n";
  $total_attempts++;
  $current_step = 0;
  @visited_steps = ();
  $accumulator = 0;
  $adjusted_line_yet = 0;

  # To its credit, Perl recommends against a C-style for loop for readability
  # issues, and this one is weird anyway because the loop contents are handling
  # the increment of the tested value, not the loop itself.
  for ($current_step = 0; $current_step < (scalar @steps); $current_step) {
    # Split the instruction line
    ($action, $direction, $value) = ($steps[$current_step] =~ /(\w{3})\s+?([+-])(\d+)/);
    print "Current instruction: $current_step : $action / $direction / $value \n";

    # Have we looped?
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

    # Are we done? Check n+1 beacuse we will have already processed an increment
    if ($current_step == (scalar @steps)) {
      print "Program complete.\n";
      $completed = 1;
      last;
    };

    # If we've gone beyond the bounds of the instruction set, wrap around.
    # $current_step = $current_step % scalar @steps;
  }

  print "Steps visited: " . (join " ", @visited_steps) . "\n";
  print "Steps adjusted: " . (join " ", @adjusted_lines) . "\n";
  print "Abnormal termination. Execution #$total_attempts ended at $current_step. Accumulator value: $accumulator\n" if not $completed;
  print "\n\n" if not $completed;
}

print "Program complete. Execution #$total_attempts ended at $current_step. Accumulator value: $accumulator\n" if $completed;
print "\n\n";
