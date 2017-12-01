#!/usr/bin/perl
use warnings;
use strict;

use Data::Dumper;
use List::Permutor;

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
chomp(my @containers = <$fh>);
close($fh);

my @combinations;
my $EGGNOG = 25;

my $p = List::Permutor->new(@containers);
while (my @set = $p->next())
{
  my $capacity = 0;
  my $good = 0;
  my @combination;
  foreach (@set)
  {
    $capacity += $_;
    push(@combination, $_);
    if ($capacity == $EGGNOG)
    {
      $good = 1;
      last;
    }
  }
  if ($good)
  {
    foreach my $a (@combinations)
    {
      if (arraysEqual($a, \@combination))
      {
        $good = 0;
        last;
      }
    }
    if ($good)
    {
      push(@combinations, \@combination);
      print "push @combination\n";
    }
  }
}
print @combinations . "\n";

sub xInArray
{
  my $x = shift();
  my @a = @_;

  my $c = 0;
  foreach (@a)
  {
    $c++ if ($x == $_);
  }
  return $c;
}

sub arraysEqual
{
  my @a = @{shift()};
  my @b = @{shift()};

  return 0 if (@a != @b);
  for (my $i = 0; $i < @a; $i++)
  {
    return 0 if ($a[$i] != $b[$i]);
  }
  return 1;
}
