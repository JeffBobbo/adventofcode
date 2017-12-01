#!/usr/bin/perl
use warnings;
use strict;

use Data::Dumper;

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my @data = <$fh>;
close($fh);


my $in = {};
foreach (@data)
{
  chomp();
  my ($name, $cap, $dur, $fla, $tex, $cal) = (/([a-zA-Z]+): capacity (-?[\d]+), durability (-?[\d]+), flavor (-?[\d]+), texture (-?[\d]+), calories (-?[\d]+)/);

  $in->{$name}{cap} = $cap;
  $in->{$name}{dur} = $dur;
  $in->{$name}{fla} = $fla;
  $in->{$name}{tex} = $tex;
  $in->{$name}{cal} = $cal;
}

my $size = 100;

my @best = ();
my $bestScore = 0;

my $bestMeal = 0;
my @meal = ();

for (my $i = 0; $i < $size; $i++)
{
  for (my $j = 0; $j < $size - $i; $j++)
  {
    for (my $k = 0; $k < $size - $i - $j; $k++)
    {
      my $h = $size - $i - $j - $k;

      my $cap = $i * $in->{Sugar}{cap};
      $cap += $j * $in->{Sprinkles}{cap};
      $cap += $k * $in->{Candy}{cap};
      $cap += $h * $in->{Chocolate}{cap};

      my $dur = $i * $in->{Sugar}{dur};
      $dur += $j * $in->{Sprinkles}{dur};
      $dur += $k * $in->{Candy}{dur};
      $dur += $h * $in->{Chocolate}{dur};

      my $fla = $i * $in->{Sugar}{fla};
      $fla += $j * $in->{Sprinkles}{fla};
      $fla += $k * $in->{Candy}{fla};
      $fla += $h * $in->{Chocolate}{fla};

      my $tex = $i * $in->{Sugar}{tex};
      $tex += $j * $in->{Sprinkles}{tex};
      $tex += $k * $in->{Candy}{tex};
      $tex += $h * $in->{Chocolate}{tex};

      my $cal = $i * $in->{Sugar}{cal};
      $cal += $j * $in->{Sprinkles}{cal};
      $cal += $k * $in->{Candy}{cal};
      $cal += $h * $in->{Chocolate}{cal};

      if ($cap <= 0 || $dur <= 0 || $fla <= 0 || $tex <= 0)
      {
        next;
      }
      my $score = $cap * $dur * $fla * $tex;
      if ($score > $bestScore)
      {
        @best = ($i, $j, $k, $h);
        $bestScore = $score;
      }
      if ($cal == 500 && $score > $bestMeal)
      {
        @meal = ($i, $j, $k, $h);
        $bestMeal = $score;
      }
    }
  }
}

print "The best scoring cookie has a score of " . $bestScore . " and is made of";
print " $best[0] Sugar,";
print " $best[1] Sprinkles,";
print " $best[2] Candy,";
print " $best[3] Chocolate\n";

print "The best scoring meal-cookie has a score of " . $bestMeal . " and is made of";
print " $meal[0] Sugar,";
print " $meal[1] Sprinkles,";
print " $meal[2] Candy,";
print " $meal[3] Chocolate\n";
