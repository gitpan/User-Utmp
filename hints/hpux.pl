# HP-UX has ut_host and ut_addr fields
$self->{CCFLAGS} = $Config{ccflags} . ' -DHAS_UT_HOST -DHAS_UT_ADDR';
