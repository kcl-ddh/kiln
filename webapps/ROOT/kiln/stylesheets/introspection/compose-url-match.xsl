<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:map="http://apache.org/cocoon/sitemap/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Generate a complete view of the map:match that processes the
       supplied URL, with any other referenced map:matches included as
       children. This inclusion is done recursively.

       This XSLT is very similar to compose-match.xsl but is sadly
       different in small details so that there is no value to
       overriding it. -->

  <xsl:import href="utils.xsl" />

  <xsl:param name="url" />

  <xsl:variable name="separator" select="' SEPARATOR '" />

  <xsl:template match="/">
    <!-- There is a very odd behaviour with the use of matches in the
         following expression. If it is provided in a predicate of its
         own, it appears to be evaluated before the predicate
         requiring the existing of @kiln:regexp.

         Therefore, have a single predicate expressing the requirement
         for @kiln:regexp and performing the match. -->
    <xsl:apply-templates select="(//map:match[not(map:mount)][normalize-space(@kiln:regexp) and matches($url, @kiln:regexp)])[1]">
      <xsl:with-param name="url" select="$url" tunnel="yes" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="map:match">
    <xsl:variable name="groups" as="xs:string*">
      <xsl:call-template name="get-groups">
        <xsl:with-param name="regexp" select="@kiln:regexp" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:copy>
      <xsl:attribute name="kiln:sitemap"
                     select="ancestor::map:sitemap[1]/@kiln:file" />
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="groups" select="$groups" tunnel="yes" />
      </xsl:apply-templates>
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

  <xsl:template match="@kiln:pattern">
    <xsl:param name="url" tunnel="yes" />
    <xsl:attribute name="kiln:pattern">
      <xsl:value-of select="$url" />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@kiln:src">
    <xsl:attribute name="kiln:src">
      <xsl:call-template name="expand-variables" />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@value">
    <xsl:copy />
    <xsl:if test="contains(., '{')">
      <xsl:attribute name="kiln:value">
        <xsl:call-template name="expand-variables" />
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="expand-variables">
    <xsl:param name="groups" tunnel="yes" />
    <xsl:variable name="root" select="/" />
    <xsl:for-each select="tokenize(., '\{')">
      <xsl:choose>
        <xsl:when test="position() = 1">
          <xsl:value-of select="." />
        </xsl:when>
        <xsl:when test="starts-with(., 'global:')">
          <!-- A global variable name, and possibly some extra
               content. -->
          <xsl:variable name="global-variable-name"
                        select="substring-before(substring-after(., 'global:'), '}')" />
          <xsl:value-of select="$root//global-variables/*[name()=$global-variable-name]" />
          <xsl:value-of select="substring-after(., '}')" />
        </xsl:when>
        <xsl:otherwise>
          <!-- A group reference, and possibly some extra content. -->
          <xsl:variable name="group-ref"
                        select="number(substring-before(., '}'))" />
          <xsl:value-of select="$groups[$group-ref]" />
          <xsl:value-of select="substring-after(., '}')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="get-groups">
    <!-- Create a sequence of the group values in $url, as applied to
         $regexp. -->
    <xsl:param name="regexp" />
    <xsl:param name="url" tunnel="yes" />
    <xsl:variable name="replacement">
      <xsl:for-each select="1 to (count(tokenize($regexp, '\+\)'))-1)">
        <xsl:text>$</xsl:text>
        <xsl:value-of select="." />
        <xsl:if test="position() != last()">
          <xsl:value-of select="$separator" />
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$regexp = '^$'">
        <xsl:sequence select="()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="tokenize(replace($url, $regexp, $replacement), $separator)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="match-pattern">
    <xsl:param name="groups" tunnel="yes" />
    <xsl:param name="match" />
    <xsl:param name="reference" />
    <xsl:if test="starts-with($reference, 'cocoon://')">
      <xsl:variable name="cocoon-stripped"
                    select="substring-after($reference, 'cocoon://')" />
      <!-- Remove query-string parameters from the URL, since they can
           completely mess up the pattern matching. -->
      <xsl:variable name="stripped">
        <xsl:choose>
          <xsl:when test="contains($cocoon-stripped, '?')">
            <xsl:value-of select="substring-before($cocoon-stripped, '?')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$cocoon-stripped" />
          </xsl:otherwise>
        </xsl:choose>
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
              <xsl:variable name="num" select="number(.)" />
              <xsl:value-of select="$groups[$num]" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>
      <xsl:apply-templates select="(//map:match[not(map:mount)][normalize-space(@kiln:regexp) and matches($input, @kiln:regexp)])[1]">
        <xsl:with-param name="url" select="$input" tunnel="yes" />
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
