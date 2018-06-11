<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="cocoon://_internal/url/reverse.xsl" />

  <xsl:param name="subdirectory" />

  <xsl:template match="insert">
    <xsl:copy>
      <xsl:apply-templates select="tei:TEI/tei:text/tei:body/tei:div[@xml:id]" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:div">
    <index name="{tei:head}" xml:id="{@xml:id}">
      <xi:include href="{kiln:url-for-match('local-solr-add-index', ($subdirectory, @xml:id), 1)}" />
    </index>
  </xsl:template>

</xsl:stylesheet>
