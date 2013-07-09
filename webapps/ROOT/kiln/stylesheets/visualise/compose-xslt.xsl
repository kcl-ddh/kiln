<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="base_url" />

  <xsl:template match="xsl:import | xsl:include">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      <xi:include href="cocoon://_internal/visualise/xslt/{$base_url}/{substring-before(@href, '.xsl')}.xml" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
