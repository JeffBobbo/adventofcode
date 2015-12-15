#!/usr/bin/perl
use warnings;
use strict;

use Data::Dumper;

my $ops = {
  # bitwise
  'LSHIFT'  => { ops => 2, fn => sub { return $_[0] << $_[1]} },
  'RSHIFT'  => { ops => 2, fn => sub { return $_[0] >> $_[1]} },
  'AND' => { ops => 2, fn => sub { return $_[0] & $_[1] } },
  'OR'  => { ops => 2, fn => sub { return $_[0] | $_[1] } },
  'XOR' => { ops => 2, fn => sub { return $_[0] ^ $_[1] } },
  'NOT' => { ops => 1, fn => sub { return ~$_[0] } }
};

open(my $fh, '<', 'day7.txt') or die "Failed to read input file: $!\n";
my @lines = <$fh>;
close($fh);

my $inst = {};

foreach (@lines)
{
  chomp();
  next if (substr($_, 0, 1) eq '#');
  my ($a1, $op, $a2, $t) = ($_ =~ /^(?:([a-z0-9]*) )?(?:([A-Z]+) )?([a-z0-9]+)? -> ([a-z]*)$/);

  my @stack;
  push(@stack, $a1) if (defined $a1 && length($a1));
  push(@stack, $a2) if (defined $a2 && length($a2));

  $inst->{$t} = {stack => \@stack, op => $op};
}

my @targets = qw(a a);
#my @expect = qw(12 65530 4 3 63);
for (my $i = 0; $i < @targets; $i++)
{
  my $t = $targets[$i];
  my $r = value($t);
  print $t . ' = ' . $r;
#  print " -> " . ($expect[$i] == $r ? "good" : "BAD");
  print "\n";
  foreach my $k (keys(%{$inst}))
  {
    delete $inst->{$k}{value};
  }
  $inst->{b}{value} = $r;
}
exit(0);


sub value
{
  my $target = shift();
  die "no target found: $target\n" if (! defined($inst->{$target}));
  $target = $inst->{$target};

  if (exists($target->{value}))
  {
    return $target->{value};
  }

  my @stack = @{$target->{stack}};
  for (my $i = 0; $i < @stack; $i++)
  {
    if ($stack[$i] !~ /^[0-9]+$/)
    {
      $stack[$i] = value($stack[$i]);
    }
    $stack[$i] = int($stack[$i]);
  }

  if (defined ($target->{op}))
  {
    my $ret;
    if (defined $stack[1])
    {
      $ret = $ops->{$target->{op}}{fn}($stack[0], $stack[1]);
    }
    else
    {
      $ret = $ops->{$target->{op}}{fn}($stack[0]);
    }
    return ($target->{value} = $ret & 0xFFFF);
  }
  else
  {
    return ($target->{value} = $stack[0]);
  }
}
