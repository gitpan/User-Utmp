#! /usr/local/bin/perl -w

use lib './blib/lib', './blib/arch';
use User::Utmp;
use Socket;

# This is typically the default utmp file
# User::Utmp::utmpname("/etc/utmp");

# And this is a typical alternative
# User::Utmp::utmpname("/var/adm/wtmp");
# Get the contents of the utmp file
@utmp = User::Utmp::getut();

print scalar(@utmp), " elements\n";

foreach $entry (@utmp)
{
   while(($key, $value) = each(%$entry))
   {
      if($key eq "ut_addr")
      {
	 if($value eq "")
	 {
	    $value = "local";
	 }
	 else
	 {
	    $value = gethostbyaddr($value, AF_INET);    # print the name
	    # $value = join(".", unpack("C4", $value)); # print the number
	 }
      }
      elsif($key eq "ut_time")
      {
	 $value = scalar(localtime($value));
      }
      elsif($key eq "ut_exit")
      {
	 my $key;
	 my $v;
	 my %value = %$value;
	 $value = "[";
	 
	 while(($key, $v) = each(%value))
	 {
	    $value .= "$key: $v; ";
	 }
	 $value .= "]";
      }

      print "$key: \t$value\n"; # if $entry->{"ut_type"} == USER_PROCESS;
   }
   print "\n";
}

###############################################################################
# Utmpx

print "#" x 79, "\n", "Utmpx", "\n";

# This is typically the default utmpx file
# User::Utmp::utmpname("/etc/utmpx");

# And this is a typical alternative
# User::Utmp::utmpname("/var/adm/wtmp");
# Get the contents of the utmpx file
@utmpx = User::Utmp::getutx();

print scalar(@utmpx), " elements\n";

foreach $entry (@utmpx)
{
   while(($key, $value) = each(%$entry))
   {
      if($key eq "ut_type")
      {
	 $v = "BOOT_TIME"     if $value == BOOT_TIME;
	 $v = "DEAD_PROCESS"  if $value == DEAD_PROCESS;  
	 $v = "EMPTY"         if $value == EMPTY;
	 $v = "INIT_PROCESS"  if $value == INIT_PROCESS;
	 $v = "LOGIN_PROCESS" if $value == LOGIN_PROCESS;
	 $v = "NEW_TIME"      if $value == NEW_TIME;
	 $v = "OLD_TIME"      if $value == OLD_TIME;    
	 $v = "RUN_LVL"       if $value == RUN_LVL;    
	 $v = "USER_PROCESS"  if $value == USER_PROCESS;
	 $value = $v;
      }
      elsif($key eq "ut_addr")
      {
 	 $a = $value >> 24;
 	 $b = $value <<  8 >> 24;
 	 $c = $value << 16 >> 24;
 	 $d = $value << 24 >> 24;

	 $value = join(".", $a, $b, $c, $d);
      }
      elsif($key eq "ut_exit")
      {
	 my $key;
	 my $v;
	 my %value = %$value;
	 $value = "[";
	 
	 while(($key, $v) = each(%value))
	 {
	    $value .= "$key: $v; ";
	 }
	 $value .= "]";
      }
      elsif($key eq "ut_time")
      {
	 my %value = %$value;
	 $value = "[";
	 $value .= localtime($value{tv_sec}) . "; ";
	 $value .= $value{tv_usec} . " µs]";
      }

      print "$key: \t$value\n"; # if $entry->{"ut_type"} == USER_PROCESS;
   }
   print "\n";
}

###############################################################################

# Writing to a utmp file--create this file if your utmp implementation
# doesn't create it on its own
# User::Utmp::utmpname("/tmp/utmptest");

# %entry = (ut_user => "USER",
# 	  ut_id   => "ID",
# 	  ut_line => "LINE",
# 	  ut_pid  => 1234,
# 	  ut_type => USER_PROCESS,
# 	  ut_exit => {e_termination => 5, e_exit => 6},
# 	  ut_time => time,
# 	  ut_host => "HOST",
# 	  ut_addr => pack("C4", 192, 168, 192, 2)); # this is  what the
#                                                   # gethost* routines return

# User::Utmp::putut(\%entry);
