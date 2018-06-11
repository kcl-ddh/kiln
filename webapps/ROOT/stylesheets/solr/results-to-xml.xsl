<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="cocoon://_internal/url/reverse.xsl" />

  <xsl:param name="language" />
  <xsl:param name="query-string" />
  <xsl:param name="scheme" />
  <xsl:param name="server-name" />
  <xsl:param name="server-port" />

  <xsl:template match="aggregation">
    <search>
      <url>
        <xsl:value-of select="$scheme" />
        <xsl:text>://</xsl:text>
        <xsl:value-of select="$server-name" />
        <xsl:if test="normalize-space($server-port)">
          <xsl:text>:</xsl:text>
          <xsl:value-of select="$server-port" />
        </xsl:if>
        <xsl:value-of select="kiln:url-for-match('local-search', ($language), 0)" />
        <xsl:if test="normalize-space($query-string)">
          <xsl:text>?</xsl:text>
          <xsl:value-of select="$query-string" />
        </xsl:if>
      </url>
      <xsl:apply-templates select="response/result" />
     </search>
  </xsl:template>

  <xsl:template match="doc">
    <result>
      <xsl:apply-templates />
    </result>
  </xsl:template>

  <xsl:template match="doc/arr">
    <xsl:element name="{@name}">
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="doc/str">
    <xsl:element name="{@name}">
      <value>
        <xsl:value-of select="." />
      </value>
    </xsl:element>
  </xsl:template>

  <xsl:template match="result">
    <results count="{@numFound}">
      <xsl:apply-templates select="doc" />
    </results>
  </xsl:template>

  <xsl:template match="arr/str">
    <value>
      <xsl:value-of select="." />
    </value>
  </xsl:template>

</xsl:stylesheet>
