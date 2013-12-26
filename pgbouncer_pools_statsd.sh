#!/bin/bash
schema=("database" "user" "cl_active" "cl_waiting" "sv_active" "sv_idle" "sv_used" "sv_tested" "sv_login" "maxwait")
schema_len=${#schema[@]}
PSQL=`which psql`
DB_HOST='localhost'
DB_PORT='6432'
DB_USER='<USER>'
STATSD_HOST='<STATSD_HOST>'
STATSD_PORT=8125

$PSQL -h "$DB_HOST" -p "$DB_PORT" -c "SHOW POOLS;" -U "$DB_USER" -F, -A pgbouncer -t | 
    while read row ; do
        IFS=',' read -a columns <<< "$row"
        _DB=${columns[0]}
        _USER=${columns[1]}
        for i in `seq 2 $((schema_len-1))`; do 
            echo "pgbouncer.${HOSTNAME}.pools.${_DB}.${_USER}.${schema[i]}:${columns[i]}|g"
        done
    done > "/dev/udp/${STATSD_HOST}/${STATSD_PORT}"
