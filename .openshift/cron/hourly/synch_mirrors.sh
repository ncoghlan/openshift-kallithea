#!/bin/bash
#
# Synchronize mirrored repositories.
#
ROOT="$OPENSHIFT_DATA_DIR"
VENV="$ROOT/kallithea-venv"
BIN="$VENV/bin"
API_HOST="http://$OPENSHIFT_DIY_HOST:$OPENSHIFT_DIY_PORT/"
API_KEY="DEADBEEFDEADBEEF"
K_API="$BIN/kallithea-api --apikey=$API_KEY --apihost=$API_HOST"

for rid in $($K_API get_repos --format=json | $BIN/python list_mirrors.py); do
    $K_API pull repoid:$rid
done
