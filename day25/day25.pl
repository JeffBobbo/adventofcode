#!/usr/bin/perl

use warnings;
use strict;

my $start = 20151125;
my $mult  = 252533;
my $mod   = 33554393;
my $code = $start;

my $row = 3010;
my $col = 3019;

my $x = 1;
my $y = 1;
my $maxY = 1;

while ($x != $col || $y != $row)
{
  $code *= $mult;
  $code %= $mod;
  if ($y > 1)
  {
    $x++;
    $y--;
  }
  else
  {
    $maxY++;
    $x = 1;
    $y = $maxY;
  }
}
print "$code\n";
