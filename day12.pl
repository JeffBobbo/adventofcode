#!/usr/bin/perl
use warnings;
use strict;

use Data::Dumper;
use JSON qw(from_json);
use Sys::MemInfo qw(freemem);

open(my $fh, '<', 'day12.json');
my $data = from_json(join('', <$fh>));
close($fh);
#my $data = '';

my $t = 0;
my $r = 0;
parse($data);
print "$t\n$r\n";

sub parse
{
  memcheck();
  my $d = shift();
  my $b = shift() || 0;
  if (ref($d) eq 'ARRAY')
  {
    foreach (@{$d})
    {
      parse($_);
    }
  }
  elsif (ref($d) eq 'HASH')
  {
    foreach my $key (keys(%{$d}))
    {
      if ($d->{$key} eq "red")
      {
        $b = 1;
      }
    }
    foreach my $key (keys(%{$d}))
    {
      parse($d->{$key}, $b);
    }
  }
  else
  {
    if ($d =~ /^[\-0-9]+$/)
    {
      $t += $d;
      $r += $d if (!$b);
    }
  }
}

sub memcheck
{
  if (freemem() / 1024 / 1024 / 1024 < 0.5)
  {
    exit();
  }
}