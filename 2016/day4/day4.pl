#!/usr/bin/perl

use warnings;
use strict;

open(my $fh, '<', 'input.txt');
my @lines = <$fh>;
close($fh);

my $rooms = 0;
my $sum = 0;

my %c;
foreach (@lines)
{
  chomp();
  (my $room, my $id, my $checksum) = $_ =~ /(.*)-(\d+)(?:\[(.*)\])?/;


  %c = ();
  foreach (split('', $room))
  {
    $c{$_}++ unless ($_ !~ /[a-z]/);
  }

  my @keys = sort sortby keys(%c);
  my $chk = '';
  for (0..4)
  {
    $chk .= shift(@keys);
  }
  if ($checksum eq $chk)
  {
    ++$rooms;
    $sum += $id;
  }

  my $decrypt = caeser($room, $id);
  if ($decrypt eq 'northpole object storage')
  {
    print "Room: $room, id: $id, checksum: $checksum, generated sum: $chk\n";
  }
}

sub sortby
{
  return $a cmp $b if ($c{$a} == $c{$b});
  return $c{$b} <=> $c{$a};
}

sub caeser
{
  my $str = shift();
  my $amt = shift();

  my $ret = '';
  foreach (split('', $str))
  {
    if ($_ eq '-')
    {
      $ret .= ' ';
    }
    else
    {
      $ret .= chr(((ord($_) - 97 + $amt) % 26) + 97);
    }
  }
  return $ret;
}

print "Rooms: " . $rooms . "\n";
print "ID sum: " . $sum . "\n";
