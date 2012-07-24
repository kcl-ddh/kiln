.. _running:

Running the webapp
==================

Development
-----------

For development work, Kiln provides the jetty web application server,
pre-configured, to minimise setup. To use it:

* Run the build script found in the KILN_HOME directory. On Windows
  double-clicking the BAT file is sufficient.
* Open the URL http://localhost:9999/ (for the root of the site).
* To stop the web server, press Ctrl-C in the shell window.

Note that jetty will automatically refresh every *30 seconds*, so it does not
need to be restarted when files are changed. This refresh value is set in the
``buildfiles/jetty-build.xml`` file, in the 
``jetty:webApp/@scanIntervalSeconds`` attribute. During the brief time this
refreshing takes, web requests may not be correctly served.

After extended periods of use, jetty may stop working due to an out of permgen
memory error. If this happens, simply restart the server.

Production
----------

The built-in jetty web server is not necessarily suitable for production
deployments, and a more robust solution such as 
`Apache Tomcat <http://tomcat.apache.org/>`_ should be used. Kiln uses the
standard webapp structure, so deployment is a matter of copying the files in
``webapps`` into the server's existing webapps directory.
