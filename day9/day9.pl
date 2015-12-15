#!/usr/bin/perl
use warnings;
use strict;

use List::Permutor;

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my @lines = <$fh>;
close($fh);

my $graph = {};

foreach (@lines)
{
  chomp();
  my ($from, $to, $dist) = (/^([a-zA-Z]+) to ([a-zA-Z]+) = ([0-9]+)$/);

  $graph->{$from}{$to} = $dist;
  $graph->{$to}{$from} = $dist; # we can go both ways
}

my $p = List::Permutor->new(keys(%{$graph}));
my @short;
my $s;
my @long;
my $l;
while (my @set = $p->next())
{
  my $cost = 0;
  for (my $i = 0; $i < $#set; $i++)
  {
    $cost += $graph->{$set[$i]}{$set[$i+1]};
  }
  if (!defined $s || $cost < $s)
  {
    @short = @set;
    $s = $cost;
  }
  if (!defined $l || $cost > $l)
  {
    @long = @set;
    $l = $cost;
  }
}
print "Shortest route is @short, covering $s distance\n";
print "Longest route is @long, covering $l distance\n";
