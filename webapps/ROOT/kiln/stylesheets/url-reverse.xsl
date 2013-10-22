<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:map="http://apache.org/cocoon/sitemap/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Generates an XSLT that provides a named template,
       url-for-match, that generates a full URL from a map:match ID
       and a sequence of parameters. -->

  <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="axsl" />

  <xsl:include href="../../stylesheets/defaults.xsl" />

  <xsl:template match="/">
    <axsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <axsl:template name="url-for-match">
        <axsl:param name="match-id" />
        <axsl:param name="parameters" />
        <axsl:choose>
          <xsl:apply-templates select="//map:match[@id][not(map:mount)]" />
        </axsl:choose>
      </axsl:template>
    </axsl:stylesheet>
  </xsl:template>

  <xsl:template match="map:match">
    <axsl:when test="$match-id = '{@id}'">
      <xsl:value-of select="$kiln:context-path" />
      <axsl:text><xsl:value-of select="$kiln:context-path" />/</axsl:text>
      <xsl:for-each select="tokenize(@kiln:pattern, '(\*\*)|(\*)')">
        <xsl:if test="position() &gt; 1">
          <axsl:value-of select="$parameters[{position()}-1]" />
        </xsl:if>
        <xsl:if test="normalize-space(.)">
          <axsl:text><xsl:value-of select="." /></axsl:text>
        </xsl:if>
      </xsl:for-each>
    </axsl:when>
  </xsl:template>

  <xsl:template name="foo">
      <xsl:choose>
        <xsl:when test="contains(@kiln:pattern, '*')">
          <xsl:call-template name="replace-wildcards">
            <xsl:with-param name="pattern" select="@kiln:pattern" />
            <xsl:with-param name="index" select="1" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <axsl:text><xsl:value-of select="@kiln:pattern" /></axsl:text>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template name="replace-wildcards">
    <xsl:param name="pattern" />
    <xsl:param name="index" />
    <axsl:text><xsl:value-of select="substring-before($pattern, '*')" /></axsl:text>
    <xsl:variable name="reduced-string">
      <xsl:call-template name="reduce-string">
        <xsl:with-param name="string" select="$pattern" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="starts-with($reduced-string, '**')">
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="reduce-string">
    <xsl:param name="string" />
    <xsl:variable name="length"
                  select="string-length(substring-before($string, '*')" />
    <xsl:value-of select="substring($string, 1, $length)" />
  </xsl:template>

</xsl:stylesheet>
