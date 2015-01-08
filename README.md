Kallithea on OpenShift
=========================

NOTE: Deployment with this quickstart is known to be functional, but
upgrades have not been tested yet.

``Kallithea`` is a fast and powerful management tool for
[Mercurial](http://mercurial.selenic.com) and [GIT](http://git-scm.com)
with a built in push/pull server, full text search, pull requests and
code-review system.

Kallithea was forked from RhodeCode in July 2014. This quickstart was
forked from the RhodeCode kickstart in December 2014.

More information on Kallithea can be found at:

* https://kallithea-scm.org/

This quickstart is *not* recommended for production use at this time,
but should be perfectly acceptable for running demonstration servers.
For an online example of this quickstart running see:

* http://kallithea-ncoghlan.rhcloud.com/

Running on OpenShift
--------------------

Create an account at http://openshift.redhat.com/

Create a python-2.7 application, together with a PostgreSQL cartridge:

    rhc app create kallithea python-2.7 postgresql-9.2 --no-git

Add the OpenShift git repository as a remote to the local repository, using
the actual git remote URI given:

    git remote add openshift ssh://$myappid@kallithea-$yourdomain.rhcloud.com/~/git/kallithea.git/

Force push the local repository up to the OpenShift repository:

    git push -f openshift master

Head to your application at:

    http://kallithea-$yourdomain.rhcloud.com

Default Credentials
-------------------

<table>
<tr><td>Default Admin Username</td><td>admin</td></tr>
<tr><td>Default Admin Password</td><td>changethis</td></tr>
</table>

To give your new Kallithea site a web address of its own, add your desired
alias:

    rhc app add-alias -a kallithea --alias "$whatever.$mydomain.com"

Then add a cname entry in your domain's dns configuration pointing your
alias to $whatever-$yourdomain.rhcloud.com.

Hosting Mechanism
-----------------

Kallithea is based on Pylons and can be hosted with any WSGI server. For
OpenShift this quickstart is using Apache/mod\_wsgi. Rather than use the
standard OpenShift Apache/mod\_wsgi setup however, ``mod_wsgi-express`` is
used. This allows the configuration for mod\_wsgi to be customised,
including the ability to use a multi process configuration, which will be
better suited to hosting such an application as Kallithea.

Replacing the default WSGI application hosting mechanisms in OpenShift is
not obvious, but Graham Dumpleton has documented how it can be done in the
blog post:

* http://blog.dscpl.com.au/2015/01/using-alternative-wsgi-servers-with.html

This quickstart uses the approach described in that post.
