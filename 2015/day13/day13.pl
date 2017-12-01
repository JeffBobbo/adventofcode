#!/usr/bin/perl
use warnings;
use strict;

use List::Permutor;

open(my $fh, '<', 'input.txt') or die "Failed to read input file: $!\n";
my @lines = <$fh>;
close($fh);

my $table = {};

foreach (@lines)
{
  chomp();
  my ($p1, $mult, $happiness, $p2) = (/^([a-zA-Z]+) would (gain|lose) ([0-9]+) happiness units by sitting next to ([a-zA-Z]+).$/);

  $happiness *= -1 if ($mult eq 'lose');

  $table->{$p1}{$p2} = $happiness;
}

if ($ARGV[0] && $ARGV[0] eq 'me')
{
  foreach (keys(%{$table}))
  {
    $table->{me}{$_} = 0;
    $table->{$_}{me} = 0;
  }
}

my $p = List::Permutor->new(keys(%{$table}));
my @happy;
my $hb;
my @sad;
my $sb;
while (my @set = $p->next())
{
  my $h = 0;
  for (my $i = 0; $i < @set; $i++)
  {
    my $l = ($i - 1 + @set) % @set;
    my $r = ($i + 1 + @set) % @set;

    $h += $table->{$set[$i]}{$set[$l]};
    $h += $table->{$set[$i]}{$set[$r]};
  }
  if (!defined $sb || $h < $sb)
  {
    @sad = @set;
    $sb = $h;
  }
  if (!defined $hb || $h > $hb)
  {
    @happy = @set;
    $hb = $h;
  }
}
print "Happiest arrangement is @happy, for $hb happiness\n";
print "Sadist arrangement is @sad, for $sb happiness\n";
