#!/usr/bin/perl

use warnings;
use strict;

open(my $fh, '<', 'input.txt');
my @lines = <$fh>;
close($fh);

my @message;
foreach (@lines)
{
  chomp();
  my @c = split('', $_);
  if (@message < @c)
  {
    push(@message, {}) for (1..@c);
  }

  for (my $i = 0; $i < @c; ++$i)
  {
    $message[$i]->{$c[$i]}++;
  }
}

my $m0 = '';
my $m1 = '';
foreach my $c (@message)
{
  my $most = undef;
  my $least = undef;
  foreach (keys(%{$c}))
  {
    $most = $_ if (!defined $most || $c->{$_} > $c->{$most});
    $least = $_ if (!defined $least || $c->{$_} < $c->{$least});
  }
  $m0 .= $most;
  $m1 .= $least;
}
print "Most common:  $m0\nLeast common: $m1\n";
