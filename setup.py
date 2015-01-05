from setuptools import setup

packages = [
    'psycopg2',
    'kallithea',
    'mod_wsgi>=4.4.5'
]

links = [
    'https://dl.dropboxusercontent.com/u/22571016/mod_wsgi-4.4.5.tar.gz#egg=mod_wsgi-4.4.5',
]

setup(name='Application', version='1.0',
        install_requires=packages, dependency_links=links)
