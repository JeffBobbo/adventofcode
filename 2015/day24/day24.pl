#!/usr/bin/perl

use warnings;
use strict;

use Sys::MemInfo qw(freemem);
use Algorithm::Combinatorics qw(partitions);

open(my $fh, '<', 'input.txt');
chomp(my @input = <$fh>);
close($fh);

my $total = sum(@input);
my $weight = $total / 3;
print "Total mass of presents is $total kg, that's $weight kg per compartment\n";

use List::Permutor;

my @partitions = partitions(\@input);

use Data::Dumper;
my $bestSize = 'Infinity';
my $bestQE = 'Infinity';
my @best;
foreach (@partitions)
{
  memcheck();
  my @a = @{$_};
#  next if (@a != 3);
  foreach my $stackRef (@a)
  {
    my @stack = @{$stackRef};

    next if (sum(@stack) != $weight);
    my $size = scalar(@stack);
    next if ($size > $bestSize);
    my $qe = product(@stack);


    if ($size <= $bestSize)
    {
      $bestSize = $size;
      if ($qe < $bestQE)
      {
        $bestQE = $qe;
        @best = @stack;
      }
    }
  }
}

print "Best size is $bestSize and has a quantum entanglement of $bestQE\n";
print "@best\n";

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

sub memcheck
{
  if (freemem() / 1024 / 1024 / 1024 < 0.5)
  {
    print "Running out of RAM, bye!\n";
    exit(1);
  }
}
