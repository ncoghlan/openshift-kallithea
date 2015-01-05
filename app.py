import os

import mod_wsgi.server

OPENSHIFT_DATA_DIR = os.environ['OPENSHIFT_DATA_DIR']
OPENSHIFT_PYTHON_DIR = os.environ['OPENSHIFT_PYTHON_DIR']

KALLITHEA_HOMEDIR = os.path.join(OPENSHIFT_DATA_DIR, 'kallithea-runtime')
KALLITHEA_INIFILE = os.path.join(KALLITHEA_HOMEDIR, 'production.ini')

# The very odd --process-name option is to fool the OpenShift service
# control script, which uses pgrep to look for a process with command
# line 'python -u app.py', which it then expects to be the web
# application process. If we don't override the process name then it
# changes and the control script thinks the web application didn't
# start.
#
# Note that because average response time is quite long, we increase the
# capacity for concurrent requests. Each Kallithea instance is quite
# memory hungry though so although increasing processes over threads can
# be better, we can't set it too high else we will run out of memory
# with a small gear. Most requests will be I/O bound on accessing
# database or waiting on git commands, we use of many threads in one
# process shouldn't be an issue.

SERVER_ROOT = os.path.join(OPENSHIFT_PYTHON_DIR, 'run/mod_wsgi')

HOST = os.environ['OPENSHIFT_PYTHON_IP']
PORT = os.environ['OPENSHIFT_PYTHON_PORT']

mod_wsgi.server.start('--process-name', 'httpd (python -u app.py)',
        '--server-root', SERVER_ROOT, '--log-to-terminal',
        '--host', HOST, '--port', PORT, '--application-type', 'paste',
        KALLITHEA_INIFILE, '--processes', '2', '--threads', '15')
