<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../kiln/stylesheets/solr/delete.xsl" />

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 18, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>This stylesheet converts a TEI document into a Solr delete document. It expects the parameter file-path,
      which is the path of the file being deleted.</xd:p>
    </xd:desc>
  </xd:doc>

  <!-- Path to the TEI file being deleted from Solr. -->
  <xsl:param name="file-path" />

  <xsl:template match="/">
    <xsl:call-template name="delete-by-query">
      <xsl:with-param name="query">file_path:"<xsl:value-of select="$file-path" />"</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
