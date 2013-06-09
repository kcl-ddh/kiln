<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- XSLT to delete all data from a Solr index. -->

  <xsl:import href="../../kiln/stylesheets/solr/delete.xsl" />

  <xsl:template match="/">
    <xsl:call-template name="delete-by-query">
      <xsl:with-param name="query">*:*</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
