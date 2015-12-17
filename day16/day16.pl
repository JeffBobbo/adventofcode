#!/usr/bin/perl
use warnings;
use strict;

use Data::Dumper;

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my @lines = <$fh>;
close($fh);

my $aunts = {};

my $ticker = {
  children => 3,
  cats => 7,
  samoyeds => 2,
  pomeranians => 3,
  akitas => 0,
  vizslas => 0,
  goldfish => 5,
  trees => 3,
  cars => 2,
  perfumes => 1
};

my $p1;
my $p2;
foreach (@lines)
{
  my ($i) = (/Sue ([\d]+)/);
  my $aunt = {};
  while (/([\w]+): ([\d]+)/g)
  {
    $aunt->{$1} = $2;
  }

  my $g1 = 1;
  my $g2 = 1;
  foreach my $thing (keys(%{$ticker}))
  {
    if (defined $aunt->{$thing})
    {
      if ($thing eq 'cats' || $thing eq 'trees')
      {
        if ($aunt->{$thing} <= $ticker->{$thing})
        {
          $g2 = 0;
        }
      }
      elsif ($thing eq 'pomeranians' || $thing eq 'goldfish')
      {
        if ($aunt->{$thing} >= $ticker->{$thing})
        {
          $g2 = 0;
        }
      }
      elsif ($aunt->{$thing} != $ticker->{$thing})
      {
        $g2 = 0;
      }
      if ($aunt->{$thing} != $ticker->{$thing})
      {
        $g1 = 0;
      }
    }
  }
  $p1 = $i if ($g1);
  $p2 = $i if ($g2);
}
print "When my MFCSAM is working, Aunt Sue " . $p1 . " bought me the present\n";
print "When my MFCSAM isn't working, Aunt Sue " . $p2 . " bought me the present\n";