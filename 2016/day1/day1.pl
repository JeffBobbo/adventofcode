#!/usr/bin/perl

use warnings;
use strict;

use Switch;

my $input = "R2, L3, R2, R4, L2, L1, R2, R4, R1, L4, L5, R5, R5, R2, R2, R1, L2, L3, L2, L1, R3, L5, R187, R1, R4, L1, R5, L3, L4, R50, L4, R2, R70, L3, L2, R4, R3, R194, L3, L4, L4, L3, L4, R4, R5, L1, L5, L4, R1, L2, R4, L5, L3, R4, L5, L5, R5, R3, R5, L2, L4, R4, L1, R3, R1, L1, L2, R2, R2, L3, R3, R2, R5, R2, R5, L3, R2, L5, R1, R2, R2, L4, L5, L1, L4, R4, R3, R1, R2, L1, L2, R4, R5, L2, R3, L4, L5, L5, L4, R4, L2, R1, R1, L2, L3, L2, R2, L4, R3, R2, L1, L3, L2, L4, L4, R2, L3, L3, R2, L4, L3, R4, R3, L2, L1, L4, R4, R2, L4, L4, L5, L1, R2, L5, L2, L3, R2, L2";
#my $input = "R8, R4, R4, R8";

my $first = 0;
my $x = 0;
my $y = 0;
my @visited;
my $f = 0;
foreach (split(', ', $input))
{
  my ($d, $a) = $_ =~ /([RL])(\d+)/;
  $f = ($f + ($d eq 'R' ? 1 : 3)) % 4;
  switch ($f)
  {
    case 0
    {
      for (my $i = 0; $first == 0 && $i < $a; ++$i)
      { 
        foreach (@visited)
        {
          if ($_->[0] == $x && $_->[1] == $y+$i)
          {
            print "First location: " . $x . ", " . ($y+$i) . "\n";
            print "Blocks: " . (abs($x) + abs($y+$i)) . "\n";
            $first = 1;
          }
        }

        push(@visited, [$x, $y+$i]);
      }
      $y += $a;
    }
    case 2
    {
      for (my $i = 0; $first == 0 && $i < $a; ++$i)
      { 
        foreach (@visited)
        {
          if ($_->[0] == $x && $_->[1] == $y-$i)
          {
            print "First location: " . $x . ", " . ($y-$i) . "\n";
            print "Blocks: " . (abs($x) + abs($y-$i)) . "\n";
            $first = 1;
          }
        }

        push(@visited, [$x, $y-$i]);
      }
      $y -= $a;
    }
    case 1
    {
      for (my $i = 0; $first == 0 && $i < $a; ++$i)
      {
        foreach (@visited)
        {
          if ($_->[0] == $x+$i && $_->[1] == $y)
          {
            print "First location: " . ($x+$i) . ", " . $y . "\n";
            print "Blocks: " . (abs($x+$i) + abs($y)) . "\n";
            $first = 1;
          }
        }

        push(@visited, [$x+$i, $y]);
      }
      $x += $a;
    }
    case 3
    {
      for (my $i = 0; $first == 0 && $i < $a; ++$i)
      {
        foreach (@visited)
        {
          if ($_->[0] == $x-$i && $_->[1] == $y)
          {
            print "First location: " . ($x-$i) . ", " . $y . "\n";
            print "Blocks: " . (abs($x-$i) + abs($y)) . "\n";
            $first = 1;
          }
        }

        push(@visited, [$x-$i, $y]);
      }
      $x -= $a;
    }
  }
}

print "Final location: $x, $y\n";