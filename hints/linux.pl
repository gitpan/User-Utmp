# Newer Linux versions have ut_host and ut_addr fields
$self->{CCFLAGS} = $Config{ccflags} . ' -DHAS_UT_HOST -DHAS_UT_ADDR';
# Linux invention: UT_UNKNOWN instead of EMPTY
$self->{CCFLAGS} .= ' -DEMPTY=UT_UNKNOWN';
