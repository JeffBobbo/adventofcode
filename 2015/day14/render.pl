#!/usr/bin/perl
use warnings;
use strict;

use GD;
use GD::Image::AnimatedGif;
use Sys::MemInfo qw(freemem);
use Data::Dumper;
use Storable qw(dclone);

$|=1;

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my @lines = <$fh>;
close($fh);

my $reindeers = {};

foreach (@lines)
{
  chomp();
  my ($name, $speed, $duration, $rest) = (/^([a-zA-Z]+) can fly ([0-9]+) km\/s for ([0-9]+) seconds, but then must rest for ([0-9]+) seconds.$/);

  $reindeers->{$name}{speed} = $speed;
  $reindeers->{$name}{duration} = $duration;
  $reindeers->{$name}{rest} = $rest;
  $reindeers->{$name}{distance} = 0;
  $reindeers->{$name}{points} = 0;
}

# how long the race should run, in seconds
my $raceDuration = 2503;

my $sideWidth = 100;
my $barWidth = 40;
my $barHeight = 20;
my $barPadding = 4;

my $raceWidth = 600;

my $imgHeight = int(keys(%{$reindeers})) * ($barHeight + $barPadding) + (2 * $barPadding);
my $image = GD::Image->new($raceWidth + $sideWidth * 2, $imgHeight);
my $black = $image->colorAllocate(0x00, 0x00, 0x00);
my $white = $image->colorAllocate(0xFF, 0xFF, 0xFF);
my $red   = $image->colorAllocate(0xFF, 0x00, 0x00);
my $lblue  = $image->colorAllocate(0x00, 0x7F, 0xFF);
my @frames = ();

my $winner;
my $frameHandler = sub {
  my $frame = shift();
  my $reindeer = shift();

  # find the best reindeer first
  my @names = sort(keys(%{$reindeer}));
  my $best = $names[0];
  my $worst = $names[0];
  my $points = $names[0];
  foreach my $name (@names)
  {
    $best = $name if ($reindeer->{$name}{distance} > $reindeer->{$best}{distance});
    $worst = $name if ($reindeer->{$name}{distance} < $reindeer->{$worst}{distance});
    $points = $name if ($reindeer->{$name}{points} > $reindeer->{$points}{points});
  }

  # calculate our offset
  my $offset = $reindeer->{$best}{distance} - ($raceWidth / 2); # as an average of the two positions

  for (my $i = 100; $i < $raceDuration; $i += 100)
  {
    next if ($i < $offset + $sideWidth);
    next if ($i > $offset + $raceWidth);
    $frame->line($i - $offset, 0, $i - $offset, $imgHeight, $lblue);
    $frame->string(gdLargeFont, $i + 4 - $offset, $imgHeight - 20, $i, $lblue);
  }

  if ($raceDuration > $offset && $raceDuration < $offset + $raceWidth)
  {
    $frame->line($raceDuration - $offset, 0, $raceDuration - $offset, $imgHeight, $red);
  }

  for (my $i = 0; $i < @names; $i++)
  {
    my $name = $names[$i];
    my $x1 = $reindeer->{$name}{distance};
    $winner = $name if (!$winner && $x1 > $raceDuration);
    my $y1 = ($barPadding + $barHeight) * $i + $barPadding;
    my $x2 = $x1 + $barWidth;
    my $y2 = $y1 + $barHeight;
    next if ($x1 < $offset); # don't draw those that are too far behind
    if ((!$winner && $best eq $name) || ($winner && $winner eq $name))
    {
      $frame->string(gdGiantFont, $barPadding, $y1, $name, $red);
      $frame->filledRectangle($x1 - $offset, $y1, $x2 - $offset, $y2, $red);
    }
    else
    {
      $frame->string(gdGiantFont, $barPadding, $y1, $name, $white);
      $frame->filledRectangle($x1 - $offset, $y1, $x2 - $offset, $y2, $white);
    }
    $frame->string(gdGiantFont, $x1 - $offset + 2, $y1 + 2, $x1, $lblue);
    $frame->string(gdGiantFont, $sideWidth + $raceWidth, $y1, $reindeer->{$name}{points}, $points eq $name ? $red : $white);
  }
};

for (my $i = 0; $i <= $raceDuration; $i++)
{
  memcheck();
  my $percent = $i / $raceDuration;
  print "\b" x 3;
  printf("%02d%%", $percent*100);
  foreach my $name (keys(%{$reindeers}))
  {
    my $reindeer = $reindeers->{$name};
    my $period = $reindeer->{duration}+$reindeer->{rest};

    my $current = $i % $period;
    if ($current < $reindeer->{duration})
    {
      $reindeer->{distance} += $reindeer->{speed};
    }
  }
  my @leads = findLeads('distance');

  foreach my $lead (@leads)
  {
    $reindeers->{$lead}{points}++;
  }

  push(@frames, dclone($reindeers)) if ($i % 1 == 0 || $i == $raceDuration);
}

print "\nWriting out image, " . @frames . " frames\n";
open($fh, '>', 'day14.gif');
binmode($fh);
print $fh $image->animated_gif(1, undef, undef, 1, undef, undef, \@frames, $frameHandler);
close($fh);

my $dist = (findLeads('distance'))[0];
print "$dist wins with " . $reindeers->{$dist}{distance} . " km\n";
my $points = (findLeads('points'))[0];
print "$points wins with " . $reindeers->{$points}{points} . " points\n";
exit();

sub findLeads
{
  my $what = shift();
  my @leads;
  my $at = 0;
  foreach my $name (keys(%{$reindeers}))
  {
    if ($reindeers->{$name}{$what} > $at)
    {
      @leads = ($name);
      $at = $reindeers->{$name}{$what};
    }
    elsif ($reindeers->{$name}{$what} == $at)
    {
      push(@leads, $name);
    }
  }
  return @leads;
}

sub findLasts
{
  my $what = shift();
  my @lasts;
  my $at;
  foreach my $name (keys(%{$reindeers}))
  {
    if (!defined $at || $reindeers->{$name}{$what} < $at)
    {
      @lasts = ($name);
      $at = $reindeers->{$name}{$what};
    }
    elsif ($reindeers->{$name}{$what} == $at)
    {
      push(@lasts, $name);
    }
  }
  return @lasts;
}

sub memcheck
{
  if (freemem() / 1024 / 1024 / 1024 < 0.5)
  {
    print "OOM\n";
    exit(1);
  }
}
