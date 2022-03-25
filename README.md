# NAME

PrometheusMetrics : stores perfdatas (counters) in OpenMetrics format

Requires module Prometheus::Tiny

# SYNOPSIS

        use PrometheusMetrics;

        my $metrics = PrometheusMetrics->new (
                        'metric_name'   => $metric_name,
                        'metric_help'   => $metric_help,
                        'metric_type'   => 'gauge',
                        'metric_unit'   => 'bytes',
                        'hostname'              => $hostname,
                        'database'              => $database,
                        'env'                   => $env,
                        );

        $metrics->set (42);
        $metrics->print ();
        $metrics->print_file('>', $metric_name);

# METHODS

- **new**

    Creates an new instance. Required arguments are :

            metric_name
            metric_type
            hostname
            database

- **declare**

    Declares a metric

- **set**

    Sets value for the metric

- **print**
- **print\_file**

    Prints metrics in OpenMetric format
