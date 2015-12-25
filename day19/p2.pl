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
  my $b = -1;
  for my $i (0..$#replacements)
  {
    my $r = $replacements[$i];
    next if (length($r) == 0);

    my ($from, $to) = ($r =~ /(\w+) => (\w+)/);

    my $j = index($molecule, $to);
    next if ($j == -1); # not a valid step
    next if ($from eq 'e' && $to ne $molecule);
    print "'$from' => '$to'\n";
    $b = $i;
    last;
  }
  next if ($b == -1);
  my ($from, $to) = ($replacements[$b] =~ /(\w+) => (\w+)/);
  $molecule =~ s/$to/$from/;
  print "$to => $from\n";
  print $molecule . "\n";
  push(@steps, $b);
}

print @steps . "\n";
