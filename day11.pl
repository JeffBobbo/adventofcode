#!/usr/bin/perl
use warnings;
use strict;

use Data::Dumper;

my $data = "vzbxkghb";

for (my $n = 0; $n < 2; $n++)
{
  my $okay = 0;
  do
  {
    $okay = 0;

    $data++;

    for (my $i = 0; $i < length($data) - 3; $i++)
    {
      my $c = substr($data, $i, 1);
      if (ord(substr($data, $i+1, 1)) == ord($c)+1 && ord(substr($data, $i+2, 1)) == ord($c)+2)
      {
        $okay = 1;
        last;
      }
    }
    $okay = 0 if ($data !~ /([a-z])\1.*([a-z])\2/);
    $okay = 0 if ($data =~ /[iol]/);
  }
  while ($okay == 0);

print "Santa's password: $data\n";
}
