<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:map="http://apache.org/cocoon/sitemap/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Generates an XSLT that provides a named template,
       url-for-match, that generates a full URL from a map:match ID,
       a sequence of parameters, and a Boolean indicating whether to
       always generate a cocoon:// URL or not. -->

  <xsl:namespace-alias result-prefix="xsl" stylesheet-prefix="axsl" />

  <xsl:include href="../../stylesheets/defaults.xsl" />

  <xsl:template match="/">
    <axsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <axsl:function name="kiln:url-for-match" as="xs:string">
        <axsl:param name="match-id" as="xs:string" />
        <axsl:param name="parameters" />
        <axsl:param name="cocoon-context" />
        <axsl:variable name="url">
          <axsl:choose>
            <xsl:apply-templates select="//map:match[@id][not(map:mount)]" />
          </axsl:choose>
        </axsl:variable>
        <axsl:variable name="full-url">
          <axsl:if test="$cocoon-context and not(starts-with($url, 'cocoon://'))">
            <xsl:text>cocoon:/</xsl:text>
          </axsl:if>
          <axsl:value-of select="$url" />
        </axsl:variable>
        <axsl:value-of select="$full-url" />
      </axsl:function>
    </axsl:stylesheet>
  </xsl:template>

  <xsl:template match="map:match">
    <axsl:when test="$match-id = '{@id}'">
      <xsl:choose>
        <xsl:when test="ancestor::map:pipeline[1]/@internal-only='true'">
          <axsl:text>cocoon://</axsl:text>
        </xsl:when>
        <xsl:otherwise>
          <axsl:text><xsl:value-of select="$kiln:context-path" />/</axsl:text>
        </xsl:otherwise>
      </xsl:choose>
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

</xsl:stylesheet>
