<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a TEI document's tables into HTML. -->

  <xsl:template match="tei:cell">
    <xsl:variable name="cell-element">
      <xsl:choose>
        <xsl:when test="@role='label' or parent::tei:row/@role='label'">
          <xsl:text>th</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>td</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$cell-element}">
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="'cell'" />
      </xsl:call-template>
      <xsl:apply-templates select="node()" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:row">
    <tr>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes" />
      <xsl:apply-templates select="node()" />
    </tr>
  </xsl:template>

  <xsl:template match="tei:table">
    <table>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes" />
      <xsl:apply-templates select="node()" />
    </table>
  </xsl:template>

  <xsl:template match="tei:table/tei:head">
    <caption>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes" />
      <xsl:apply-templates select="node()" />
    </caption>
  </xsl:template>

  <xsl:template match="tei:cell/@cols">
    <xsl:if test=". > 1">
      <xsl:attribute name="colspan">
        <xsl:value-of select="." />
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:cell/@rows">
    <xsl:if test=". > 1">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="." />
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
