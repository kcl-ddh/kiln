<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:dummy="http://www.example.org/dummy-ns"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Change the namespace of XInclude elements from dummy to xi, as
       a correction to the reverse process performed in
       compose-xslt.xsl. -->

  <xsl:template match="dummy:*">
    <xsl:variable name="unmangled-name">
      <xsl:text>xi:</xsl:text>
      <xsl:value-of select="local-name(.)" />
    </xsl:variable>
    <xsl:element name="{$unmangled-name}">
      <xsl:apply-templates select="@*|node()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
