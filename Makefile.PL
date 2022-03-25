use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile (
 	NAME			=> 'PrometheusMetrics',
	AUTHOR			=> q{Xavier Humbert <xavier.humbert@ac-nancy-metz.fr>},
	VERSION_FROM		=> 'lib/PrometheusMetrics.pm',
	ABSTRACT		=> 'Sores perfdatas in OpenMetrics format',
	LICENSE			=> 'GPL',
	PL_FILES		=> {'script/main.pl'},
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
    },
	PREREQ_PM => {
	},
	TEST_REQUIRES => {
		'Test::More'		=> 0.98,
	},
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'PrometheusMetrics-*' },
);

=pod


=cut
