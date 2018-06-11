URL matching
============

Kiln provides a mechanism for generating full URLs to Kiln resources
based on the ID of a sitemap's ``map:match`` element. Since the actual
URL is specified only in the ``map:match/@pattern``, it can be changed
without breaking any generated links, provided the number and order of
wildcards in the ``@pattern`` are not changed. If they are, then at
least it is easy to find all references to that ``map:match`` by
searching the XSLT for its ``@id``.

To use this functionality, include the XSLT
``cocoon://_internal/url/reverse.xsl`` and call the
``kiln:url-for-match`` function, passing the ID of the ``map:match``
to generate a URL for, a sequence containing any wildcard parameters
for that URL, and a Boolean indicating whether to force the URL to be
a ``cocoon://`` URL. For example::

   <a href="{kiln:url-for-match('local-tei-display-html', ($language, 'Had1.xml'), 0)}">
     <xsl:text>Link title</xsl:text>
   </a>

This generates a root-relative URL based on the ``@pattern`` value of the
``map:match`` with the ID "local-tei-display-html". If the identified
``map:match`` is part of a pipeline that is marked as
``internal-only="true"``, the generated URL is a ``cocoon://`` URL.

If no wildcard parameters are required, pass an empty sequence::

  <a href="{kiln:url-for-match('local-search', (), 0)}">Search</a>

If the third argument is true (eg, 1), then regardless of whether the
pipeline the match belongs to is internal or not, the generated URL
will be a ``cocoon://`` URL. This should be used when the generated
URL will be used for situations in which the URL is evaluated without
a webserver context, such as XIncludes.

Be sure to declare the kiln namespace
(``http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0``), or else the
call will be treated as a plain string.

.. warning:: Neither Kiln nor Cocoon performs any checks that the
   ``id`` values you assign to ``map:match`` elements are unique,
   either within a single sitemap file or across multiple sitemaps. If
   the same ID is used more than once, the first one (in sitemap
   order) will be used by the ``url-for-match`` template.

.. warning:: When developing in Kiln, be aware that all of the sitemap
   files must be well-formed XML, or this XSLT will not produce any
   results. This may lead to odd problems throughout the site that
   have no connection with the invalid sitemap.
