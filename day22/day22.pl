#!/usr/bin/perl

use warnings;
use strict;

use Storable qw(dclone);

my $hard = ($ARGV[0] && $ARGV[0] eq 'hard') || 0;
print "Hard mode activatied\n" if ($hard);

my $boss = {
  hp => 51,
  dmg => 9
};

my $spells = {
  magic_missile => {cost => 53,  dmg => 4},
  drain         => {cost => 73,  dmg => 2, heal => 2},
  shield        => {cost => 113, dur => 6, def  => 7},
  poison        => {cost => 173, dur => 6, dmg  => 3},
  recharge      => {cost => 229, dur => 5, mana => 101}
};

my $player = {
  hp => 50,
  mana => 500,
  def => 0,

  shield   => -1, # the turn the effect expires, e.g. 3 means they get the effect on any turn 3 or under, but not on 4 or higher
  poison   => -1,
  recharge => -1,
};

# I'm being lazy and using randomization to hopefully find the best answer instead of doing it properly
my $iterations = 5e5;

# @casts is what the best mana use requires to be cast
my @casts;
my $best = 'Infinity';
my $hp;
for my $z (0..$iterations)
{
  my $mana = 0;
  my $turn = 0;
  # make clones, keep original data intact.
  my $p = dclone($player);
  my $b = dclone($boss);
  my @cast; # what we've cast this iteration
  while (1)
  {
    if ($hard && ($turn % 2) == 0)
    {
      $p->{hp} -= 1;
      last if ($p->{hp} <= 0);
    }
    # process any running effects
    if ($p->{shield} >= $turn)
    {
      $p->{def} = $spells->{shield}{def};
    }
    else
    {
      $p->{def} = 0;
    }
    if ($p->{poison} >= $turn)
    {
      $b->{hp} -= $spells->{poison}{dmg};
      last if ($b->{hp} <= 0); # did our poison kill the boss?
    }
    if ($p->{recharge} >= $turn)
    {
      $p->{mana} += $spells->{recharge}{mana};
    }

    if (($turn % 2) == 0) # is it our turn
    {
      # find out which spells are available
      my @available;
      foreach my $sName (keys(%{$spells}))
      {
        my $spell = $spells->{$sName};
        next if ($spell->{cost} > $p->{mana}); # this costs too much
        next if ($spell->{dur} && $p->{$sName} >= $turn); # this spell has a duration and it's active
        push(@available, $sName);
      }
      # if there aren't any spells to cast, commit seppuku
      if (@available == 0)
      {
        $p->{hp} = 0;
        last;
      }

      # choose a spell at random
      my $w = random(scalar(@available));
      my $spell = $available[$w];

      $p->{mana} -= $spells->{$spell}{cost}; # take the cost
      $mana += $spells->{$spell}{cost}; # and add how much we spent

      # and store what we done
      push(@cast, $spell);

      # do the spell
      if ($spell eq 'magic_missile' || $spell eq 'drain')
      {
        $b->{hp} -= $spells->{$spell}{dmg};
        $p->{hp} += ($spells->{$spell}{hp} || 0);
      }
      else
      {
        $p->{$spell} = $turn + $spells->{$spell}{dur};
      }
      last if ($b->{hp} <= 0); # did our attack kill the boss?
      }
    else # the boss hits back
    {
      my $d = max($b->{dmg} - $p->{def}, 1);
      $p->{hp} -= $d;
      last if ($p->{hp} <= 0); # did the boss kill us?
    }
    $turn++;
  } # while (1)
  if ($p->{hp} > 0) # did we win?
  {
    if ($mana < $best)
    {
      @casts = @cast;
      $best = $mana;
      $hp = $p->{hp};
    }
  }
  printf("\r%02.2f%%", $z / $iterations * 100);
}
print "\n";
print "Mana used to win: $best\n";
print "Spells cast: @casts\n";
print "Health remaining: $hp\n";

sub max
{
  return $_[$_[0] > $_[1] ? 0 : 1];
}

sub random
{
  return int(rand(shift()));
}
