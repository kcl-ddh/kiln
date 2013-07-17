<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:map="http://apache.org/cocoon/sitemap/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="aggregation/map:sitemap" mode="kiln-visualise">
    <xsl:apply-templates mode="kiln-visualise" select=".//map:match[@id]">
      <xsl:sort select="@id" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="map:match[@id]" mode="kiln-visualise">
    <li>
      <a href="match/{@id}.html">
        <xsl:value-of select="@id" />
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>
