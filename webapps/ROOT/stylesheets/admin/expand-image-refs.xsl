<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Expand on a base list of images referenced in XML files in
       order to accommodate multiple derivatives of the same imagge
       (eg thumbnails), and to specify full filesystem paths for
       each. -->

  <xsl:template match="file">
    <referring_file>
      <xsl:apply-templates select="@*|node()"/>
    </referring_file>
  </xsl:template>

  <xsl:template match="image">
    <xsl:variable name="current" select="."/>
    <file>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="path">
        <xsl:text>content/images/</xsl:text>
        <xsl:value-of select="../@xml:id" />
        <xsl:text>/</xsl:text>
        <xsl:value-of select="@url"/>
      </xsl:attribute>
    </file>
    <!-- @type specifies the extra formats an image is available in,
         such as thumbnail. The space-separated values are used as
         directory names in the image path. -->
    <xsl:for-each select="tokenize(@type, ' ')">
      <file>
        <xsl:apply-templates select="$current/@*" mode="thumbnail"/>
        <xsl:attribute name="path">
          <xsl:text>content/images/</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="$current/@url"/>
        </xsl:attribute>
      </file>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="@height" mode="thumbnail"/>
  <xsl:template match="@width" mode="thumbnail"/>

  <xsl:template match="@*|node()" mode="#all">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
