#! /usr/local/bin/perl -w

# #(@) $Id: example.pl 1.2 Sun, 16 Sep 2001 23:26:31 +0200 mxp $
# Example program illustrating the use of User::Utmp.

use lib './blib/lib', './blib/arch';
use Getopt::Std;
use User::Utmp;
use Socket;
use strict;

my %options; getopts('a:hux', \%options);

my @utmp;
my %ut_type = (BOOT_TIME() => "BOOT_TIME",
	       DEAD_PROCESS() => "DEAD_PROCESS",
	       EMPTY() => "EMPTY",
	       INIT_PROCESS() => "INIT_PROCESS",
	       LOGIN_PROCESS() => "LOGIN_PROCESS",
	       NEW_TIME() => "NEW_TIME",
	       OLD_TIME() => "OLD_TIME",
	       RUN_LVL() => "RUN_LVL",
	       USER_PROCESS() => "USER_PROCESS");

###############################################################################

if ($options{h})
{
   print "Usage: $0 [-a <file>] [-hux]\n";
   print <<EOT;

       -a <file> Use alternative utmp/utmpx file named <file>
       -h        Show this help message and exit
       -u        Show only records of type USER_PROCESS
       -x        Use utmpx
EOT
    exit;
}

if ($options{a})
{
   User::Utmp::utmpname($options{a});
}

if ($options{x})
{
   if (User::Utmp::HAS_UTMPX())
   {
      @utmp = User::Utmp::getutx();
   }
   else
   {
      die "Utmpx is not available on your system.";
   }
}
else
{
   @utmp = User::Utmp::getut();
}

print scalar(@utmp), " elements total\n\n";

foreach my $entry (@utmp)
{
   unless ($options{u} and $entry->{"ut_type"} != USER_PROCESS)
   {
      while (my ($key, $value) = each(%$entry))
      {
	 if ($value)
	 {
	    if ($key eq "ut_type")
	    {
	       $value = $ut_type{$value};
	    }
	    elsif ($key eq "ut_addr")
	    {
	       $value = gethostbyaddr($value, AF_INET) .
		   " (" . join(".", unpack("C4", $value)) . ")";
	    }
	    elsif ($key eq "ut_time" and $value)
	    {
	       if ($options{x})
	       {
		  $value = localtime($value->{tv_sec}) .
		      " (" . $value->{tv_usec} . " µs)";
	       }
	       else
	       {
		  $value = scalar(localtime($value));
	       }
	    }
	    elsif ($key eq "ut_exit")
	    {
	       my @s;

	       while (my ($k, $v) = each(%$value))
	       {
		  push @s, "$k: $v";
	       }

	       $value = join ", ", @s;
	    }
	 }
	 else
	 {
	    $value = "-";
	 }

	 printf "%10s: %s\n", $key, $value;
      }

      print "\n";
   }
}
