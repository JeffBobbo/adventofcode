#!/usr/bin/perl

use warnings;
use strict;

open(my $fh, '<', 'input.txt') or die "Crap: $!\n";
my $input = join('', <$fh>);
close($fh);
$input =~ s/\R//g;
my @nums = split('', $input);
my $sum = 0;

for (my $i = 0; $i < @nums; ++$i)
{
  if ($nums[$i] == $nums[($i + (@nums/2)) % @nums])
  {
    $sum += $nums[$i];
  }
}

print "$sum\n";
