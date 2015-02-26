'''Use of a 'requirements.txt' file and relying on OpenShift to execute
the 'pip' command currently has some issues due to 'pip' failing to
run in some cases when the HOME directory isn't writable, as is the case
with OpenShift. We therefore use a 'setup.py' to install package
dependencies as OpenShift will also run 'python setup.py develop' when a
'setup.py' file exists.

'''

from setuptools import setup

packages = [
    'psycopg2',
    'kallithea',
    'mod_wsgi>=4.4.5'
]

setup(name='Application', version='1.0', install_requires=packages)
