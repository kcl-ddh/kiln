<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of TEI documents into a Solr index document. -->

  <xsl:import href="tei-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:placeName[ancestor::tei:div]" group-by=".">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:variable name="pl-id" select="substring-after(@ref,'#')"/>
            <xsl:variable name="place-id" select="document('../../content/xml/authority/listPlace.xml')//tei:place[@xml:id=$pl-id]/tei:placeName"/>
                <xsl:choose>
                  <xsl:when test="$place-id"><xsl:value-of select="$place-id" /></xsl:when>
                  <xsl:when test="$pl-id"><xsl:value-of select="$pl-id" /></xsl:when>
                  <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
                </xsl:choose>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:placeName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
