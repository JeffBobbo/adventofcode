#!/usr/bin/perl

use warnings;
use strict;

use Algorithm::Combinatorics qw(partitions);

open(my $fh, '<', 'input.txt');
chomp(my @input = <$fh>);
close($fh);

my $total = 0;
$total += $_ foreach (@input);

my $weight = $total / 3;

use List::Permutor;

my @partitions = partitions(\@input);

use Data::Dumper;
foreach (@partitions)
{
  my @a = @{$_};
  next if (@a != 3);
  my $good = 1;
  my @p;
  foreach my $b (@a)
  {
    if (sum(@{$b}) != $weight)
    {
      $good = 0;
      last;
    }
    else
    {
      push(@p, product(@{$b}));
    }
  }
  next unless ($good);

  my @q = sort {$a <=> $b} @p;
  print "$q[0]\n";
  print Dumper(@a) if $q[0] == 88;
}

sub sum
{
  my $sum = 0;
  $sum += $_ foreach (@_);
  return $sum;
}

sub product
{
  my $product = 1;
  $product *= $_ foreach(@_);
  return $product;
}
