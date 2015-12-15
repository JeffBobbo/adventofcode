#!/usr/bin/perl

use warnings;
use strict;

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my @lines = <$fh>;
close($fh);

my $grid = {};

foreach my $line (@lines)
{
  chomp($line);
  my @coord1 = ($1, $2) if ($line =~ /([0-9]{1,3}),([0-9]{1,3}) through/);
  my @coord2 = ($1, $2) if ($line =~ /([0-9]{1,3}),([0-9]{1,3})$/);
  my $op = $1 if ($line =~ /^(.*?) [0-9]/);
  #print " $op, @coord1, @coord2\n";
  if ($op eq "turn on")
  {
    for (my $x = $coord1[0]; $x <= $coord2[0]; ++$x)
    {
      for (my $y = $coord1[1]; $y <= $coord2[1]; ++$y)
      {
        $grid->{$x}{$y}{p1} = 1;
        $grid->{$x}{$y}{p2}++;
      }
    }
  }
  if ($op eq "turn off")
  {
    for (my $x = $coord1[0]; $x <= $coord2[0]; ++$x)
    {
      for (my $y = $coord1[1]; $y <= $coord2[1]; ++$y)
  	  {
  	    $grid->{$x}{$y}{p1} = 0;
  	    $grid->{$x}{$y}{p2} = max(($grid->{$x}{$y}{p2} || 0) - 1, 0);
  	  }
  	}
  }
  if ($op eq "toggle")
  {
    for (my $x = $coord1[0]; $x <= $coord2[0]; ++$x)
    {
      for (my $y = $coord1[1]; $y <= $coord2[1]; ++$y)
      {
        $grid->{$x}{$y}{p1} = !($grid->{$x}{$y}{p1});
        $grid->{$x}{$y}{p2} += 2;
      }
    }
  }
}

my $lit = 0;
my $brightness = 0;
foreach my $x (keys %$grid)
{
  foreach my $y (keys %{$grid->{$x}})
  {
    $lit++ if ($grid->{$x}{$y}{p1} == 1);
    $brightness += $grid->{$x}{$y}{p2};
  }
}
print "There are $lit lights.\n";
print "The brightness is $brightness\n";
exit();


sub max
{
  return $_[($_[0] > $_[1] ? 0 : 1)];
}
