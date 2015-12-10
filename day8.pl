#!/usr/bin/perl
use warnings;
use strict;

open(my $fh, '<', 'day8.txt') or die "Failed to read input file: $!\n";
my @lines = <$fh>;
close($fh);

my $mem = 0;
my $len = 0;
my $enc = 0;
foreach (@lines)
{
  chomp();
  $mem += length(eval($_));
  $len += length();

  # encode the strings
  s/\\/\\\\/g;
  s/"/\\"/g;
  $_ = '"' . $_ . '"';
  $enc += length($_);
}
print "Code length - memory length: " . ($len-$mem), "\n";
print "Encoded length - code length: " . ($enc-$len), "\n";

exit(0);
