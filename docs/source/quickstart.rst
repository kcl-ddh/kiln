.. _quickstart:

Quickstart
==========

To get started with Kiln, it first needs to be downloaded or cloned from
the `GitHub repository <http://github.com/kcl-ddh/kiln/>`_.

#. Open a Terminal window and go to the directory where Kiln is installed
   (hereafter KILN_HOME)
#. Run the command ``build.sh`` (Mac OS X/Linux) or ``build.bat`` (Windows),
   and leave the Terminal window open
#. Open a browser and got to http://localhost:9999/
    #. If all is well it should display a *Resource not found* error message!
#. Store project XML content (TEI) in the folder
   ``KILN_HOME/webapps/root/content/xml/tei``. By default Kiln needs a TEI
   index.xml file at that location
#. Reload the browser. It should now display the contents of the index file,
   together with some very basid navigation.

Principles
----------

Overriding XSLT by using ``xsl:import`` - a Kiln XSLT is imported by a local
XSLT, allowing for templates to be redefined for the project.

URL scheme: ``_internal`` for internal-to-Cocoon Kiln URLs,
``private`` for viewable but not public local material, ``internal``
for local internal-to-Cocoon URLs.

The directory :ref:`structure <structure>` makes explicit the division between
those parts of Kiln that are its core, and should not be changed in any project
installation, and the project-specific material. Kiln material is always a
descendant of a directory called kiln.

This division also carries through to the Cocoon pipelines and the XSLT they
use. Some Kiln pipelines are designed to be flexible enough to suit multiple
different uses by a project-specific pipeline (see the Schematron pipelines for
an example). Where a Kiln pipeline uses XSLT that might reasonably be
customised by a project, it calls a proxy XSLT not within a kiln directory,
that in turn imports the Kiln version. This allows for customisation without
changing Kiln core files.
