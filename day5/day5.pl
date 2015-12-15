#!/usr/bin/perl

use warnings;
use strict;

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my @data = <$fh>;
close($fh);
# part 1
{
  my $nice = 0;
  foreach my $str (@data)
  {
    chomp($str);
    # A nice string...
    # does not contain the strings ab, cd, pq, or xy
    next if (index($str, 'ab') != -1);
    next if (index($str, 'cd') != -1);
    next if (index($str, 'pq') != -1);
    next if (index($str, 'xy') != -1);

    # contains at least one letter that appears twice in a row
    next if ($str !~ /([a-z])\1/);

    # contains at least three vowels
    next if ($str !~ /(?:.*[aeiou]){3}/);

    $nice++
  }
  print "Puzzle 1: There are $nice strings on santa's list\n";
}

# part 2
{
  my $nice = 0;
  foreach my $str (@data)
  {
    # A nice string...
    # contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy)
    next if ($str !~ /([a-z]{2}).*\1/);

    # It contains at least one letter which repeats with exactly one letter between them, like xyx
    next if ($str !~ /([a-z])[a-z]\1/);

    $nice++
  }
  print "Puzzle 2: There are $nice strings on santa's list\n";
}
