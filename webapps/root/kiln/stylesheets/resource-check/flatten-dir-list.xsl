<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Convert a Cocoon directory listing into a flat list of files
       with a path attribute that gives the full path (including
       filename). -->

  <xsl:template match="/">
    <files>
      <xsl:apply-templates>
        <xsl:with-param name="root" select="'/content'"/>
      </xsl:apply-templates>
    </files>
  </xsl:template>

  <xsl:template match="dir:directory">
    <xsl:param name="root"/>
    <xsl:apply-templates>
      <xsl:with-param name="root" select="concat($root, '/', @name)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:param name="root"/>
    <file path="{concat($root, '/', @name)}">
      <xsl:copy-of select="@*"/>
    </file>
  </xsl:template>

</xsl:stylesheet>