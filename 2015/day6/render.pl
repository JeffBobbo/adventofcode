#!/usr/bin/perl

use warnings;
use strict;

use GD::Image::AnimatedGif;
use Sys::MemInfo qw(freemem);
use Storable qw(dclone);

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my @lines = <$fh>;
close($fh);

my $grid = {};
$|=1;

my $width = 1000;
my $image = GD::Image->new($width, $width);
my $blue = $image->colorAllocate(0x00, 0x00, 0xFF);
$image->transparent($blue);
my $white = $image->colorAllocate(0xFF, 0xFF, 0xFF);
my $black = $image->colorAllocate(0x00, 0x00, 0x00);
my @frames;
my $colCache = {};

my $frame_handler = sub {
  my $frame = shift();
  my $lights = shift();

  foreach my $x (keys(%{$lights}))
  {
    foreach my $y (keys(%{$lights->{$x}}))
    {
      #my $c = int(lerp(0, 31, $lights->{$x}{$y}{p2} / 42)) << 3;
      #$colCache->{$c} = $image->colorAllocate($c, $c, $c) if (!exists($colCache->{$c}));
      #$frame->setPixel($x+($width / 2), $y+($width / 2), $colCache->{$c});
      if ($lights->{$x}{$y}{p1})
      {
        $frame->setPixel($x+($width / 2), $y+($width / 2), $white);
      }
      else
      {
        $frame->setPixel($x+($width / 2), $y+($width / 2), $black);
      }
    }
  }
};

for (my $i = 0; $i < @lines/3; $i++)
{
  memcheck();
  my $percent = $i / @lines;
  printf("\r%02d%%", $percent*100);
  my $line = $lines[$i];
  chomp($line);
  my @coord1 = ($1, $2) if ($line =~ /([0-9]{1,3}),([0-9]{1,3}) through/);
  my @coord2 = ($1, $2) if ($line =~ /([0-9]{1,3}),([0-9]{1,3})$/);
  my $op = $1 if ($line =~ /^(.*?) [0-9]/);
  #print " $op, @coord1, @coord2\n";
  for (my $x = $coord1[0]; $x <= $coord2[0]; ++$x)
  {
    for (my $y = $coord1[1]; $y <= $coord2[1]; ++$y)
    {
      if ($op eq "turn on")
      {
        $grid->{$x}{$y}{p1} = 1;
        $grid->{$x}{$y}{p2}++;
      }
      if ($op eq "turn off")
      {
        $grid->{$x}{$y}{p1} = 0;
        $grid->{$x}{$y}{p2} = max(($grid->{$x}{$y}{p2} || 0) - 1, 0);
      }
      if ($op eq "toggle")
      {
        $grid->{$x}{$y}{p1} = !($grid->{$x}{$y}{p1});
        $grid->{$x}{$y}{p2} += 2;
      }
    }
  }
  push(@frames, dclone($grid)) if ($i % 16 == 0 || $i+1 == @lines);
}
print "\nWriting out image, " . @frames . " frames\n";
open($fh, '>', 'day6.gif');
binmode($fh);
print $fh $image->animated_gif(1, undef, undef, 2, undef, undef, \@frames, $frame_handler);
close($fh);

my $lit = 0;
my $brightness = 0;
foreach my $x (keys %$grid)
{
  foreach my $y (keys %{$grid->{$x}})
  {
    $lit++ if ($grid->{$x}{$y}{p1} == 1);
    $brightness += $grid->{$x}{$y}{p2};
  }
}
print "There are $lit lights.\n";
print "The brightness is $brightness\n";


sub memcheck
{
  if (freemem() / 1024 / 1024 / 1024 < 0.5)
  {
    print "Running out of RAM, bye!\n";
    exit(1);
  }
}

sub lerp
{
  my $min = shift();
  my $max = shift();
  my $p = shift();

  return (1 - $p) * $min + ($p * $max);
}

sub max
{
  return $_[$_[0] > $_[1] ? 0 : 1];
}
