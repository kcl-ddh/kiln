.. _searching:

Searching and Browsing
======================

Introduction
------------

Kiln has built-in support for using `Solr`_ to provide searching and browsing
functionality. Kiln comes with:

* a Cocoon transformer to communicate with a Solr server as part of a pipeline
  match;
* customisable XSLT for generating Solr index documents from TEI files; and
* an Ant build task to index the entire site, by recursively crawl a
  Cocoon-generated page linking to the index documents to be added to
  the server.

Configuration
-------------

A global variable called ``solr-server`` should be specified in the
project's ``sitemaps/config.xmap``, with the value being the full URL
of the Solr server (including a trailing slash).

The Solr schema may need to be modified to accomodate extra fields, or
to enable various faceting approaches. It is less likely, but still
possible, that the Solr configuration will need to be modified. Both
of these files (``schema.xml`` and ``solrconfig.xml``), and other
configuration files, are found in ``webapps/solr/conf``.

Search and browse pages are so project-specific that the appropriate
XSLT and Cocoon matches need to be created for them from scratch.

Built-ins
---------

Kiln comes with a default indexing XSLT for TEI documents, using
``kiln/stylesheets/solr/tei-to-solr.xsl``. This may be customised via
changes to the importing XSLT
``stylesheets/solr/tei-to-solr.xsl``. Other XSLT for indexing non-TEI
documents may also be written; the Cocoon matches for these should
follow the pattern of the TEI indexing match (in
``solr.xmap#local-solr``).

Kiln also includes an XSLT,
``kiln/stylehssets/solr/generate-query.xsl``, for adding XInclude
elements that reference search results to an XML document, based on
supplied query parameters in the source XML. See the documentation in
the XSLT itself for details on the format of the supplied XML. When
used in a pipeline, it must be followed by an XInclude transformation
step.

Additionally, the XSLT ``kiln/stylesheets/solr/merge-parameters.xsl``
adds appropriate elements to the end of a query XML document, as
above, from request data. ``sitemaps/internal.xmap`` provides a
generic way to generate a search results document using this method.

This approach is not as redundant as it might seem, with a Solr query
string being transformed into XML and then back into a query string
that is run. It allows both for common query elements to be specified
in an XML file, and also does not require that the query string passed
to ``merge-parameters.xsl`` be formatted as Solr requires. Parameters
can be repeated that ``generate-query.xsl`` will join together in the
correct fashion. This frees whatever process generates the XSLT
parameter value from knowing anything about Solr's details (eg, it can
be a simple form with no processing).

Query files
-----------

Solr query files in ``assets/queries/solr/`` are a good way to provide
static elements for a given search. They can specify what fields to
facet on, default query strings, sorting, and so on.

Attributes on the root ``query`` element may specify which fields
should be appended to the general query (``@q_fields``) and which
fields should be appended to the general query as a range
(``@range_fields``).

Child elements of ``query`` may specify a ``default`` attribute with
the value ``true``; the value of this element will only be used if no
querystring parameter has the same name.

Facet fields (``facet.field``) may specify a ``join`` attribute with
the value ``or``; that facet is treated as a multi-select facet, with
the selected values being ORed together. The default behaviour is for
selected values to be ANDed together.

By default, the contents of fields are automatically escaped. When
this is not desired, add an ``escape`` attribute with the value
``false`` to the element.

Indexing non-TEI documents
--------------------------

Kiln currently only has code for indexing TEI documents, and its
display of search results assumes that those results come from TEI
documents (in the ``content/xml/tei`` directory). To support the
indexing and results display of documents in other directories, two
things must be done:

* Add an XSLT in ``stylesheets/solr`` to perform the indexing. The
  filename should be ``<dir>-to-solr.xsl``, where <dir> is the name of
  the directory under ``content/xml`` containing the documents.
* Add an appropriate condition path added to the ``xsl:choose`` in
  ``stylesheets/solr/results-to-html.xsl`` in the template for
  ``result/doc`` in the ``search-results`` mode.

Upgrading Solr
--------------

There are two parts to upgrading Solr separately from a Kiln upgrade
(if Kiln has not yet incorporated that version of Solr): upgrading the
solr webapp, and upgrading the Solr Cocoon transformer.

Upgrading the Solr webapp is straightforward, unless there are local
modifications to the files under ``webapps/solr`` (except in ``conf``
and ``data``). If there are, either these changes can be merged back
in to the new versions (either manually or through whatever tools are
available), or left in place.

First, delete all content in ``webapps/solr`` except for the ``conf``
and ``data`` directories. Next upack the contents of the solr WAR file
distributed with Solr into ``webapps/solr``. This can be done with the
command ``jar -xvf <filename>.war``. It is possible that there are
incompatibilities between the new version of Solr and the
existing configuration files in ``webapps/solr/conf``, in which case
these will need to be resolved manually. The Solr admin web page can
be helpful in finding problems.

Upgrading the transformer is more complicated. After fetching a copy
of the `transformer source code`_, the JAR files in the ``lib``
directory must be replaced with those from the Solr
distribution. Unless there has been a change to Solr's API, the
transformer code does not need to be modified. The transformer can be
rebuilt using `Apache Ant`_ with the command ``ant dist``. The newly
created ``solr.transformer.jar`` file in the ``dist`` directory must
then be copied to ``webapps/kiln/WEB-INF/lib/``, along with the JARs
in the lib directory. These must be put in place of their equivalents
(the filenames will differ, since the Solr JARs have the version
number as part of the filename), and all in the
``webapps/kiln/WEB-INF/lib/`` and not a subdirectory.


.. _Solr: http://lucene.apache.org/solr/
.. _transformer source code: https://github.com/kcl-ddh/solr-transformer
.. _Apache Ant: https://ant.apache.org/
