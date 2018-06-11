.. _running:

Running the webapp
==================

Development
-----------

For development work, Kiln provides the Jetty web application server,
pre-configured, to minimise setup. To use it:

* Run the build script found in the KILN_HOME directory. On Windows
  double-clicking the BAT file is sufficient.
* Open the URL http://localhost:9999/ (for the root of the site).
* To stop the web server, press Ctrl-C in the shell window.


Production
----------

The built-in Jetty web server is not suitable for production
deployments, and a more robust solution such as `Apache Tomcat`_
should be used. Kiln uses the standard webapp structure, so deployment
is a matter of copying the files in ``webapps`` into the server's
existing webapps directory. Under Tomcat, at least, the Solr webapp
requires an extra step: adding a ``solr.xml`` file specifying a Tomcat
Context to ``TOMCAT_HOME/conf/Catalina/localhost/``. An example of
such a file is provided at ``webapps/solr/conf/solr.xml``.

Further, there are good reasons to run a proxying web server in front
of Tomcat, for caching, load balancing, and/or URL rewriting.

.. _Jetty: http://www.eclipse.org/jetty/
.. _Apache Tomcat: http://tomcat.apache.org/


Static Build
------------

Kiln includes a task that allows to create a static version of the website. To execute it:

* Run the build script as described above to start the web application.
* Re-run the build script supplying ``static`` as argument.


WAR Build (Web Application Archive)
-----------------------------------

Kiln includes a task that allows to create a Web Application Archive (for use with `Apache Tomcat`_, e.g.). To execute it:

* Run the build script supplying ``war`` as argument.
