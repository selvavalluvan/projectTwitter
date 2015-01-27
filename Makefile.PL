use strict;
use warnings;
use ExtUtils::MakeMaker;

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on it.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'myperltwitter',
    AUTHOR              => q{Selva Valluvan<pvalluva@uwaterloo.ca>},
    ABSTRACT            => 'Simple twitter app',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.312,
        'JSON'       => 0,
        'Plack'        => 0,
        'LWP::Protocol::https' => '0',
        },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'myheroku-*' },
);
