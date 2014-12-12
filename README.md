Kallithea on OpenShift
=========================

NOTE: Deployment with this quickstart is known to be functional, but upgrades have not been tested yet.

``Kallithea`` is a fast and powerful management tool for Mercurial_ and GIT_
with a built in push/pull server, full text search, pull requests and
code-review system.

Kallithea was forked from RhodeCode in July 2014. This quickstart was forked from the RhodeCode kickstart in December 2014.

More information can be found at https://kallithea-scm.org/

This quickstart is *not* recommended for production use, but should be perfectly acceptable for running demonstration servers. http://kallithea-ncoghlan.rhcloud.com/ is one such example.

Running on OpenShift
--------------------

Create an account at http://openshift.redhat.com/

Create a DIY application, together with a PostgreSQL cartridge:

    rhc app create kallithea diy-0.1 postgresql-9.2

Clear out the files from the DIY template:

    rm -R diy .openshift misc README.md
    git add .
    git commit -m "Remove template files"

Add the contents of this Kallithea quickstart repo:

    git remote add quickstart -m master https://github.com/ncoghlan/openshift-kallithea.git
    git pull -s recursive -X theirs quickstart master

Push the repo upstream to OpenShift

    git push

Head to your application at:

    http://kallithea-$yourdomain.rhcloud.com

Default Credentials
-------------------
<table>
<tr><td>Default Admin Username</td><td>admin</td></tr>
<tr><td>Default Admin Password</td><td>changethis</td></tr>
</table>

To give your new Kallithea site a web address of its own, add your desired alias:

    rhc app add-alias -a kallithea --alias "$whatever.$mydomain.com"

Then add a cname entry in your domain's dns configuration pointing your alias to $whatever-$yourdomain.rhcloud.com.

