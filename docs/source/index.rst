.. _index:

.. Kiln documentation master file, created by
   sphinx-quickstart on Tue Jul 24 21:20:29 2012.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Kiln documentation
==================

Kiln is an open source multi-platform framework for building and deploying
complex websites whose source content is primarily in XML. It brings together
various independent software components into an integrated whole that provides
the infrastructure and base functionality for such sites.

Kiln is developed and maintained by a team at the Department of Digital
Humanities (DDH), King’s College London. Over the past years and versions,
Kiln (formerly called xMod) has been used to generate more than 50 websites
which have very different source materials and customised functionality. Since
DDH has in-house guidelines for using TEI P5 to create websites, Kiln makes
use of certain TEI markup conventions. However, it has been adapted to work on
a variety of flavours of TEI and other XML vocabularies, and has been used to
publish data held in relational databases.

Principles
----------

Overriding XSLT by using ``xsl:import`` - a Kiln XSLT is imported by a local
XSLT, allowing for templates to be redefined for the project.

URL scheme: _internal for internal-to-Cocoon Kiln URLs, private for viewable
but not public local material, internal for local internal URLs.

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

Support
-------

See our `issue tracker <https://github.com/kcl-ddh/kiln/issues>`_.

Requirements
------------

Java 1.5+ (untested with 1.7).

Contents
--------

.. toctree::
    :maxdepth: 2

    quickstart
    structure
    components
    running
    templating
    searching
    projects
