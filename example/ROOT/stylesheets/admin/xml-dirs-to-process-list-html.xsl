<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../defaults.xsl"/>

  <xsl:param name="initial_path" select="''"/>

  <xsl:template match="dir:directory">
    <xsl:param name="path"/>
    <xsl:variable name="new_path" select="concat($path, @name, '/')"/>
    <xsl:apply-templates select="dir:file">
      <xsl:with-param name="path" select="$new_path"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="dir:directory">
      <xsl:with-param name="path" select="$new_path"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:param name="path"/>
    <xsl:variable name="filepath">
      <xsl:value-of select="$path"/>
      <xsl:value-of select="substring-before(@name, '.xml')"/>
    </xsl:variable>
    <tr>
      <!-- File path. -->
      <td>
        <xsl:value-of select="$filepath"/>
        <xsl:text>.xml</xsl:text>
      </td>
      <!-- Default Schematron link. -->
      <td>
        <a href="schematron/{$initial_path}{$filepath}.html">Validate</a>
      </td>
      <!-- Image checking. -->
      <td></td>
      <!-- Search indexing. -->
      <td>
        <a href="../solr/index/{$initial_path}{$filepath}.html"
            title="Index document in search server">Index</a>
      </td>
      <!-- RDF harvesting. -->
      <td>
        <a href="../rdf/harvest/{$initial_path}{$filepath}.html"
           title="Harvest RDF from document">Harvest</a>
      </td>
      <!-- View on site. -->
      <td></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
