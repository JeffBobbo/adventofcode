#!/usr/bin/perl

use warnings;
use strict;

use Digest::MD5 qw(md5_hex);

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my $key = chomp(join('', <$fh>));
close($fh);

my $i = 0;
my $digest = "";
while ($digest !~ /^0{5,}/)
{
  $i++;
  my $toHash = $key . $i;
  $digest = md5_hex($toHash);
}
print 'Puzzle 1: AdventCoin mined: ' . $digest . ' at ' . $i . "\n";

# puzzle 2
{
  my $i = 0;
  my $digest = "";
  while ($digest !~ /^0{6,}/)
  {
    $i++;
    my $toHash = $key . $i;
    $digest = md5_hex($toHash);
  }
  print 'Puzzle 2: AdventCoin mined: ' . $digest . ' at ' . $i . "\n";
}
