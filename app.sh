#!/usr/bin/env bash

# The process for this shell script will persist even after the WSGI
# server has been started. The shell script will monitoring the forked
# sub process, which is the WSGI server, and needs to proxy any signals
# to it for shutdown. This trap ensures the signals are proxied.

trap 'kill -TERM $PID' TERM INT

# By default mod_wsgi-express will place the generated Apache
# configuration and control scripts in a sub directory of /tmp. We can't
# allow that to be used as OpenShift will delete files from /tmp if not
# modified after a certain period of time. We therefore use the
# --server-root option to specify a directory in the per gear runtime
# directory.
#
# OpenShift will collect log messages from stdout/stderr for the WSGI
# server and place it in the python.log log file for the cartridge. We
# therefore force mod_wsgi-express to log to the terminal using the
# --log-to-terminal option rather than to files in the filesystem. The
# normal mechanisms for OpenShift should then be used to manage the log
# file when it becomes too large.
#
# Kallithea uses Pylons and a Paste style ini configuration file for
# defining the WSGI application entry point and any WSGI middlewares or
# filters. We use the mod_wsgi-express --application-type option to
# indicate a Paste style ini configuration file is being supplied to
# define the WSGI application.
#
# Because average response times for requests against Kallithea are
# going to be quite long, we increase the capacity for concurrent
# requests. Each Kallithea instance is quite memory hungry though so
# although increasing processes over threads can be better, we can't set
# it too high else we will run out of memory with a small gear. Most
# requests will be I/O bound on accessing database or waiting on git
# commands, so use of many threads in one process shouldn't be an issue.

KALLITHEA_HOMEDIR=$OPENSHIFT_DATA_DIR/kallithea-runtime
KALLITHEA_INIFILE=$KALLITHEA_HOMEDIR/production.ini

SERVER_ROOT=$OPENSHIFT_PYTHON_DIR/run/mod_wsgi

mod_wsgi-express start-server --server-root $SERVER_ROOT --log-to-terminal \
        --host $OPENSHIFT_PYTHON_IP --port $OPENSHIFT_PYTHON_PORT \
        --application-type paste --processes 3 --threads 10 \
        $KALLITHEA_INIFILE &

# The Apache/mod_wsgi instance will be created as a background process
# using the mod_wsgi-express command. We now need to wait on Apache to
# exit or until a signal is received. When a signal is received to
# shutdown Apache that will be propagated by the trap above. We need to
# wait a second time to ensure Apache exits as the first wait will be
# interrupted by the signal itself. The final exit status from the
# second wait is then used as the exit status of the script so OpenShift
# can act on it it need be.

PID=$!
wait $PID
trap - TERM INT
wait $PID
STATUS=$?

exit $STATUS
