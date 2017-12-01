#!/usr/bin/perl

use warnings;
use strict;

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my @data = <$fh>;
close($fh);

my $paper = 0;  # how much paper we need
my $ribbon = 0; # how much ribbon we need

foreach my $present (@data)
{
  my @d = split('x', $present);

  my $w = 2*$d[0]*$d[1];
  my $h = 2*$d[1]*$d[2];
  my $l = 2*$d[2]*$d[0];

  my $shortest = min($w/2, min($h/2, $l/2));
  $paper += $w + $h + $l + $shortest;

  # sort so we know the shortest sides easily
  @d = sort({$a <=> $b} @d);
  my $length = $d[0]*2 + $d[1]*2;
  $length += $d[0]*$d[1]*$d[2];
  $ribbon += $length;
}
print 'Paper needed to wrap all the presents ' . $paper . "\n";
print 'Amount of ribbon needed is ' . $ribbon . "\n";
exit(0);

sub min
{
  return $_[($_[0] < $_[1] ? 0 : 1)];
}
