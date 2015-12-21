#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

open(my $fh, '<', 'input.txt');
my @replacements = <$fh>;
chomp(@replacements);
close($fh);

my $molecule = pop(@replacements);

my @steps;

while ($molecule ne 'e')
{
  my $b = 0;
  my $s = 0;
  for my $i (0..$#replacements)
  {
    my $r = $replacements[$i];
    next if (length($r) == 0);

    my ($from, $to) = ($r =~ /(\w+) => (\w+)/);

    my $j = index($molecule, $from);
    next if ($j == -1); # not a valid step

    my $l = length($to) - length($from);
    if ($l > $s && ($from ne 'e' || length($molecule) - $l == 1))
    {
      $b = $i;
      $s = $l;
    }
  }
  my ($from, $to) = ($replacements[$b] =~ /(\w+) => (\w+)/);
  $molecule =~ s/$to/$from/;
  print "$to => $from\n";
  print $molecule . "\n";
  push(@steps, $b);
}

print @steps . "\n";
