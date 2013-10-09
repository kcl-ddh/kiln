.. _fedora:

Fedora Repository
=================

Kiln includes pipelines for fetching data from a `Fedora Commons`_
repository. The generic matches for fetching XML and binary data are
in ``webapps/ROOT/kiln/sitemaps/fedora.xmap``, which should be
accessed via matches in ``webapps/ROOT/sitemaps/fedora.xmap``. The
latter likely need to be customised to match the way the specific
Fedora repository has been set up.

It is also necessary to set the global variable ``fedora-url`` in
``webapps/ROOT/sitemaps/config.xmap``.


.. _Fedora Commons: http://fedora-commons.org/
