# Newer Linux versions have ut_host and ut_addr fields
$self->{CCFLAGS} = $Config{ccflags} . ' -DHAS_UT_HOST -DHAS_UT_ADDR';
# Linux invention: UT_UNKNOWN instead of EMPTY
$self->{CCFLAGS} .= ' -DEMPTY=UT_UNKNOWN';

# GCC with optimization corrupts perl2utent() on Linux ("called object
# is not a function).  The problem seems to be with str* functions;
# the mem* functions seem to work in the same place.  Since this
# problem has only be reported on Linux it doesn't seem to be my
# fault.  Disable optimization until the problem is fixed.
$self->{OPTIMIZE} = ' ';
