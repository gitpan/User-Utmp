# AIX has the ut_host field
# Information kindly provided by Joe Ardolino <jardolin@zoo.uvm.edu>
$self->{CCFLAGS} = $Config{ccflags} . ' -DHAS_UT_HOST';
