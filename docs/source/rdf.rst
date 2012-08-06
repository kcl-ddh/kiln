.. _rdf:

RDF / Linked Open Data
======================

Kiln includes the `Sesame`_ framework for handling RDF data. Sesame
operates as a pair of Java webapps (``sesame`` and
``sesame-workbench``), and work no differently within Kiln as they do
standalone. This includes extending it, for example by using OWLIM as
the repository, and using its web interfaces.

Setting up a repository
-----------------------

The Sesame documentation covers how to `create a repository`_\. Once
created, the name of the repository must be set as the value of the
``sesame-server-repository`` variable in
``webapps/root/sitemaps/config.xmap``.

Integration with Cocoon
-----------------------

Kiln integrates Sesame into its Cocoon processing via a Sesame
transformer and a set of pipelines. The local sitemap
``sitemaps/rdf.xmap`` can be extended with matches to generate RDF/XML
and SPARQL graph queries. The basic operations are defined in the
internal kiln sitemap ``kiln/sitemaps/sesame.xmap``.


.. _Sesame: http://www.openrdf.org/
.. _create a repository: http://www.openrdf.org/doc/sesame2/users/ch06.html
