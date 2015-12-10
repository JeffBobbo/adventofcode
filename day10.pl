#!/usr/bin/perl

use warnings;
use strict;

my $data = 3113322113;

my $i = 0;
for (my $h = 4; $h <= 5; $h++)
{
  for (; $i < 10*$h; $i++)
  {
    my $count = 1;
    my $num = substr($data, 0, 1);
    my $new = "";
    for (my $j = 1; $j <= length($data); $j++)
    {
      my $n = substr($data, $j, 1);
      if (!$n or $n != $num)
      {
        $new .= $count . $num;
        $count = 1;
        $num = $n;
      }
      else
      {
        $count++;
      }
    }
    $data = $new;
  }
  print "Length after " . ($h*10) . " iterations: " . length($data) . "\n";
}
