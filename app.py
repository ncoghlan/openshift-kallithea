'''OpenShift will default to using Apache/mod_wsgi, with you needing to
supply a wsgi.py file containing the WSGI application entry point. This
can be overridden and an embedded Python WSGI server used by supplying
an app.py file.

This would normally mean using a WSGI server that allows you to import
a module for it, and then start the WSGI server by calling a function of
that module. Production grade WSGI servers such as Apache/mod_wsgi, uWSGI
or gunicorn do not readily you to do that, so what we do here instead is
execute a shell script with it in turn running the WSGI server.

Note that we have to use a trick here to ensure everything works properly
with the OpenShift Python cartridge service control script. That is, we
need to ensure that the shell script when run still has 'python -u app.py'
appearing in the command line for the process else the control script will
not properly detect that the WSGI server has started. We do this by setting
the name of the new process to include that string as shown below.

We also don't simply execute the WSGI server directly, and use the shell
script as a persistent intermediary, as the subsequent execution of the
WSGI server can itself result in the process name changing where further
wrapper scripts are used. A WSGI server using multiple processes, could
also result in more than one process with the same name, and we do not
want that to happen either.

'''

import os

SCRIPT = os.path.join(os.path.dirname(__file__), 'app.sh')

os.execl('/bin/bash', 'bash (python -u app.py)', SCRIPT)
