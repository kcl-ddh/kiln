.. _rdf:

RDF / Linked Open Data
======================

Kiln includes the `RDF4J`_ framework for handling RDF data. RDF4J
operates as a pair of Java webapps (``rdf4j-server`` and
``rdf4j-workbench``), and work no differently within Kiln as they do
standalone. This includes extending it, for example by using OWLIM as
the repository, and using its web interfaces.

Setting up a repository
-----------------------

The RDF4J documentation covers how to `create a repository`_\. Once
created, the name of the repository must be set as the value of the
``sesame-server-repository`` variable in
``webapps/ROOT/sitemaps/config.xmap``, along with a base URI
(``rdf-base-uri``).

(Note that RDF4J used to be called Sesame, and that the former name is
still used in some parts of Kiln.)

Integration with Cocoon
-----------------------

Kiln integrates RDF4J into its Cocoon processing via a transformer and
a set of pipelines. The local sitemap ``sitemaps/rdf.xmap`` can be
extended with matches to generate RDF/XML and SPARQL graph
queries. The basic operations are defined and described in the
internal kiln sitemap ``kiln/sitemaps/sesame.xmap``.

Upgrading RDF4J
---------------

There are two parts to upgrading RDF4J separately from a Kiln upgrade
(if Kiln has not yet incorporated that version of RDF4J): upgrading
the rdf4j-server and rdf4j-workbench webapps, and upgrading the
Sesame Cocoon transformer.

Upgrading the two RDF4J webapps is straightforward. First delete
everything in ``webapps/rdf4j-workbench``, and everything except
``app_dir`` (where the project data is kept) in
``webapps/rdf4j-server``. Next unpack the contents of the two WAR
files distributed with RDF4J into the appropriate directories. This
can be done with the command ``jar -xvf <filename>.war``.

Upgrading the transformer is more complicated. After fetching a copy
of the `transformer source code`_, the JAR files in ``lib/sesame-lib``
must be replaced with those from the RDF4J download. It is unlikely
that all of the JARs that come with RDF4J are required. Unless there
has been a change to RDF4J's API, the transformer code does not need
to be modified. The transformer can be rebuilt using `Apache Ant`_
with the command ``ant dist``. All of the newly created JAR files in
the ``dist`` directory must then be copied to
``webapps/kiln/WEB-INF/lib/`` in place of their equivalents (the
filenames will differ, since the RDF4J JARs have the version number
as part of the filename).


.. _RDF4J: http://rdf4j.org/
.. _create a repository: https://rdf4j.org/documentation/tools/server-workbench/#creating-a-repository
.. _transformer source code: https://github.com/kcl-ddh/sesame-transformer
.. _Apache Ant: https://ant.apache.org/
