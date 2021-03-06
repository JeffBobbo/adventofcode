#!/usr/bin/perl

use warnings;
use strict;

use Image::Magick;
use Switch;

$| = 1; # turn off buffering to print our %

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my $data = join('', <$fh>);
close($fh);
# puzzle 1
{
  my $x = 0;
  my $y = 0;
  my $places = {0 => {0 => 1}};

  my $x1 = 0;
  my $x2 = 0;
  my $y1 = 0;
  my $y2 = 0;

  print "Puzzle 1, reading input: NA%";
  for (my $i = 0; $i < length($data); $i++)
  {
    my $percent = $i / length($data);
    print "\b" x 3;
    printf("%02d%%", $percent*100);
    my $dir = substr($data, $i, 1);

    switch ($dir)
    {
      case '^'
      {
        $y++;
        $y2++ if ($y > $y2);
      }
      case 'v'
      {
        $y--;
        $y1++ if ($y < -$y1);
      }
      case '<'
      {
        $x--;
        $x2++ if ($x < -$x2);
      }
      case '>'
      {
        $x++;
        $x1++ if ($x > $x1);
      }
    }
    $places->{$x}{$y}++;
  }
  print "\n";

  my $image = Image::Magick->new;
  my $size = (($x1 + $x2)*2) . 'x' . (($y1 + $y2)*2);
  $image->Set(size=>$size);
  $image->ReadImage("canvas:black");

  my $houses = 0;
  print "Puzzle 1, rendering...\n";
  print "Image size: $size\n";
  foreach my $i (keys(%{$places}))
  {
    $houses += keys(%{$places->{$i}});
    foreach my $j (keys(%{$places->{$i}}))
    {
      my $x = int(($x1 + $x2)) + $i;
      my $y = int(($y1 + $y2)) + $j;
      $image->Set("pixel[$x,$y]"=>'red');
    }
  }
  my $e = $image->Write('day3p1.png');
  warn "$e\n" if "$e";
  print 'Santa delivered presents to ' . $houses . ' houses' . "\n";
}

# puzzle 2
{
  my $sx = 0;
  my $sy = 0;
  my $rx = 0;
  my $ry = 0;
  my $places = {0 => {0 => {'s' => 1, 'r' => 1}}};

  my $x1 = 0;
  my $x2 = 0;
  my $y1 = 0;
  my $y2 = 0;

  print "Puzzle 2, reading input: NA%";


  my $which = 0; # 0 means santa, 1 means Robo-Santa
  for (my $i = 0; $i < length($data); $i++)
  {
    my $percent = $i / length($data);
    print "\b" x 3;
    printf("%02d%%", $percent*100);

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
        $y2++ if ($$y > $y2);
      }
      case 'v'
      {
        $$y--;
        $y1++ if ($$y < -$y1);
      }
      case '>'
      {
        $$x++;
        $x2++ if ($$x < -$x2);
      }
      case '<'
      {
        $$x--;
        $x1++ if ($$x > $x1);
      }
    }
    my $p = ($which & 1) == 0 ? 's' : 'r';
    $places->{$$x}{$$y}{$p}++;
    $which++;
  }
  print "\n";

  my $image = Image::Magick->new;
  my $size = (($x1 + $x2)*2) . 'x' . (($y1 + $y2)*2);
  $image->Set(size=>$size);
  $image->ReadImage("canvas:black");

  print "Puzzle 2, rendering...\n";
  print "Image size: $size\n";
  my $houses = 0;
  foreach my $i (keys(%{$places}))
  {
    $houses += keys(%{$places->{$i}}); # we don't care who delivered the present, just that it got delievered
    foreach my $j (keys(%{$places->{$i}}))
    {
      my $colour = 'red';
      if ($places->{$i}{$j}{r} && $places->{$i}{$j}{s})
      {
        $colour = 'yellow';
      }
      elsif ($places->{$i}{$j}{r})
      {
        $colour = 'green';
      }

      my $x = int(($x1 + $x2)) + $i;
      my $y = int(($y1 + $y2)) + $j;
      $image->Set("pixel[$x,$y]"=>$colour);
    }
  }
  my $e = $image->Write('day3p2.png');
  warn "$e\n" if "$e";
  print 'Santa and Robo-Santa delivered presents to ' . $houses . ' houses' . "\n";
}
