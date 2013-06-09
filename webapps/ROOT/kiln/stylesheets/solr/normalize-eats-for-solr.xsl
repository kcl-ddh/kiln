<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:eats="http://hdl.handle.net/10063/234"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Nov 4, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>Normalizes the EATSML for Solr indexing.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:template match="/">
    <entities>
      <xsl:apply-templates select="eats:collection/eats:entities" />
    </entities>
  </xsl:template>

  <xsl:template match="eats:entity">
    <entity>
      <keys>
        <xsl:apply-templates select="eats:existence_assertions" />
      </keys>
      <names>
        <xsl:apply-templates select="eats:name_assertions" />
      </names>
    </entity>
  </xsl:template>

  <xsl:template match="eats:existence_assertion">
    <key>
      <xsl:apply-templates select="id(@authority_record)" />
    </key>
  </xsl:template>

  <xsl:template match="eats:authority_record">
    <xsl:if test="eats:authority_system_id/@is_complete = 'false'">
      <xsl:apply-templates select="id(@authority)" />
    </xsl:if>

    <xsl:value-of select="eats:authority_system_id" />
  </xsl:template>

  <xsl:template match="eats:authority">
    <xsl:value-of select="eats:base_id" />
  </xsl:template>

  <xsl:template match="eats:name_assertion">
    <name>
      <xsl:choose>
        <xsl:when test="normalize-space(eats:display_form)">
          <xsl:value-of select="normalize-space(eats:display_form)" />
        </xsl:when>
        <xsl:when test="normalize-space(eats:assembled_form)">
          <xsl:value-of select="normalize-space(eats:assembled_form)" />
        </xsl:when>
      </xsl:choose>
    </name>
  </xsl:template>
</xsl:stylesheet>
