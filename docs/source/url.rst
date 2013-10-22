URL matching
============

Kiln provides a mechanism for generating full URLs to Kiln resources
based on the ID of a sitemap's ``map:match`` element. Since the actual
URL is specified only in the ``map:match/@pattern``, it can be changed
without breaking any generated links.

To use this functionality, include the XSLT
``cocoon://_internal/url/reverse.xsl`` and call the ``url-for-match``
template, passing the ID of the ``map:match`` to generate a URL for,
and a sequence containing any wildcard parameters for that URL. For
example::

   <a>
     <xsl:attribute name="href">
       <xsl:call-template name="url-for-match">
         <xsl:with-param name="match-id"
                         select="'local-tei-display-html'" />
         <xsl:with-param name="parameters" select="('Had1.xml')" />
       </xsl:call-template>
     </xsl:attribute>
   </a>

This generates a URL based on the ``@pattern`` value of the
``map:match`` with the id "local-tei-display-html".

.. warning:: Neither Kiln nor Cocoon performs any checks that the
   ``id`` values you assign to ``map:match`` elements are unique,
   either within a single sitemap file or across multiple sitemaps. If
   the same ID is used more than once, the first one (in sitemap
   order) will be used by the ``url-for-match`` template.
