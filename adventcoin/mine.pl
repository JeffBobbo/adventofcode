#!/usr/bin/perl

use warnings;
use strict;

my $PROGFILE = "mine.json";
my $SAVEFILE = "data.csv";

use Sys::MemInfo qw(freemem);
use JSON qw(to_json from_json);
use Digest::MD5 qw(md5_hex);
use Time::HiRes;

use sigtrap 'handler' => \&stop, 'INT';

my $key = "yzbqklnj";

my $digest = "";
my $progress = loadProgress();
my $i = ($progress->{'i'} || 0);
my $start = ms() - ($progress->{ms} || 0);
my @p;
while (memcheck())
{
  $i++;
  my $toHash = $key . $i;
  $digest = md5_hex($toHash);
  my ($zeros) = ($digest =~ /^(0+)/);
  if (defined $zeros && length($zeros) > 3)
  {
    my $l = length($zeros);
    my $t = ms() - $start;
    push(@p, "$l,$i,$digest,$t\n");
  }
}
stop();

sub loadProgress
{
  open(my $fh, '<', $PROGFILE) or return {};
  my $source = join('', <$fh>);
  close($fh);
  return from_json($source);
}

sub saveProgress
{
  my $p = shift();
  open(my $fh, '>', $PROGFILE) or die "$!\n";
  print $fh to_json($p);
  close($fh);
}

sub ms
{
  return int(Time::HiRes::time() * 1000);
}

sub stop
{
  if (freemem() / 1024 / 1024 / 1024 < 0.2)
  {
    print "Really running out of memory, ditching everything\n";
    exit(0);
  }

  open(my $sf, '>>', $SAVEFILE);
  foreach (@p)
  {
    print $sf $_;
  }
  close($sf);

  # save stuff and exit more gracefully
  saveProgress({i => $i, ms => ms() - $start});
  exit(0);
}

sub memcheck
{
  return (freemem() / 1024 / 1024 / 1024 > 0.5)
}
