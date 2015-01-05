#!/usr/bin/env bash

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
