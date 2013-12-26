#!/bin/bash
schema=("database" "total_requests" "total_received" "total_sent" "total_query_time" "avg_req" "avg_recv" "avg_sent" "avg_query")
schema_len=${#schema[@]}
PSQL=`which psql`
DB_HOST='localhost'
DB_PORT='6432'
DB_USER='<USER>'
STATSD_HOST='<STATSD_HOST>'
STATSD_PORT=8125

$PSQL -h "$DB_HOST" -p "$DB_PORT" -c "SHOW STATS;" -U "$DB_USER" -F, -A pgbouncer -t | 
    while read row ; do
        IFS=',' read -a columns <<< "$row"
        _DB=${columns[0]}
        for i in `seq 1 $((schema_len-1))`; do 
            echo "pgbouncer.${HOSTNAME}.stats.${_DB}.${schema[i]}:${columns[i]}|g"
        done
    done > "/dev/udp/${STATSD_HOST}/${STATSD_PORT}"
