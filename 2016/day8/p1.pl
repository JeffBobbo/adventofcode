#!/usr/bin/perl

use warnings;
use strict;

use Data::Dumper;

use constant {
  WIDTH => 50,
  HEIGHT => 6
};

open(my $fh, '<', 'input.txt') or die "$!\n";
my @lines = <$fh>;
close($fh);

my @grid;
for (my $i = 0; $i < WIDTH; ++$i)
{
  my @col;
  for (my $j = 0; $j < HEIGHT; ++$j)
  {
    push(@col, 0);#($i+1)*($j+1));
  }
  push(@grid, \@col);
}

foreach (@lines)
{
  if ($_ =~ /rect (\d+)x(\d+)/)
  {
    for (my $i = 0; $i < $1; ++$i)
    {
      for (my $j = 0; $j < $2; ++$j)
      {
        $grid[$i]->[$j] = 1;
      }
    }
  }
  elsif ($_ =~ /rotate ((?:row y=)|(?:column x=))(\d+) by (\d+)/)
  {
    if (substr($1, 0, 3) eq 'row')
    {
      for (my $n = 0; $n < $3; ++$n)
      {
        my $last = $grid[-1]->[$2];
        for (my $i = @grid -1; $i > 0; --$i)
        {
          $grid[$i]->[$2] = $grid[$i-1]->[$2];
        }
        $grid[0]->[$2] = $last;
      }
    }
    elsif (substr($1, 0, 3) eq 'col')
    {
      my $col = $grid[$2];
      for (my $i = 0; $i < $3; ++$i)
      {
        unshift(@{$col}, pop(@{$col}));
      }
    }
  }
}
printGrid(\@grid);
print "\n";
printGrid(\@grid, 1);


sub printGrid
{
  my $grid = shift();
  my $block = shift();
  for (my $i = 0; $i < HEIGHT; ++$i)
  {
    foreach (@{$grid})
    {
      if ($block)
      {
        if ($_->[$i])
        {
          print "# ";
        }
        else
        {
          print "  ";
        }
      }
      else
      {
        print $_->[$i] . " ";
      }
    }
    print "\n";
  }
}
