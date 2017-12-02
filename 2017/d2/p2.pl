#!/usr/bin/perl

use warnings;
use strict;

open(my $fh, '<', 'input.txt') or die "$!\n";
chomp(my @lines = <$fh>);
close($fh);

my $total = 0;
foreach (@lines)
{
  last unless length();
  my @s = split(' ', $_);
  for (my $i = 0; $i < @s; ++$i)
  {
    for (my $j = $i+1; $j < @s; ++$j)
    {
      my $ij = $s[$i] / $s[$j];
      my $ji = $s[$j] / $s[$i];
      if ($ij == int($ij))
      {
        $total += $ij;
      }
      elsif ($ji == int($ji))
      {
        $total += $ji;
      }
    }
  }
}

print "Checksum is: $total\n";
