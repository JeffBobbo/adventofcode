#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

open(my $fh, '<', 'input.txt');
my @replacements = <$fh>;
chomp(@replacements);
close($fh);

my $molecule = pop(@replacements);

my $steps = 0;

my $copy = $molecule;
while ($molecule ne 'e')
{
  # pick a random replacement to try
  my $r = $replacements[random(scalar(@replacements))];

  next if (length($r) == 0);

  my ($from, $to) = ($r =~ /(\w+) => (\w+)/);

  my $j = -1;
  # generate a list of possiblities we can do replacements on
  my @opts;
  while (($j = index($molecule, $to, $j+1)) != -1)
  {
    push (@opts, $j);
  }

  next unless (@opts); # can we actually do a swap?

  # pick a random one to swap
  my $replace = random(scalar(@opts));

  # and do the repacement
  substr($copy, $replace, length($to), $from);

  $steps++;
}

print @steps . "\n";
exit();

sub random
{
  return int(rand(shift()));
}