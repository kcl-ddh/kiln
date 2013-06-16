.. _admin:

Kiln's admin and editorial area
===============================

Kiln provides a URL space, under ``/admin/``, for administrative and
editorial tasks and resources. These may include indexing documents
into the Solr search engine, generating OAI-PMH records, and
creating and harvesting RDF triples into Sesame.

``sitemaps/admin.xmap`` specifies the applicable pipelines.


Adding authentication
---------------------

The simplest approach to password protecting the admin area is to make
use of `HTTP Authentication`_. The configuration for this depends on
which web server is sitting in front of Kiln --- it may be `Apache
Tomcat`_, `Apache HTTPD`_, `NGinix`_ or something else --- and its
documentation should be consulted.


.. _HTTP Authentication: http://www.ietf.org/rfc/rfc2617.txt
.. _Apache Tomcat: http://tomcat.apache.org/
.. _Apache HTTPD: http://httpd.apache.org/
.. _NGinix: http://nginx.org/en/
