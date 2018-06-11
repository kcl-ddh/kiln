<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Index references to bibliographic items. -->

  <xsl:param name="file-path" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:body/tei:div[@type='bibliography']//tei:bibl/tei:ptr" group-by="@target">
        <xsl:variable name="target" select="@target" />
        <xsl:for-each-group select="current-group()" group-by="../tei:citedRange">
          <doc>
            <field name="document_type">
              <xsl:text>concordance_bibliography</xsl:text>
            </field>
            <field name="file_path">
              <xsl:value-of select="$file-path" />
            </field>
            <field name="concordance_bibliography_ref">
              <xsl:value-of select="$target" />
            </field>
            <field name="concordance_bibliography_cited_range">
              <xsl:value-of select="../tei:citedRange" />
            </field>
            <xsl:apply-templates select="current-group()/../tei:citedRange" />
          </doc>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:citedRange">
    <field name="concordance_bibliography_item">
      <xsl:value-of select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='filename']" />
    </field>
  </xsl:template>

</xsl:stylesheet>
