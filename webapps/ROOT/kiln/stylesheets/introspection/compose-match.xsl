<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:map="http://apache.org/cocoon/sitemap/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Generate a complete view of a particular map:match, with any
       other referenced map:matches included as children. This
       inclusion is done recursively. -->

  <xsl:import href="utils.xsl" />

  <xsl:param name="match_id" />

  <xsl:template match="/">
    <xsl:apply-templates select="//map:match[@id=$match_id]" />
  </xsl:template>

  <xsl:template match="map:match">
    <xsl:copy>
      <xsl:attribute name="kiln:sitemap"
                     select="ancestor::map:sitemap[1]/@kiln:file" />
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="map:generate | map:part | map:transform">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
      <xsl:call-template name="match-pattern">
        <xsl:with-param name="match" select="ancestor::map:match[1]" />
        <xsl:with-param name="reference" select="@kiln:src" />
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="match-pattern">
    <xsl:param name="match" />
    <xsl:param name="reference" />
    <xsl:if test="starts-with($reference, 'cocoon://')">
      <xsl:variable name="stripped">
        <xsl:call-template name="strip-url">
          <xsl:with-param name="url" select="$reference" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="input">
        <xsl:for-each select="tokenize($stripped, '(\{)|(\})')">
          <xsl:choose>
            <xsl:when test="position() mod 2">
              <!-- Not a reference to a pattern group. -->
              <xsl:value-of select="." />
            </xsl:when>
            <xsl:otherwise>
              <!-- A reference to a pattern group. -->
              <xsl:variable name="name" select="concat('kiln:g', .)" />
              <xsl:value-of select="$match/@*[name() = $name]" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>
      <xsl:apply-templates select="(//map:match[not(map:mount)][normalize-space(@kiln:regexp) and matches($input, @kiln:regexp)])[1]" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="@value">
    <xsl:copy />
    <xsl:if test="contains(., '{global:')">
      <xsl:variable name="root" select="/" />
      <xsl:attribute name="kiln:value">
        <xsl:for-each select="tokenize(., '\{global:')">
          <xsl:choose>
            <xsl:when test="position() = 1">
              <xsl:value-of select="." />
            </xsl:when>
            <xsl:otherwise>
              <!-- A global variable name, and possibly some extra
                   content. -->
              <xsl:variable name="global-variable-name"
                            select="substring-before(., '}')" />
              <xsl:value-of select="$root//global-variables/*[name()=$global-variable-name]" />
              <xsl:value-of select="substring-after(., '}')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
