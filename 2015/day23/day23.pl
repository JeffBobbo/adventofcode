#!/usr/bin/perl

use warnings;
use strict;

open(my $fh, '<', 'input.txt');
my @lines = <$fh>;
close($fh);

my $register = {
  a => $ARGV[0] || 0,
  b => 0
};

my $instructions = {
  hlf => sub {my $r = shift(); $register->{$r} = $register->{$r} >> 1; },
  tpl => sub {my $r = shift(); $register->{$r} *= 3;},
  inc => sub {my $r = shift(); $register->{$r} += 1;}
};

my $i = 0;
while ($i < @lines)
{
  my $line = $lines[$i];
  chomp($line);
  my ($instruction, $variable, $extra) = ($line =~ /([a-z]{3}) ([+-][0-9]+|[ab])(?:, ([+-][0-9]+))?/);

  last if (!defined $instruction);

  if ($instructions->{$instruction})
  {
    $instructions->{$instruction}($variable);
  }
  elsif ($instruction eq 'jmp')
  {
    $variable = substr($variable, 1) if (index($variable, '+') != -1);
    $variable -= 1;
    $i += $variable;
  }
  elsif ($instruction eq 'jie')
  {
    if ($register->{$variable} % 2 == 0)
    {
      $extra = substr($extra, 1) if (index($extra, '+') != -1);
      $extra -= 1;
      $i += $extra;
    }
  }
  elsif ($instruction eq 'jio')
  {
    if ($register->{$variable} == 1)
    {
      $extra = substr($extra, 1) if (index($extra, '+') != -1);
      $extra -= 1;
      $i += $extra;
    }
  }
  $i++;
}
print "a: " . $register->{a} . "\n";
print "b: " . $register->{b} . "\n";
