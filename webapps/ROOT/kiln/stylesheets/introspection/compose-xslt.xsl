<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:dummy="http://www.example.org/dummy-ns"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="base_url" />

  <xsl:template match="xsl:import | xsl:include">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      <xi:include>
        <xsl:attribute name="href">
          <xsl:text>cocoon://_internal/introspection/xslt/</xsl:text>
          <xsl:choose>
            <xsl:when test="starts-with(@href, 'cocoon://')">
              <xsl:text>cocoon/</xsl:text>
              <xsl:value-of select="substring-after(@href, 'cocoon://')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$base_url" />
              <xsl:text>/</xsl:text>
              <xsl:value-of select="substring-before(@href, '.xsl')" />
              <xsl:text>.xml</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xi:include>
    </xsl:copy>
  </xsl:template>

  <!-- Renamespace any XInclude elements in the source document, since
       otherwise they will be included (or, likely, fail trying to
       catastrophic effect) by the Cocoon xinclude transformation that
       follows the application of this XSLT. -->
  <xsl:template match="xi:*">
    <xsl:variable name="mangled-name">
      <xsl:text>dummy:</xsl:text>
      <xsl:value-of select="local-name(.)" />
    </xsl:variable>
    <xsl:element name="{$mangled-name}">
      <xsl:apply-templates select="@*|node()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
