<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="aggregation">
    <xsl:copy>
      <xsl:copy-of select="*" />
      <xi:include>
        <xsl:attribute name="href">
          <xsl:text>cocoon://_internal/sesame/query/graph/recipient/</xsl:text>
          <xsl:value-of select="normalize-space(tei:TEI/tei:teiHeader/tei:profileDesc/tei:particDesc//tei:person[@role='recipient'])" />
          <xsl:text>.xml</xsl:text>
        </xsl:attribute>
      </xi:include>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
