#!/usr/bin/perl

use warnings;
use strict;

use GD::Image::AnimatedGif;
use Switch;
use Sys::MemInfo qw(freemem);
use Data::Dumper;
use Storable qw(dclone);

$| = 1; # turn off buffering to print our %

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my $data = join('', <$fh>);
close($fh);
# puzzle 1
{
  my $x = 0;
  my $y = 0;
  my $places = {0 => {0 => 1}};

  my $width = 300;

  my $image = GD::Image->new($width, $width);
  my $black = $image->colorAllocate(0x00, 0x00, 0x00);
  my $red   = $image->colorAllocate(0xFF, 0x00, 0x00);

  my $frame_handler = sub {
    my $frame = shift();
    my $grid = shift();
    foreach my $x (keys(%{$grid}))
    {
      foreach my $y (keys(%{$grid->{$x}}))
      {
        $frame->setPixel($x+($width / 2), $y+($width / 2), $red);
      }
    }
  };

  print "Puzzle 1, reading input...\n";
  my @frames = ();
  for (my $i = 0; $i < length($data); $i++)
  {
    memcheck();
    my $percent = $i / length($data);
    printf("\r%02d%%", $percent*100);
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
    push(@frames, dclone($places)) if ($i % 16 == 0 || $i+1 == length($data));
  }
  print "\nWriting out image, " . @frames . " frames\n";
  open(my $fh, '>', 'day3p1.gif');
  binmode($fh);
  print $fh $image->animated_gif(1, undef, undef, 2, undef, undef, \@frames, $frame_handler);
  close($fh);


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

  my $width = 300;

  my $image = GD::Image->new($width, $width);
  my $black = $image->colorAllocate(0x00, 0x00, 0x00);
  my $red   = $image->colorAllocate(0xFF, 0x00, 0x00);
  my $green = $image->colorAllocate(0x00, 0xFF, 0x00);
  my $yellow= $image->colorAllocate(0xFF, 0xFF, 0x00);

  my $frame_handler = sub {
    my $frame = shift();
    my $grid = shift();
    foreach my $x (keys(%{$grid}))
    {
      foreach my $y (keys(%{$grid->{$x}}))
      {
        my $col = $red;
        if ($grid->{$x}{$y}{r} && $grid->{$x}{$y}{s})
        {
          $col = $yellow;
        }
        elsif ($grid->{$x}{$y}{r})
        {
          $col = $green;
        }
        $frame->setPixel($x+($width / 2), $y+($width / 2), $col);
      }
    }
  };
  my @frames;

  print "Puzzle 2, reading input: NA%";
  for (my $i = 0; $i < length($data); $i++)
  {
    memcheck();
    my $percent = $i / length($data);
    print "\b" x 3;
    printf("%02d%%", $percent*100);

    my $d = substr($data, $i, 1);

    my $x = \$sx;
    my $y = \$sy;
    if (($i & 1) == 1)
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
    my $p = ($i & 1) == 0 ? 's' : 'r'; # using loop control to select person
    $places->{$$x}{$$y}{$p}++;
    push(@frames, dclone($places)) if ($i % 16 == 0 || $i+1 == length($data));
  }
  print "\nWriting out image, " . @frames . " frames\n";
  open(my $fh, '>', 'day3p2.gif');
  binmode($fh);
  print $fh $image->animated_gif(1, undef, undef, 2, undef, undef, \@frames, $frame_handler);
  close($fh);

  my $houses = 0;
  foreach my $i (keys(%{$places}))
  {
    $houses += keys(%{$places->{$i}}); # we don't care who delivered the present, just that it got delievered
  }
  print 'Santa and Robo-Santa delivered presents to ' . $houses . ' houses' . "\n";
}

sub memcheck
{
  if (freemem() / 1024 / 1024 / 1024 < 1)
  {
    print "OOM!\n";
    exit(1);
  }
}
