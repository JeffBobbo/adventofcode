#!/usr/bin/perl

use warnings;
use strict;

my $data = 3113322113;

for (my $i = 0; $i < 50; $i++)
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
print length($data) . "\n";
