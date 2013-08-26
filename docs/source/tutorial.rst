.. _tutorial:

Tutorial
========

This tutorial walks you through the creation of a basic web site
edition of some historical letters.

Installation
------------

The development server
----------------------

Let's verify that the installation worked. From the command line, cd
into the directory where you installed Kiln. There, run the
``build.sh`` script (if you are running GNU/Linux or Mac OS X) or the
``build.bat`` batch file (if you are running Windows). You'll see the
following output on the command line::

    Buildfile: <path to your Kiln>/local.build.xml
    Development server is running at http://127.0.0.1:9999
    Quit the server with CONTROL-C.

You've started Jetty, a lightweight web server, that is pre-configured
to run all of the various Kiln components. Note that it may take a few
seconds after it prints out the above for the server to become
responsive.

Now that the server is running, visit http://127.0.0.1:9999/ with your
web browser. You'll see a "Welcome to Kiln" page.

.. note:: Changing the port

   By default, the ``build`` command starts the development server on
   the internal IP at port 9999.

   If you want to change the server's port, pass it as a command-line
   argument. For instance, this command starts the server on port
   8080::

      ./build.sh -Djetty.port=8080

   To change the default, edit the value of ``jetty.port`` in the file
   ``local.build.properties``.


Adding content
--------------

The main content of many Kiln sites is held in `TEI`_ XML files, so
let's add some.

QAZ

Now navigate to the text overview at http://127.0.0.1:9999/text/,
available as the Texts menu option. This presents a table with various
details of the texts in sortable columns. With only a homogenous
collection of a few letters, this is not very useful, but it does
provide links to the individual texts. Follow the link to the first
letter.


Customising the TEI display
---------------------------

Given the enormous flexibility of the TEI to express various
semantics, and the range of possible displays of a TEI document, there
is no one size fits all solution to the problem of transforming a TEI
document into HTML. Kiln comes with `XSLT`_ code that provides support
for some types of markup, but it is expected for each project to
either customise it or replace it altogether. Let's do the former.

Kiln uses the XSLT at ``webapps/ROOT/stylesheets/tei/to-html.xsl`` to
convert TEI into HTML. Open that file in your preferred XML editor. As
you can see, it is very short! All it does is import another XSLT,
that lives at ``webapps/ROOT/kiln/stylesheets/tei/to-html.xsl``. This
illustrates one of the ways that Kiln provides a separation between
Kiln's defaults and project-specific material. Rather than change the
XSLT that forms part of Kiln (typically, files that live in
``webapps/ROOT/kiln``), you change files that themselves import those
files. This way, if you upgrade Kiln and those files have changed,
you're not stuck trying me merge the changes you made back into the
latest file. And if you don't want to make use of Kiln's XSLT, just
remove the import.

.. note:: So how does Kiln know that we want to transform the TEI into
   HTML using this particular XSLT?

   This is specified in a Cocoon sitemap file, which defines the URLs
   in your site, and what to do, and to what, for each of them. In
   this case any request for a URL starting texts/ and ending in .html
   will result in the XML file with the same name being read from the
   filesystem, preprocessed, and then transformed using the
   to-html.xsl code.

   Sitemap files are discussed later in the tutorial.

Let's change the rendering so that deleted text is not shown at all,
rather than being displayed struck out. This is a very simple
piece of XSLT, a single line::

   <xsl:template match="tei:del" />

Add this after the ``xsl:import`` elements. Now reload the page
showing that text, and you'll see the text rerendered with no
deletions shown.

.. warning:: Cocoon automatically caches the results of most requests,
   and invalidates that cache when it detects changes to the files
   used in creating the resource. Thus after making a change to
   ``to-html.xsl`` (the one in ``stylesheets/tei``, not the one in
   ``kiln/stylesheets/tei/``), reloading the text shows the effects of
   that change. However, Cocoon does not follow ``xsl:import`` and
   ``xsl:include`` references when checking for changed files. This
   means that if you change such an imported/included file, the cached
   version of the resource will be used.

   To ensure that the cache is invalidated in such cases, update the
   timestamp of the including file, or the source document. This can
   be done by saving the file (add a space, remove it, and save).


