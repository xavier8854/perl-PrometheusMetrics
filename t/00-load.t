#!perl
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'PrometheusMetrics' ) || print "Bail out!\n";
}

diag( "Testing PrometheusMetrics PrometheusMetrics::VERSION, Perl $], $^X" );
