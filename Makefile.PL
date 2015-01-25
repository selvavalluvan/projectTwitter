use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
NAME         => 'twitterfry.pl',
VERSION      => '1.0',
AUTHOR       => 'Selva Valluvan <pvalluva@uwaterloo.ca>',
EXE_FILES    => ['server.pl'],
PREREQ_PM    => {'JSON' => '2.53'}
);
