<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.cch.kcl.ac.uk/xmod/metadata/images/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
  xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" />

  <xsl:param name="path" />

  <xsl:template match="/">
    <file path="{replace($path, '.xml', '.html')}" xml:id="{tei:TEI/@xml:id}">
      <xsl:apply-templates select="//tei:graphic"/>
    </file>
  </xsl:template>

  <xsl:template match="tei:graphic">
    <xsl:if test="not(preceding::tei:graphic/@url=current()/@url)">
      <image>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="../tei:figDesc"/>
      </image>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:figDesc">
    <xsl:attribute name="alt">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@height | @mimeType | @url | @width">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="@xmt:type">
    <xsl:attribute name="type">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@*|node()"/>

</xsl:stylesheet>
