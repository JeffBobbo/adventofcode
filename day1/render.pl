#!/usr/bin/perl

use warnings;
use strict;

use Switch;
use Data::Dumper;
use Image::Magick;

$| = 1; # turn off buffering to print our %


open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my $data = join('', <$fh>);
close($fh);

my $floor = 0;
my $basement = -1;
my $last = -1;

my $x = 5; # where we are on the render
my $ymin = 0;
my $ymax = 0;
my $image = Image::Magick->new();
my $width = int(length($data));
my $y = $width/2; # y offset
$image->Set(size=>$width.'x'.$width);
$image->Read("canvas:white");
for (my $i = 0; $i < length($data); $i++)
{
  my $percent = $i / length($data);
  print "\b" x 3;
  printf("%02d%%", $percent*100);

  my $dir = 0;

  if (substr($data, $i, 1) eq '(')
  {
    $dir = 1;
  }
  else
  {
    $dir = -1;
  }
  if ($dir != $last)
  {
    $x++;
    $last = $dir;
  }
  $floor += $dir;

  # keep track of ymax and min for resizing
  $ymax = $floor if ($floor > $ymax);
  $ymin = -$floor if ($floor < -$ymin);

  $image->Set("pixel[$x,".($y+$floor)."]"=>"red");
  if ($basement == -1 && $floor == -1)
  {
    $basement = $i+1;
    $image->Draw(stroke=>"blue", primitive=>"line", points=>($x-10).','.($y+$floor-10).' '.($x+10).','.($y+$floor+10));
    $image->Draw(stroke=>"blue", primitive=>"line", points=>($x+10).','.($y+$floor-10).' '.($x-10).','.($y+$floor+10));
  }
}
my $height = ($ymin + $ymax);
$image->Crop(width=>$x+5, height=>$height+10, x=>0, y=>$y-$ymin-10);
print "\n$x\n";
my $e = $image->Write("day1.png");
warn "$e\n" if "$e";
print "Santa is on floor $floor\n";
print "Santa enters the basement at $basement\n";
