.. _index:

.. Kiln documentation master file, created by
   sphinx-quickstart on Tue Jul 24 21:20:29 2012.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Kiln documentation
==================

Kiln is an open source multi-platform framework for building and
deploying complex websites whose source content is primarily
in XML. It brings together various independent software components,
with `Apache Cocoon`_ at their centre, into an integrated whole that
provides the infrastructure and base functionality for such sites.

Kiln is developed and maintained by a team at the `Department of
Digital Humanities`_ (DDH), King’s College London. Over the past years
and versions, Kiln (formerly called `xMod`_) has been used to generate
more than 50 websites which have very different source materials and
customised functionality. Since DDH has in-house guidelines for using
`TEI P5`_ to create websites, Kiln makes use of certain TEI markup
conventions. However, it has been adapted to work on a variety of
flavours of TEI and other XML vocabularies, and has been used to
publish data held in relational databases.

Further reading
---------------

`Apache Cocoon`_ is at the core of Kiln, please consult its
`documentation`_ for more detailed information on how to configure its
components.

Requirements
------------

Java 1.5+ is required to run the Kiln webapps. In order to use the
built-in `Jetty`_ web server (for local, development use only), Java 1.7
is required.

Support
-------

See our `issue tracker`_\.


Tutorial
--------

Kiln comes with a :ref:`tutorial <tutorial>` that covers using the main
components of Kiln, and is recommended for new users.


Contents
--------

.. toctree::
    :maxdepth: 1

    quickstart
    tutorial
    structure
    components
    running
    solr
    navigation
    url
    templating
    searching
    schematron
    rdf
    fedora
    multilingual
    backend
    webservice
    admin
    pdf
    testing
    error
    license
    projects

.. _Apache Cocoon: http://cocoon.apache.org/2.1/
.. _xMod: http://www.cch.kcl.ac.uk/xmod/
.. _Department of Digital Humanities: http://www.kcl.ac.uk/artshums/depts/ddh/
.. _TEI P5: http://www.tei-c.org/release/doc/tei-p5-doc/en/html/index-toc.html
.. _documentation: http://cocoon.apache.org/2.1/userdocs/index.html
.. _Jetty: http://www.eclipse.org/jetty/
.. _issue tracker: https://github.com/kcl-ddh/kiln/issues
