#! /opt/perl5/bin/perl -w

use lib './blib/lib', './blib/arch';
use User::Utmp;
use Socket;

# User::Utmp::utmpname("/etc/utmp");
# User::Utmp::utmpname("/etc/wtmp");

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
	    $value = gethostbyaddr($value, AF_INET);
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
