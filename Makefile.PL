use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	   => 'User::Utmp',
    'VERSION_FROM' => 'Utmp.pm',
    'LIBS'	   => [''],   # e.g., '-lm' 
    'DEFINE'	   => '',     # e.g., '-DHAVE_SOMETHING' 
    'INC'	   => '',     # e.g., '-I/usr/include/other' 
    'dist'         => {COMPRESS => 'gzip', SUFFIX => 'gz'},
);
