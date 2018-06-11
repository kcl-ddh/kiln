<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of symbols in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <!-- Handle the fact that @lemma may have multiple words that need
         to be indexed individually. -->
    <xsl:variable name="root" select="." />
    <!-- There is surely a more concise way to assemble the desired
         sequence. -->
    <xsl:variable name="lemma-values">
      <xsl:for-each select="//tei:w[@lemma][ancestor::tei:div/@type='edition']/@lemma">
        <xsl:value-of select="normalize-space(.)" />
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="lemmata"
                  select="distinct-values(tokenize(normalize-space($lemma-values), '\s+'))" />
    <add>
      <xsl:for-each select="$lemmata">
        <xsl:variable name="lemma" select="." />
        <xsl:variable name="w" select="$root//tei:w[ancestor::tei:div/@type='edition'][contains(concat(' ', @lemma, ' '), $lemma)]" />
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <xsl:value-of select="$lemma" />
            <xsl:value-of select="count($w)" />
          </field>
          <field name="language_code">
            <xsl:value-of select="$w[1]/ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
          </field>
          <xsl:apply-templates select="$w" />
        </doc>
      </xsl:for-each>
    </add>
  </xsl:template>

  <xsl:template match="tei:w">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
