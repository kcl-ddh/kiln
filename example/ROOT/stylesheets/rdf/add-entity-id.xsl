<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="entity_id" />

  <xsl:template match="entity_id">
    <xsl:value-of select="$entity_id" />
  </xsl:template>

  <xsl:template match="query">
    <xsl:copy>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
