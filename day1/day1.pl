#!/usr/bin/perl

use warnings;
use strict;

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my $data = join('', <$fh>);
close($fh);

my $floor = 0;
my $basement = -1;
for (my $i = 0; $i < length($data); $i++)
{
  if (substr($data, $i, 1) eq '(')
  {
    $floor++;
  }
  else
  {
    $floor--;
  }
  if ($basement == -1 && $floor == -1)
  {
    $basement = $i+1;
  }
}
print 'Santa is on floor ' . $floor . "\n";
print 'Santa enters the basement at ' . $basement . "\n";
