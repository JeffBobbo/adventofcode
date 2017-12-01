#!/usr/bin/perl

use warnings;
use strict;

use Digest::MD5 qw(md5_hex);

my $key = "wtnhxymk";

my $password1 = '';
my @password2 = (undef, undef, undef, undef, undef, undef, undef, undef);
my $done = 0;
my $i = 0;
while ($done == 0 || length($password1) < 8)
{
  my $toHash = $key . $i++;
  my $digest = md5_hex($toHash);
  my ($zeros, $first, $second) = ($digest =~ /^(0{5})(.)(.)/);
  if (length($password1) < 8 && defined $zeros && length($zeros) == 5 && defined $first)
  {
    $password1 .= $first;
  }
  if (!$done && defined $zeros && length($zeros) == 5 && defined $second)
  {
    next if ($first !~ /[0-7]/);
    if (!defined $password2[$first])
    {
      $password2[$first] = $second;
    }
    $done = 1;
    foreach (@password2)
    {
      $done = 0 if (!defined $_)
    }
  }
}
print $password1 . "\n";
print join('', @password2) . "\n";
