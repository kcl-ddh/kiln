<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="mount">
    <xi:include>
      <xsl:attribute name="href">
        <xsl:text>cocoon://_internal/introspection/pipeline/</xsl:text>
        <xsl:value-of select="@src" />
        <xsl:text>/</xsl:text>
        <xsl:value-of select="@uri-prefix" />
      </xsl:attribute>
      <xi:fallback>Failed to XInclude the sitemaps referenced in the mount table.</xi:fallback>
    </xi:include>
  </xsl:template>

</xsl:stylesheet>
