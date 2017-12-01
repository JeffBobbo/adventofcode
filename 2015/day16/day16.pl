#!/usr/bin/perl
use warnings;
use strict;

use JSON qw(from_json);

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my @lines = <$fh>;
close($fh);

my $aunts = {};

open($fh, '<', 'ticker.json') or die "Failed to read ticker tape: $!\n";
my $tape = join('', <$fh>);
close($fh);

if (!defined $tape || length($tape) == 0)
{
  print "Bad ticker tape\n";
  exit(0);
}

my $ticker = from_json($tape);

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
