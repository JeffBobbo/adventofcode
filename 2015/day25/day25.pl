#!/usr/bin/perl

use warnings;
use strict;

<<<<<<< HEAD
open(my $fh, '<', 'input.txt');
chomp(my @lines = <$fh>);
close($fh);

my ($row) = ($lines[0] =~ /row (\d+)/);
my ($column) = ($lines[0] =~ /column (\d+)/);

my $last = 20151125;
my $mult = 252533;
my $divisor = 33554393;

my $y = 2;

my $grid = {1 => {$y => $last}};

my $done = 0;
while (!$done)
{
  my $xc = 1;
  my $yc = $y;
  while ($yc > 0 && $xc > 0)
  {
    my $new = ($last * $mult) % $divisor;
    $grid->{$xc}{$yc} = $new;
    $last = $new;
    if ($xc == $row && $yc == $column)
    {
      print "\n\n" . $grid->{$xc}{$yc} . "\n";
      $done = 1;
    }
    $xc++;
    $yc--;
  }
  $y++;
}

for (my $i = 1; $i < 7; $i++)
{
  print "$i\t";
}
print "\n";
for (my $i = 1; $i < 7; $i++)
{
  for (my $j = 1; $j < 7; $j++)
  {
    print $j . "\t" . $grid->{$i}{$j} . "\t";
  }
  print "\n";
}
=======
my $start = 20151125;
my $mult  = 252533;
my $mod   = 33554393;
my $code = $start;

my $row = 3010;
my $col = 3019;

my $x = 1;
my $y = 1;
my $maxY = 1;

while ($x != $col || $y != $row)
{
  $code *= $mult;
  $code %= $mod;
  if ($y > 1)
  {
    $x++;
    $y--;
  }
  else
  {
    $maxY++;
    $x = 1;
    $y = $maxY;
  }
}
print "$code\n";
>>>>>>> 010983ffb45dbac9ff3aaa35c0678b2f85243a73
