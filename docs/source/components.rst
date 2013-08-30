.. _components:

Components
==========

* `Apache Cocoon`_ web development framework for XML processing, built
  with integrated eXist XML database that can be used for storage,
  indexing and searching using XPath expressions.
* `Apache Solr`_ searching platform for indexing, searching and
  browsing of contents.
* `Sesame 2`_ for storage and querying of RDF data.
* `Apache Ant`_ build system that has tasks for running the built-in
  web application server, running the Solr web server, creating a
  static version of the website, generating a Solr index of all the
  desired content.
* `Jetty`_ web application server for immediate running of Cocoon with
  automatic refreshing of changes.
* An XSLT-based templating language that supports inheritance, similar
  to `Django’s template block system`_.
* `Foundation`_, a set of HTML/CSS/JavaScript building blocks.

Architecture
------------

.. image:: /images/architecture.png
    :align: center
    :alt: Kiln architecture
    :width: 90%

In a production web server context, Kiln integrates with other web
publishing tools to support images (IIPimage/Djatoka), maps
(GeoServer; MapServer; OpenLayers) and other data sources, like
relational data (MySQL or other RDBMS).

Customisation
-------------

Kiln has been developed around the concept of the separation of roles,
allowing people with different backgrounds, knowledge and skills to
work simultaneously on the same project without overriding each
other’s work. The parts of the system used by developers, designers
and content editors are distinct; further, the use of a version
control system makes it simpler and safer for multiple people with the
same role to work independently and cooperatively.

Since it is impossible to predict every eventuality with regards to a
project’s specific XML markup, Kiln offers basic output options which
cover the functionality and formats (HTML, PDF, etc) common to all
websites, together with an extensible framework supporting the
development of any custom functionality that is needed. The system
provides for a high-level of customisation, beyond the usable and
useful defaults, in the following other areas:

* Schematron validation based on, and linked to, encoding guidelines
  published in ODD.
* Editorial workflow validation. Kiln provides web-based management
  pages that allow XML files to be checked for inconsistencies and
  errors.
* Templates for common types of pages, such as search and search
  results, indices, and bibliographies.
* XSLT for indexing contents for Solr. By default it indexes the full
  text and all the references to marked up entities.

.. image:: /images/solr.png
    :align: center
    :alt: Customisation levels of Solr components
    :width: 90%

Kiln provides native support for multilingual websites, RSS feeds,
form processing, and automated navigation such as sitemaps and
indexes, but with some customisation can support the publishing of
more complex materials with much deeper markup, such as medieval
charters, musicological bibliographies, classical inscriptions,
biographies, glossaries and so forth.

Templates
---------

Kiln provides a templating mechanism that provides full access to XSLT
for creating the output, and an inheritance mechanism. Templates use
XSLT as the coding language to create any dynamic content. Template
inheritance allows for a final template to be built up of a base
skeleton (containing the common structure of the output) and
'descendant' templates that fill in the gaps. In addition to supplying
its own content, a block may include the content of the block it is
inheriting from.

* Example of basic structure: ::

    <kiln:root>
        <kiln:parent>
            <!-- Extend another template by including it. -->
            <xi:include href="base.xml" />
        </kiln:parent>
        <kiln:child>
            <!-- Override a block defined in an ancestor template. -->
            <kiln:block name="title">
                <h1>Title here</h1>
            </kiln:block>
        </kiln:child>
    </kiln:root>

* Example of inheriting content: ::

    <kiln:block name="title">
        <!-- Include the parent template's content for this block. -->
        <kiln:super />
        <!-- Add in new content. -->
        <h2>Smaller title here</h2>
    </kiln:block>

:ref:`Fuller documentation <templating>` is available.

.. _Apache Cocoon: http://cocoon.apache.org/2.1/
.. _Apache Solr: http://lucene.apache.org/solr/
.. _Sesame 2: http://www.openrdf.org/
.. _Apache Ant: http://ant.apache.org/
.. _Jetty: http://www.eclipse.org/jetty/
.. _Django’s template block system:
    http://docs.djangoproject.com/en/dev/topics/templates/#template-inheritance
.. _Foundation: http://foundation.zurb.com/
