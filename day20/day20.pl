#!/usr/bin/perl

use warnings;
use strict;

my $target = 34e6;

my @p1;
my @p2;

for (my $i = 1; $i <= ($target / 10); $i++)
{
  for (my $j = $i; $j <= ($target / 10); $j += $i)
  {
    if ($j < $i * 50)
    {
      $p2[$j-1] += $i * 11;
    }
    $p1[$j-1] += $i * 10;
  }
}

for (my $j = 0; $j < @p1; $j++)
{
  if ($p1[$j] >= $target)
  {
    print "P1: House " . ($j + 1) . " got " . $p1[$j] . " presents\n";
    last;
  }
}

for (my $j = 0; $j < @p2; $j++)
{
  if ($p2[$j] >= $target)
  {
    print "P2: House " . ($j + 1) . " got " . $p2[$j] . " presents\n";
    last;
  }
}
