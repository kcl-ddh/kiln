<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Extract the div containing information about a specific index
       from the index TEI file. -->

  <xsl:param name="index-name" />

  <xsl:template match="/">
    <xsl:copy-of select="id($index-name)" />
  </xsl:template>

</xsl:stylesheet>
