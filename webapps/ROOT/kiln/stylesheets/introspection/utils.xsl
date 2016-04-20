<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="strip-url">
    <xsl:param name="url" />
    <xsl:variable name="cocoon-stripped"
                  select="substring-after($url, 'cocoon://')" />
    <!-- Remove query-string parameters from the URL, since they can
         completely mess up the pattern matching. -->
    <xsl:choose>
      <xsl:when test="contains($cocoon-stripped, '?')">
        <xsl:value-of select="substring-before($cocoon-stripped, '?')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$cocoon-stripped" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
