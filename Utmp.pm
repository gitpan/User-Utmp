# @(#) $Id: Utmp.pm,v 1.6 1999-03-22 21:35:06+01 mxp Exp $

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
@EXPORT_OK = qw(getut utmpname);
$VERSION = '0.02';

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

User::Utmp - Perl access to utmp-style databases

=head1 SYNOPSIS

  use User::Utmp;
  utmpname("file");
  @utmp = User::Utmp::getut();

=head1 DESCRIPTION

The following functions are provided:

=over 4

=item getut()

Reads a utmp-like file and converts it to a Perl array of hashes.
Each array element (a reference to a hash) represents one utmp record.
The hash keys are the names of the elements of the utmp structure as
described in utmp(4).  The hash values are generally the same as in C,
with the following exceptions: the value of C<ut_type> is a string
containing the name of the ut_type constant; the value of C<ut_addr>
is a string suitable as parameter to gethostbyname(); if the record
doesn't describe a remote login C<ut_addr> is the empty string.

=item utmpname()

Allows the user to change the name of the file being examined from
/etc/utmp to any other file.  In this case, the name provided to
utmpname() will be used for the getut() function.

=back

=head1 RESTRICTIONS

Reading the whole file into an array might not be the most efficient
approach for potentially large files like /etc/wtmp.

This module is based on the traditional, non-reentrant utmp functions;
it is therefore B<not> thread-safe.

=head1 AUTHOR

Michael Piotrowski <mxp@linguistik.uni-erlangen.de>

=head1 SEE ALSO

utmp(4), getut(3)

=cut
