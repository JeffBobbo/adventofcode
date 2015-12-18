#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

my @grid;
my $steps = 1;

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

      if ($x == 0 && $y == 5)
      {
        print "$minX, $maxX, $minY, $maxY\n";
      }

      for my $i ($minX..$maxX)
      {
        for my $j ($minY..$maxY)
        {
          next if ($i == 0 && $j == 0);
          $nCount++ if ($grid[$i]->[$j] == 1);
        }
      }

      if ($grid[$x]->[$y] == 1)
      {
        if ($nCount == 2 || $nCount == 3)
        {
          push(@lightsOn, {x => $x, y => $y});
        }
        else
        {
          push(@lightsOff, {x => $x, y => $y});
        }
      }
      if ($grid[$x][$y] == 0 && $nCount == 3)
      {
        push(@lightsOn, {x => $x, y => $y});
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
