<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Convert a bibliography authority TEI document to a concordance
       index. -->

  <xsl:template match="arr[@name='concordance_bibliography_item']">
    <td>
      <ul class="inline-list">
        <xsl:apply-templates select="str" />
      </ul>
    </td>
  </xsl:template>

  <xsl:template match="doc" mode="item-display">
    <tr>
      <xsl:apply-templates select="str[@name='concordance_bibliography_cited_range']" />
      <xsl:apply-templates select="arr[@name='concordance_bibliography_item']" />
    </tr>
  </xsl:template>

  <xsl:template match="doc" mode="bibl-list">
    <xsl:variable name="bibl-id" select="substring-after(str[@name='concordance_bibliography_ref'], '#')" />
    <li>
      <a href="{kiln:url-for-match('local-concordance-bibliography-item', ($language, $bibl-id), 0)}">
        <xsl:apply-templates mode="full-citation" select="id($bibl-id)" />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="str[@name='concordance_bibliography_cited_range']">
    <td>
      <xsl:value-of select="." />
    </td>
  </xsl:template>

  <xsl:template match="arr[@name='concordance_bibliography_item']/str">
    <li>
      <a href="{kiln:url-for-match('local-epidoc-display-html', ($language, .), 0)}">
        <xsl:value-of select="." />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="tei:author">
    <xsl:value-of select="." />
    <xsl:if test="following-sibling::tei:author">
      <xsl:text>,</xsl:text>
    </xsl:if>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:bibl" mode="full-citation">
    <xsl:apply-templates select="tei:author" />
    <xsl:apply-templates select="tei:editor" />
    <xsl:apply-templates select="tei:date" />
    <xsl:apply-templates select="tei:title" />
  </xsl:template>

  <xsl:template match="tei:bibl" mode="short-citation">
    <xsl:choose>
      <xsl:when test="tei:editor">
        <xsl:value-of select="tei:editor[1]" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="tei:author[1]" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
    <xsl:value-of select=".//tei:date[1]" />
  </xsl:template>

  <xsl:template match="tei:editor">
    <xsl:value-of select="." />
    <xsl:choose>
      <xsl:when test="following-sibling::tei:editor">
        <xsl:text>, </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> (ed</xsl:text>
        <xsl:if test="preceding-sibling::tei:editor">
          <xsl:text>s</xsl:text>
        </xsl:if>
        <xsl:text>) </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
