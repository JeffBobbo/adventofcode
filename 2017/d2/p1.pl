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
  my $s = 10000000;
  my $b = 0;
  foreach (split(' ', $_))
  {
    $s = $_ if ($_ < $s);
    $b = $_ if ($_ > $b);
  }
  print "s: $s, b: $b\n";
  $total += $b - $s;
}

print "Checksum is: $total\n";
