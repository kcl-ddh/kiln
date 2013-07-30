<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a TEI document's @rend into HTML. -->

  <!-- Generic (CSS-based) -->
  <xsl:template match="tei:hi[@rend]" priority="-1">
    <xsl:variable name="class">
      <xsl:apply-templates mode="rend-class" select="@rend" />
    </xsl:variable>
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="normalize-space($class)" />
      </xsl:attribute>
      <xsl:apply-templates />
    </span>
  </xsl:template>

  <!-- Italics -->
  <xsl:template match="tei:hi[@rend='i']">
    <i>
      <xsl:apply-templates />
    </i>
  </xsl:template>

  <!-- Bold -->
  <xsl:template match="tei:hi[@rend='b']">
    <b>
      <xsl:apply-templates />
    </b>
  </xsl:template>

  <!-- Subscript -->
  <xsl:template match="tei:hi[@rend='sub']">
    <sub>
      <xsl:apply-templates />
    </sub>
  </xsl:template>

  <!-- Superscript -->
  <xsl:template match="tei:hi[@rend='sup']">
    <sup>
      <xsl:apply-templates />
    </sup>
  </xsl:template>

  <xsl:template match="@rend" mode="rend-class">
    <xsl:choose>
      <xsl:when test=". = 'i'">
        <xsl:text>italic </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'b'">
        <xsl:text>bold </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'c'">
        <xsl:text>caps </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'u'">
        <xsl:text>underline </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'lc'">
        <xsl:text>lowercase </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'sc'">
        <xsl:text>small-caps </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'lsc'">
        <xsl:text>lowercase-small-caps </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'strike'">
        <xsl:text>strikethrough </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'small'">
        <xsl:text>smaller </xsl:text>
      </xsl:when>
      <!-- A colon indicates a CSS rule that belongs in the style
           attribute, so do not handle it here. -->
      <xsl:when test="contains(., ':')" />
      <xsl:otherwise>
        <xsl:value-of select="." />
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@rend" mode="rend-style">
    <xsl:if test="contains(., ':')">
      <xsl:value-of select="." />
      <xsl:text>; </xsl:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
