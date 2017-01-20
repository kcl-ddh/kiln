<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="kiln:escape-value">
    <!-- Some search characters should be escaped, such as ":". The
         value may already be URL-escaped. -->
    <xsl:param name="value" />
    <xsl:param name="url-escaped" select="0" />
    <xsl:choose>
      <xsl:when test="$url-escaped">
        <xsl:value-of select="replace($value, '%3A', '\\%3A')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="replace($value, ':', '\\:')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="kiln:unescape-value">
    <!-- Undo the escaping that is done in kiln:escape-value. -->
    <xsl:param name="value" />
    <xsl:param name="url-escaped" select="0" />
    <xsl:choose>
      <xsl:when test="$url-escaped">
        <xsl:value-of select="replace($value, '\\%3A', '%3A')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="replace($value, '\\:', ':')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
