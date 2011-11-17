<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a TEI document into a Solr delete document. -->

  <!-- Creates a Solr delete document to delete by id. -->
  <xsl:template name="delete-by-id">
    <xsl:param name="id" required="yes" />
    
    <delete>
      <id>
        <xsl:value-of select="$id" />
      </id>
    </delete>
  </xsl:template>

  <!-- Creates a Solr delete document to delete by query. -->
  <xsl:template name="delete-by-query">
    <xsl:param name="query" required="yes" />

    <delete>
      <query>
        <xsl:value-of select="$query" />
      </query>
    </delete>
  </xsl:template>
</xsl:stylesheet>
