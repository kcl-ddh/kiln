<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a TEI document's lists into HTML. -->

  <xsl:template match="tei:list">
    <xsl:apply-templates select="tei:head" />
    <!-- Determine whether ordered or unordered list -->
    <xsl:variable name="listtype">
      <xsl:choose>
        <xsl:when test="@type = 'ordered'">
          <xsl:value-of select="'ol'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'ul'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$listtype}">
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="local-name()" />
      </xsl:call-template>
      <xsl:apply-templates select="tei:item" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:list[tei:label]">
    <xsl:apply-templates select="tei:head" />
    <table>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes" />
      <xsl:apply-templates select="tei:item" />
    </table>
  </xsl:template>

  <xsl:template match="tei:item">
    <li>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="local-name()" />
      </xsl:call-template>
      <xsl:apply-templates select="node()" />
    </li>
  </xsl:template>

  <xsl:template match="tei:list[tei:label]/tei:item">
    <tr>
      <xsl:apply-templates select="preceding-sibling::tei:label[1]" />
      <td>
        <xsl:apply-templates select="@*" />
        <xsl:call-template name="tei-assign-classes" />
        <xsl:apply-templates select="node()" />
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="tei:list/tei:label">
    <td>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes" />
      <xsl:apply-templates select="node()" />
    </td>
  </xsl:template>

</xsl:stylesheet>
