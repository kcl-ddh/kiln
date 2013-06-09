.. _pdf:

PDF and ePub generation
=======================

Kiln provides sample pipeline matches for PDF and ePub generation from
TEI source files in ``sitemaps/main.xmap``. These make use of the same
templating system used for HTML generation.

Unlike with HTML generation, however, Kiln does not provide XSLT to
generate PDF and ePub output, as the variation in source markup and
desired output between projects is too great. Instead either XSLT can
be written from scratch, or existing stylesheets from other projects
can be adopted and adapted. The `suite of stylesheets`_ available from
the TEI website provide both XSL FO and ePub outputs; the former can
be turned into PDF via Cocoon's fo2pdf serialiser (as per the example
pipeline match).

.. _suite of stylesheets: http://www.tei-c.org/release/doc/tei-xsl-common/
