.. _quickstart:

Quickstart
==========

#. Download or clone the Kiln code from the `GitHub repository`_.
#. Open a terminal window and go to the directory where Kiln is installed
   (hereafter KILN_HOME).
#. Run the command ``build.sh`` (Mac OS X/Linux) or ``build.bat`` (Windows),
   and leave the Terminal window open.
#. Open a browser and got to http://localhost:9999/. It should display a
   welcome page together with some very basic :ref:`navigation <navigation>`.
#. Store project XML content in the folders
   ``KILN_HOME/webapps/ROOT/content/xml/tei`` (TEI) and
   ``KILN_HOME/webapps/ROOT/content/xml/epidoc`` (EpiDoc).
#. View HTML versions of the XML at http://localhost:9999/en/text/<filename>.html (TEI) and http://localhost:9999/en/inscriptions/<filename>.html (EpiDoc) [filetype extensions not included in <filename>]
#. Customise the templates, transformations and site URL
   structure. The example project in ``KILN_HOME/example`` provides
   some guidance on how this can be done.

Principles
----------

Overriding XSLT by using ``xsl:import`` - a Kiln XSLT is imported by a local
XSLT, allowing for templates to be redefined for the project.

URL scheme: ``_internal`` for internal-to-Cocoon Kiln URLs,
``admin`` for viewable but not public local material, ``internal``
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

.. _GitHub repository: http://github.com/kcl-ddh/kiln/
