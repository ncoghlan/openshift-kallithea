#!/usr/bin/env bash

# Because average response time for requests against Kallithea are going
# to be quite long, we increase the capacity for concurrent requests.
# Each Kallithea instance is quite memory hungry though so although
# increasing processes over threads can be better, we can't set it too
# high else we will run out of memory with a small gear. Most requests
# will be I/O bound on accessing database or waiting on git commands, we
# use of many threads in one process shouldn't be an issue.

KALLITHEA_HOMEDIR=$OPENSHIFT_DATA_DIR/kallithea-runtime
KALLITHEA_INIFILE=$KALLITHEA_HOMEDIR/production.ini

SERVER_ROOT=$OPENSHIFT_PYTHON_DIR/run/mod_wsgi

trap 'kill -TERM $PID' TERM INT

mod_wsgi-express start-server --server-root $SERVER_ROOT --log-to-terminal \
        --host $OPENSHIFT_PYTHON_IP --port $OPENSHIFT_PYTHON_PORT \
        --application-type paste --processes 2 --threads 15 \
        $KALLITHEA_INIFILE &

PID=$!
wait $PID
trap - TERM INT
wait $PID
STATUS=$?

exit $STATUS
