#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

open(my $fh, '<', 'input.txt');
my @replacements = <$fh>;
chomp(@replacements);
close($fh);

my $molecule = pop(@replacements);

my @produced;

foreach (@replacements)
{
  next if (length() == 0);

  my ($from, $to) = (/(\w+) => (\w+)/);

  my $i = index($molecule, $from);
  while ($i != -1)
  {
    my $copy = $molecule;
    substr($copy, $i, length($from)) = $to;
    push(@produced, $copy);
    $i = index($molecule, $from, $i+1);
  }
}

print scalar(unique(@produced)) . "\n";


sub unique
{
  my %seen;
  grep !$seen{$_}++, @_;
}