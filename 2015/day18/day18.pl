#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my @grid;
my $steps = 100;
my $p2 = 0;

open(my $fh, '<', 'input.txt');
while (<$fh>)
{
  chomp();
  next if (length($_) == 0);
  s/\./0/g;
  s/#/1/g;
  my @line = split('', $_);
  push(@grid, \@line);
}
close($fh);


if ($p2)
{
  $grid[0]->[0] = 1;
  $grid[0]->[99] = 1;
  $grid[99]->[0] = 1;
  $grid[99]->[99] = 1;
}

for (my $i = 0; $i < $steps; $i++)
{
  my @lightsOn;
  my @lightsOff;
  for (my $x = 0; $x < @grid; $x++)
  {
    for (my $y = 0; $y < @{$grid[$x]}; $y++)
    {
      my $nCount = 0;
      my $minX = max($x - 1, 0);
      my $maxX = min($x + 1, @grid - 1);
      my $minY = max($y - 1, 0);
      my $maxY = min($y + 1, @{$grid[$x]} - 1);

      for (my $j = $minX; $j <= $maxX; $j++)
      {
        for (my $k = $minY; $k <= $maxY; $k++)
        {
          next if ($j == $x && $k == $y);
          $nCount++ if ($grid[$j]->[$k] == 1);
        }
      }
      if ($grid[$x]->[$y] == 1)
      {
        if ($nCount != 2 && $nCount != 3)
        {
          push(@lightsOff, {x => $x, y => $y});
        }
      }
      else
      {
        if ($nCount == 3)
        {
          push(@lightsOn, {x => $x, y => $y});
        }
      }
    }
  }

  foreach (@lightsOn)
  {
    $grid[$_->{x}]->[$_->{y}] = 1;
  }
  foreach (@lightsOff)
  {
    $grid[$_->{x}]->[$_->{y}] = 0;
  }
}

if ($p2)
{
  $grid[0]->[0] = 1;
  $grid[0]->[99] = 1;
  $grid[99]->[0] = 1;
  $grid[99]->[99] = 1;
}

my $count = 0;
foreach my $x (@grid)
{
  foreach my $y (@{$x})
  {
    print $y ? '#' : '.';
    $count++ if ($y == 1);
  }
  print "\n";
}
print "\n$count\n";

sub min
{
  return $_[$_[0] < $_[1] ? 0 : 1];
}
sub max
{
  return $_[$_[0] > $_[1] ? 0 : 1];
}
