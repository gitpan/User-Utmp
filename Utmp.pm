# @(#) $Id: Utmp.pm,v 1.11 2000/02/27 15:29:06 mxp Exp $

package User::Utmp;

use strict;
use Carp;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK $AUTOLOAD);

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT_OK = qw(getut putut utmpname);
@EXPORT    = qw(BOOT_TIME
		DEAD_PROCESS
		EMPTY
		INIT_PROCESS
		LOGIN_PROCESS
		NEW_TIME
		OLD_TIME
		RUN_LVL
		USER_PROCESS);
$VERSION = '1.0';

sub AUTOLOAD {
    # This AUTOLOAD is used to 'autoload' constants from the constant()
    # XS function.  If a constant is not found then control is passed
    # to the AUTOLOAD in AutoLoader.

    my $constname;
    ($constname = $AUTOLOAD) =~ s/.*:://;
    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
	if ($! =~ /Invalid/) {
	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
	    goto &AutoLoader::AUTOLOAD;
	}
	else {
		croak "Your vendor has not defined User::Utmp macro $constname";
	}
    }
    eval "sub $AUTOLOAD { $val }";
    goto &$AUTOLOAD;
}

bootstrap User::Utmp $VERSION;

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the documentation

=head1 NAME

User::Utmp - Perl access to utmp- and utmpx-style databases

=head1 SYNOPSIS

  use User::Utmp qw(utmpname getut putut);
  utmpname("file");
  @utmp = getut();
  putut(\%entry);

or, on systems supporting utmpx:

  use User::Utmp qw(utmpname getutx putut);
  utmpname("file");
  @utmp = getutx();
  putut(\%entry);

=head1 DESCRIPTION

The User::Utmp modules provides functions for reading utmp and utmpx
files, and experimental support for writing utmp files.  The following
functions are provided:

=over 4

=item B<getut()>

Reads a utmp-like file and converts it to a Perl array of hashes.
Each array element (a reference to a hash) represents one utmp record.
The hash keys are the names of the elements of the utmp structure as
described in utmp(4).  The hash values are the same as in C.

Note that even if C<ut_addr> (if provided by the utmp implementation)
is declared as I<long>, it contains an Internet address (four bytes in
network order), not a number.  It is therefore converted to a string
suitable as parameter to gethostbyname().  If the record doesn't
describe a remote login C<ut_addr> is the empty string.

=item B<getutx()>

Reads a utmpx-like file and converts it to a Perl array of hashes.
Each array element (a reference to a hash) represents one utmp record.
The hash keys are the names of the elements of the utmpx structure as
described in utmpx(4) or getutx(3).  The hash values are the same as
in C.

Note that even if C<ut_addr> (if provided by the utmpx implementation)
is declared as I<long>, it contains an Internet address (four bytes in
network order), not a number.  It is therefore converted to a string
suitable as parameter to gethostbyname().  If the record doesn't
describe a remote login C<ut_addr> is the empty string.

=item B<putut()>

Writes out the supplied utmp record into the utmp file.  putut() takes
a reference to a hash which has the same structure and contents as the
elements of the array returned by getut().  Whether or not putut()
creates the utmp file if it doesn't exist is implementation-dependent.

=item B<utmpname()>

Allows the user to change the name of the file being examined from the
default file (typically /etc/utmp or, for utmpx, /etc/utmpx) to any
other file.  In this case, the name provided to utmpname() will be
used for the getut(), getutx(), and putut() functions.

=back

User::Utmp also provides the following utmp constants as functions:

=over 4

BOOT_TIME DEAD_PROCESS EMPTY INIT_PROCESS LOGIN_PROCESS NEW_TIME
OLD_TIME RUN_LVL USER_PROCESS

=back

EMPTY is also use on Linux (instead of the non-standard UT_UNKNOWN).

=head1 RESTRICTIONS

Reading the whole file into an array might not be the most efficient
approach for potentially large files like /etc/wtmp.

This module is based on the traditional, non-reentrant utmp functions;
it is therefore B<not> thread-safe.

=head1 AUTHOR

Michael Piotrowski <mxp@dynalabs.de>

=head1 SEE ALSO

utmp(4), getut(3), utmpx(4), getutx(3)

=cut
