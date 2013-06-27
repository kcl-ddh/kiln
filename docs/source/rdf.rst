.. _rdf:

RDF / Linked Open Data
======================

Kiln includes the `Sesame`_ framework for handling RDF data. Sesame
operates as a pair of Java webapps (``openrdf-sesame`` and
``openrdf-workbench``), and work no differently within Kiln as they do
standalone. This includes extending it, for example by using OWLIM as
the repository, and using its web interfaces.

Setting up a repository
-----------------------

The Sesame documentation covers how to `create a repository`_\. Once
created, the name of the repository must be set as the value of the
``sesame-server-repository`` variable in
``webapps/ROOT/sitemaps/config.xmap``, along with a base URI
(``rdf-base-uri``).

Integration with Cocoon
-----------------------

Kiln integrates Sesame into its Cocoon processing via a Sesame
transformer and a set of pipelines. The local sitemap
``sitemaps/rdf.xmap`` can be extended with matches to generate RDF/XML
and SPARQL graph queries. The basic operations are defined and
described in the internal kiln sitemap ``kiln/sitemaps/sesame.xmap``.

Upgrading Sesame
----------------

There are two parts to upgrading Sesame separately from a Kiln upgrade
(if Kiln has not yet incorporated that version of Sesame): upgrading
the openrdf-sesame and openrdf-workbench webapps, and upgrading the
Sesame Cocoon transformer.

Upgrading the two Sesame webapps is straightforward. First delete
everything in ``webapps/openrdf-workbench``, and everything except
``app_dir`` (where the project data is kept) in
``webapps/openrdf-sesame``. Next unpack the contents of the two WAR
files distributed with Sesame into the appropriate directories. This
can be done with the command ``jar -xvf <filename>.war``.

Upgrading the transformer is more complicated. After fetching a copy
of the `transformer source code`_, the JAR files in ``lib/sesame-lib``
must be replaced with those from the Sesame download. It is unlikely
that all of the JARs that come with Sesame are required. Unless there
has been a change to Sesame's API, the transformer code does not need
to be modified. The transformer can be rebuilt using `Apache Ant`_
with the command ``ant dist``. All of the newly created JAR files in
the ``dist`` directory must then be copied to
``webapps/kiln/WEB-INF/lib/`` in place of their equivalents (the
filenames will differ, since the Sesame JARs have the version number
as part of the filename).


.. _Sesame: http://www.openrdf.org/
.. _create a repository: http://www.openrdf.org/doc/sesame2/users/ch06.html
.. _transformer source code: https://github.com/kcl-ddh/sesame-transformer
.. _Apache Ant: https://ant.apache.org/
