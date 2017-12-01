#!/usr/bin/perl

use warnings;
use strict;

open(my $fh, '<', 'input.txt');
my @lines = <$fh>;
close($fh);

my $valid1 = 0;
my $valid2 = 0;

foreach (@lines)
{
  chomp();
  my @sides = sort(split(' ', $_));

  ++$valid1 if (valid(@sides));
}

for (0..2)
{
  for (my $i = 0; $i < @lines; $i += 3)
  {
    my @a = split(' ', $lines[$i+0]);
    my @b = split(' ', $lines[$i+1]);
    my @c = split(' ', $lines[$i+2]);

    ++$valid2 if (valid($a[$_], $b[$_], $c[$_]));
  }
}

sub valid
{
  my $x = shift();
  my $y = shift();
  my $z = shift();

  return $x + $y > $z && $x + $z > $y && $y + $z > $x;
}

print $valid1 . "\n";
print $valid2 . "\n";
