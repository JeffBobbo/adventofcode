#!/usr/bin/perl -W
use warnings;
use strict;
use feature qw(say);

use List::Util qw(sum);
use List::MoreUtils qw(first_index);

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
chomp(my @containers = <$fh>);
close($fh);

my @answer = (0) x (@containers + 1);
my @combinations;
my $x = 1 << 0+@containers;
print "$x\n";
for my $i (0 .. ($x - 1))
{
  my $sum = 0;
  my $num = 0;
  my @combination;
  for my $j (0 .. @containers - 1)
  {
    if ($i & (1 << $j))
    {
      $num++;
      $sum += $containers[$j];
      push(@combination, $containers[$j]);
    }
  }
  if ($sum == 150)
  {
    $answer[$num]++;
    push(@combinations, \@combination);
  }
}

my $p1 = 0;
for (my $i = 0; $i < @combinations; $i++)
{
  $p1 += @{$combinations[$i]};
}
print "$p1\n";
my $p2;
my $c = 0;
for (my $i = 0; $i < @combinations; $i++)
{
  if (!defined $p2 || @{$combinations[$i]} < @{$combinations[$p2]})
  {
    $p2 = $i;
    $c = 0;
  }
  if (@{$combinations[$i]} == @{$combinations[$p2]})
  {
    $c++;
  }
}
print @{$combinations[$p2]} . "\n";
print "$c\n";
