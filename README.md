pgbouncer-statsd
================

These scripts publish pgbouncer statstics to StatsD gauges so that it is easier to keep an eye on how the change over time. They are meant to be used in cron-jobs and require only bash 4 with `/dev/udp` support.

In order to use them in your environment, simply update the relevant config variables at the top of each script to have it connect to the proper pgbouncer instance as the right user. Currently it seems silly to have the password included in the script so you will want to have a `.pgpass` file for the user that will be running the job.
