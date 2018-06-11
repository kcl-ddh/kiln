<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="2.0">

  <!-- EpiDoc specific extension to stylesheets/prune-to-language.xsl. -->

  <xsl:import href="../prune-to-language.xsl" />

  <xsl:template priority="10" match="tei:div[@type='edition']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
