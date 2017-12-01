#!/usr/bin/perl

use warnings;
use strict;

use Switch;


open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my $data = join('', <$fh>);
close($fh);

# puzzle 1
{
  my $x = 0;
  my $y = 0;
  my $places = {0 => {0 => 1}};

  for (my $i = 0; $i < length($data); $i++)
  {
    my $dir = substr($data, $i, 1);

    switch ($dir)
    {
      case '^'
      {
        $y++;
      }
      case 'v'
      {
        $y--;
      }
      case '<'
      {
        $x--;
      }
      case '>'
      {
        $x++;
      }
    }
    $places->{$x}{$y}++;
  }

  my $houses = 0;
  foreach my $i (keys(%{$places}))
  {
    $houses += keys(%{$places->{$i}});
  }
  print 'Santa delivered presents to ' . $houses . ' houses' . "\n";
}

# puzzle 2
{
  my $sx = 0;
  my $sy = 0;
  my $rx = 0;
  my $ry = 0;
  my $places = {0 => {0 => {'s' => 1, 'r' => 1}}};

  my $which = 0; # 0 means santa, 1 means Robo-Santa
  for (my $i = 0; $i < length($data); $i++)
  {
    my $d = substr($data, $i, 1);

    my $x = \$sx;
    my $y = \$sy;
    if (($which & 1) == 1)
    {
      $x = \$rx;
      $y = \$ry;
    }
    switch ($d)
    {
      case '^'
      {
        $$y++;
      }
      case 'v'
      {
        $$y--;
      }
      case '>'
      {
        $$x++;
      }
      case '<'
      {
        $$x--;
      }
    }
    my $p = ($which & 1) == 0 ? 's' : 'r';
    $places->{$$x}{$$y}{$p}++;
    $which++;
  }

  my $houses = 0;
  foreach my $i (keys(%{$places}))
  {
     $houses += keys(%{$places->{$i}}); # we don't care who delivered the present, just that it got delievered
  }
  print 'Santa and Robo-Santa delivered presents to ' . $houses . ' houses' . "\n";
}