Searching and indexing
----------------------

Indexing
........

In order to provide any useful results, the search engine must index
the TEI documents. This functionality is made available in the `admin
section`_ of the site. You can either index each document
individually, or index them all at once.

There are two possible parts of customising the indexing: changing the
XSLT that specifies what information gets stored in which fields, and
changing the available fields.

The first is done by modifying the XSLT
``stylesheets/solr/tei-to-solr.xsl``. Just as with the TEI to HTML
transformation, this XSLT imports a default Kiln XSLT that can be
overridden.

To change the fields in the index, modify the Solr schema document at
``webapps/solr/conf/schema.xml``. Refer to the `Solr documentation`_
for extensive documentation on this and all other aspects of the Solr
search platform.

It would be useful to index the recipient of each letter, so that this
may be displayed as a facet in search results. In the ``fields``
element in ``schema.xml``, define a recipient field::

   <field indexed="true" multiValued="false" name="recipient"
          required="true" stored="true" type="string" />

After changing the schema, you will need to restart Jetty so that the
new configuration is loaded. You can check the schema that Solr is
using via the Solr admin interface at http://localhost:9999/solr/.

Next ``stylesheets/solr/tei-to-solr.xsl`` needs to modified to add in
the indexing of the recipient into the new schema. Looking at
``kiln/stylesheets/solr/tei-to-solr.xsl``, the default indexing XSLT
traverses through the teiHeader's descendant elements in the mode
``document-metadata``. It is a simple matter to add in a template to
match on the appropriate element::

   <xsl:template match="tei:profileDesc/tei:particDesc/tei:person[@role='recipient']"
                 mode="document-metadata">
     <field name="recipient">
       <xsl:value-of select="normalize-space()" />
     </field>
   </xsl:template>

Now reindex the letters.


Facets
......

To customise the use of facets, modify the XML file
``webapps/ROOT/assets/queries/solr/facet_query.xml``. This file
defines the base query that a user's search terms are added to, and
can also be used to customise all other parts of the query, such as
how many search results are displayed per page. The format is
straightforward; simply add elements with names matching the Solr
query parameters. You can have multiple elements with the same name,
and the query processor will construct it into the proper form for
Solr to interpret.

Add in a facet for the recipient field and perform a search. You can
see that the new facet is automatically displayed on the search
results page.


Results display
...............

The default results display is defined in
``stylesheets/solr/results-to-html.xsl`` and gives only the title of
the matching documents. Modify that XSLT to provide whatever format of
search results best suits your needs.


Building static pages
---------------------

* Changing the sitemap - explanation of URL dispatching.
* Customising the menu.
* Customising the templates.


Harvesting RDF
--------------

May look similar to Solr indexing, but add in a
mapping file for entities to Wikipedia URLs.


Development aids
----------------

The `admin section`_ provides a few useful tools for developers in
addition to the processes that can be applied to texts. The
`Introspection`_ section allows you to look at some of what Kiln is
doing when it runs.

*Match for URL* takes a URL and shows you the full Cocoon
``map:match`` that processes that URL. It expands all references, and
links to all XSLT, so that what can be scattered across multiple
sitemap files, with many references to * and \*\*, becomes a single
annotated piece of XML. Mousing over various parts of the output will
reveal details such as the sitemap file containing the line or the
values of wildcards.

Much the same display is available for each ``map:match`` that has an
ID, in *Match by ID*.

Finally, *Templates by filename* provides the expanded XSLT (all
imported and included XSLT are recursively included) for each
template, and how that template renders an empty document.


.. _admin section: http://127.0.0.1:9999/admin/
.. _Introspection: http://127.0.0.1:9999/admin/introspection/
.. _Solr documentation: http://lucene.apache.org/solr/documentation.html
.. _TEI: http://www.tei-c.org/
.. _XSLT: http://www.w3.org/standards/xml/transformation
