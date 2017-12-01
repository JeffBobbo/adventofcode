#!/usr/bin/perl

use warnings;
use strict;

use Switch;
use Data::Dumper;



my %inst = (
  'U' => [0, -1],
  'D' => [0, +1],
  'L' => [-1, 0],
  'R' => [+1, 0],
);

#part 1
print "Part 1:\n";
{
  my $pad =
  [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ];

  # start at 5
  my @p = (1, 1);

  open(my $fh, '<', 'input.txt');
  my @input = <$fh>;
  close($fh);

  foreach (@input)
  {
    foreach (split('', $_))
    {
      chomp();
      next unless (length());
      @p = (max(0, min(2, $p[0]+$inst{$_}->[0])),
            max(0, min(2, $p[1]+$inst{$_}->[1])))
    }
    print $pad->[$p[1]]->[$p[0]] . "\n";
  }
}

print "\nPart 2:\n";
#part 2
{
  my $pad =
  [
    [undef, undef,   1, undef, undef],
    [undef,     2,   3,     4, undef],
    [    5,     6,   7,     8,     9],
    [undef,   'A', 'B',   'C', undef],
    [undef, undef, 'D', undef, undef]
  ];

  my @p = (0, 2); # start at 5

  open(my $fh, '<', 'input.txt');
  my @input = <$fh>;
  close($fh);

  foreach (@input)
  {
    foreach (split('', $_))
    {
      chomp();
      next unless (length());
      my $x = max(0, min(4, $p[0]+$inst{$_}->[0]));
      my $y = max(0, min(4, $p[1]+$inst{$_}->[1]));
      @p = ($x, $y) if (defined $pad->[$y]->[$x]);
    }
    print $pad->[$p[1]]->[$p[0]] . "\n";
  }
}

sub min { return $_[0] < $_[1] ? $_[0] : $_[1] }
sub max { return $_[0] > $_[1] ? $_[0] : $_[1] }
