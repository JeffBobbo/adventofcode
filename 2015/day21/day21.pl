#!/usr/bin/perl

use warnings;
use strict;

use Storable qw(dclone);

my $boss = {
  hp => 100,
  atk => 8,
  def => 2
};

my $shop = {
  weapons => {
    dagger     => {cost => 8,   atk => 4, def => 0},
    shortsword => {cost => 10,  atk => 5, def => 0},
    warhammer  => {cost => 25,  atk => 6, def => 0},
    longsword  => {cost => 40,  atk => 7, def => 0},
    greataxe   => {cost => 74,  atk => 8, def => 0}
  },

  armour => {
    no_arour   => {cost => 0,   atk => 0, def => 0},
    leather    => {cost => 13,  atk => 0, def => 1},
    chainmail  => {cost => 31,  atk => 0, def => 2},
    splintmail => {cost => 53,  atk => 0, def => 3},
    bandedmail => {cost => 75,  atk => 0, def => 4},
    platemail  => {cost => 102, atk => 0, def => 5}
  },

  rings => {
    no_ring    => {cost => 0,   atk => 0, def => 0},
    attack1    => {cost => 25,  atk => 1, def => 0},
    attack2    => {cost => 50,  atk => 2, def => 0},
    attack3    => {cost => 100, atk => 3, def => 0},
    defence1   => {cost => 20,  atk => 0, def => 1},
    defence2   => {cost => 40,  atk => 0, def => 2},
    defence3   => {cost => 80,  atk => 0, def => 3}
  }
};

my $minCost = 1000;
my @minGear;
my $maxCost = 0;
my @maxGear;

use Data::Dumper;
foreach my $w (keys(%{$shop->{weapons}}))
{
  my $weapon = $shop->{weapons}{$w};
  foreach my $a (keys(%{$shop->{armour}}))
  {
    my $armour = $shop->{armour}{$a};
    foreach my $r (keys(%{$shop->{rings}}))
    {
      my $ring = $shop->{rings}{$r};
      foreach my $r2 (keys(%{$shop->{rings}}))
      {
        next if ($r ne 'no_ring' && $r eq $r2); # can't buy the same ring twice
        my $ring2 = $shop->{rings}{$r2};
        my $cost = $weapon->{cost} + $armour->{cost} + $ring->{cost} + $ring2->{cost};

        my $atk = $weapon->{atk} + $armour->{atk} + $ring->{atk} + $ring2->{atk};
        my $def = $weapon->{def} + $armour->{def} + $ring->{def} + $ring2->{def};

        my $bClone = dclone($boss);
        my $hp = 100;

        while (1)
        {
          my $pd = $atk - $bClone->{def};
          $bClone->{hp} -= $pd;
          last if ($bClone->{hp} <= 0);
          my $bd = $bClone->{atk} - $def;
          $hp -= $bd;
          last if ($hp <= 0);
        }
        if ($hp > 0)
        {
          if ($cost < $minCost)
          {
            $minCost = $cost;
            @minGear = ($w, $a, $r, $r2);
          }
        }
        else
        {
          if ($cost > $maxCost)
          {
            $maxCost = $cost;
            @maxGear = ($w, $a, $r, $r2);
          }
        }
      }
    }
  }
}

print "The minimum I can spend and win is $minCost, to purchase @minGear.\n";
print "The maximum I can spend and die is $maxCost, to purchase @maxGear.\n";

sub max
{
  return $_[$_[0] > $_[1] ? 0 : 1];
}
