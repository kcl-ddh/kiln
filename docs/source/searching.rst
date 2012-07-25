.. _searching:

Searching and Browsing
======================

Introduction
------------

Kiln has built-in support for using `Solr`_ to provide searching and browsing
functionality. Kiln comes with:

* a Cocoon transformer to communicate with a Solr server as part of a pipeline
  match;
* customisable XSLT for generating Solr index documents from TEI files, and
* an Ant build task to index the entire site, by recursively crawl a
  Cocoon-generated page linking to the index documents to be added to
  the server.

Configuration
-------------

A global variable called ``solr-server`` should be specified in the
project's ``sitemaps/config.xmap``, with the value being the full URL
of the Solr server (including a trailing slash).

Kiln comes with a default indexing XSLT for TEI documents, using
``kiln/stylesheets/solr/tei-to-solr.xsl``. This may be customised via
changes to the importing XSLT
``stylesheets/solr/tei-to-solr.xsl``. Other XSLT for indexing non-TEI
documents may also be written; the Cocoon matches for these should
follow the pattern of the TEI indexing match (in
``private.xmap#local-solr``).

The Solr schema may need to be modified to accomodate extra fields, or
to enable various faceting approaches. It is less likely, but still
possible, that the Solr configuration will need to be modified. Both
of these files (``schema.xml`` and ``solrconfig.xml``), and other
configuration files, are found in ``webapps/solr/conf``.

Search and browse pages are so project-specific that the appropriate
XSLT and Cocoon matches need to be created for them from scratch.


.. _Solr: http://lucene.apache.org/solr/
