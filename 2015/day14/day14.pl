#!/usr/bin/perl
use warnings;
use strict;

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

for (my $i = 0; $i <= 2503; $i++)
{
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
}

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
