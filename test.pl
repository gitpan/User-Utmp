# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..3\n"; }
END {print "not ok 1\n" unless $loaded;}
use User::Utmp;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

$user = getlogin || getpwuid($<) || $ENV{USER};
chomp ($term = `tty`);

###############################################################################

@utmp = User::Utmp::getut();

$found = 0;

foreach $entry (@utmp)
{
   if ($entry->{ut_type} == USER_PROCESS)
   {
      $found++ if $entry->{ut_user} eq $user;
      $found++ if $term =~ $entry->{ut_line};
   }
}

print $found ? "" : "not ", "ok 2 ";

if (not $found)
{
   print "(Could not find entry for user $user and/or line $term)"
}

print "\n";

###############################################################################

if (User::Utmp::HAS_UTMPX())
{
   @utmp = User::Utmp::getut();

   $found = 0;

   foreach $entry (@utmp)
   {
      if ($entry->{ut_type} == USER_PROCESS)
      {
	 $found++ if $entry->{ut_user} eq $user;
	 $found++ if $term =~ $entry->{ut_line};
      }
   }

   print $found ? "" : "not ", "ok 3 ";

   if (not $found)
   {
      print "(Could not find entry for user $user and/or line $term)"
   }

   print "\n";

}
else
{
   print "skipped 3 (utmpx not available on this system)\n";
}
