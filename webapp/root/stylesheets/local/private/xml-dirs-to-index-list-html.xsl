<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- XSLT to produce a list of links to the index URLs for each
       document in a recursive directory listing.
       
       Customisations to this code are likely to be to:
       
       * exclude some directories/files from being listed (so that
         they are not indexed); and
       * change the URL used to index specific files.

  -->

  <xsl:template match="/">
    <html>
      <head>
        <title>List of links to index documents in Solr</title>
      </head>
      <body>
        <h1>List of links to index documents in Solr</h1>

        <ul>
          <!-- Exclude the content directory from the path. -->
          <xsl:apply-templates select="dir:directory/*" />
        </ul>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="dir:directory">
    <xsl:param name="path" select="''" />
    <xsl:variable name="new_path" select="concat($path, @name, '/')" />
    <xsl:apply-templates select="dir:file">
      <xsl:with-param name="path" select="$new_path" />
    </xsl:apply-templates>
    <xsl:apply-templates select="dir:directory">
      <xsl:with-param name="path" select="$new_path" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:param name="path" />

    <xsl:variable name="filepath">
      <xsl:value-of select="$path" />
      <xsl:value-of select="@name" />
    </xsl:variable>
    <li>
      <!-- Link to the indexing pipeline for the specific file. -->
      <a href="tei/{$filepath}">
        <xsl:value-of select="$filepath" />
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>
