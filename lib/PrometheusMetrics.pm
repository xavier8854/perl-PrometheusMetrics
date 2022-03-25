#!/usr/bin/perl -w

#######################################################################
# $Id: PrometheusMetrics.pm, v1.0 r1 19.08.2021 11:46:50 CEST XH Exp $
#
# Copyright 2021 Xavier Humbert <xavier.humbert@ac-nancy-metz.fr>
# for CRT SUP
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA  02110-1301, USA.
#
#######################################################################

package PrometheusMetrics;

use Data::Dumper;
use Exporter qw(import);

our @EXPORT_OK = qw(declare set print print_file);

#####
## PROTOS
#####
sub set ($$);
sub add ($$);
sub print ($);
sub print_file ($$);

#####
## CONSTANTS
#####
our $VERSION = "1.0.4";


#####
## VARIABLES
#####
my $rc=0;

#####
## CONSTRUCTOR
#####

sub new () {
	my($class, %args) = @_;

	die "No metric name"	if not defined $args{'metric_name'};
	die "No metric type"	if not defined $args{'metric_type'};
	die "No hostaddr"		if not defined $args{'hostaddr'};

	my $self = {
		'metric_name' 	=> $args{'metric_name'},
		'metric_help' 	=> $args{'metric_help'},
		'metric_type' 	=> $args{'metric_type'},
		'metric_unit' 	=> $args{'metric_unit'} || 'bytes',
		'hostaddr' 		=> $args{'hostaddr'},
		'env' 			=> $args{'env'},
		'outdir'		=> $args{'outdir'} || './',
		};
	bless ($self, $class);

	$self->{'datafile'} = $self->{'outdir'} . '/' . $args{'hostaddr'} . '_' . $args{'metric_name'} . '.openmetrics';
	$self->{'meta'}{'hostaddr'} = $args{'hostaddr'};
	$self->{'meta'}{'env'} = $args{'env'};
	return $self;
}

#####
## METHODS
#####

sub declare ($$$) {
	my ($self, $name, $meta) = @_;

	foreach $key (keys %{$meta}) {
		$self->{'meta'}{$key} = $meta->{$key};
	}
}

sub set ($$) {
	my ($self, $value) = @_;

	my $metric_key = $self->{'metric_name'};
	$metric_key .= '{';
	foreach my $key (keys %{$self->{'meta'}}) {
		$metric_key .= sprintf "%s=\"%s\",", $key, $self->{'meta'}{$key};
	}
	$metric_key .= '}';

	my @pair = ($value, time()*1000);
	$self->{$metric_key} = \@pair;
	return 0;
}

sub print ($) {
	my $self = shift;

	my $regex = "^" . $self->{'metric_name'};

	printf "# UNIT %s %s\n", $self->{'metric_name'}, $self->{'metric_unit'};
	printf "# TYPE %s %s\n", $self->{'metric_name'}, $self->{'metric_type'};
	printf "# NAME %s %s\n", $self->{'metric_name'}, $self->{'metric_name'};

	my @keys = grep { /$regex/ } keys %{$self};
	foreach my $key (@keys) {
		printf "%s %s %s\n","$key", $self->{$key}[0], $self->{$key}[1] ;
	}
	return 0;
}

sub print_file ($$) {
	my ($self, $mode) = @_;

	my $regex = "^" . $self->{'metric_name'};

	if ( !open (OUTFILE, $mode, $self->{'datafile'}) ) {
			return 1;
	}
	printf OUTFILE "# UNIT %s %s\n", $self->{'metric_name'}, $self->{'metric_unit'};
	printf OUTFILE "# TYPE %s %s\n", $self->{'metric_name'}, $self->{'metric_type'};
	printf OUTFILE "# NAME %s %s\n", $self->{'metric_name'}, $self->{'metric_name'};

	my @keys = grep { /$regex/ } keys %{$self};
	foreach my $key (@keys) {
		printf OUTFILE "%s %s %s\n","$key", $self->{$key}[0], $self->{$key}[1] ;
	}
	close OUTFILE;
	return 0;
}

1;
__END__


=pod

=head1 NAME

PrometheusMetrics : stores perfdatas (counters) in OpenMetrics format

Requires module Prometheus::Tiny

=head1 SYNOPSIS

	use PrometheusMetrics;

	my $metrics = PrometheusMetrics->new (
			'metric_name' 	=> $metric_name,
			'metric_help' 	=> $metric_help,
			'metric_type' 	=> 'gauge',
			'metric_unit' 	=> 'bytes',
			'hostaddr' 		=> $hostname,
			'database' 		=> $database,
			'env' 			=> $env,
			);

	$metrics->set (42);
	$metrics->print ();
	$metrics->print_file('>', $metric_name);

=head1 METHODS

=over 12

=item B<new>

Creates an new instance. Required arguments are :

	metric_name
	metric_type
	hostaddr
	database

=item B<declare>

Declares a metric

=item B<set>

Sets value for the metric

=item B<print>

=item B<print_file>

Prints metrics in OpenMetric format

=back



=cut
