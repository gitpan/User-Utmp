# HP-UX has ut_host and ut_addr fields
$self->{CCFLAGS} = $Config{ccflags} . ' -DHAS_UT_HOST -DHAS_UT_ADDR';
$self->{CCFLAGS} .= ' -DHAS_X_UT_EXIT_ -DHAS_X_UT_ADDR -DLEN_X_UT_USER=24 -DLEN_X_UT_ID=4 -DLEN_X_UT_LINE=12 -DLEN_X_UT_HOST=64';
