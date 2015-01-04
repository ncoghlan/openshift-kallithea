import os

import mod_wsgi.server

OPENSHIFT_DATA_DIR = os.environ['OPENSHIFT_DATA_DIR']
KALLITHEA_HOMEDIR = os.path.join(OPENSHIFT_DATA_DIR, 'kallithea-runtime')
KALLITHEA_INIFILE = os.path.join(KALLITHEA_HOMEDIR, 'production.ini')

# Note that because average response time is quite long, we increase the
# capacity for concurrent requests. Each Kallithea instance is quite
# memory hungry though so although increasing processes over threads can
# be better, we can't set it too high else we will run out of memory with
# a small gear. Most requests will be I/O bound on accessing database or
# waiting on git commands, we use of many threads in one process shouldn't
# be an issue.

mod_wsgi.server.start('--application-type', 'paste', KALLITHEA_INIFILE,
        '--processes', '2', '--threads', '15')
