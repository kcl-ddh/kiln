<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- XSLT to generate RDF expressing relationships between a
       physical document, the record written in that document, and the
       entities referenced in the records.

       This is a highly abbreviated transformation, for example
       purposes. -->

  <xsl:variable name="base-url" select="'http://www.example.org/'" />
  <xsl:variable name="crm" select="'http://www.cidoc-crm.org/cidoc-crm/'" />
  <xsl:variable name="ereed"
                select="'http://reed.utoronto.ca/django/eats/entity/'" />

  <xsl:template match="tei:TEI">
    <rdf:RDF xml:base="{$base-url}">
      <crm:E31_Document rdf:about="{@xml:id}">
        <crm:P48_has_preferred_identifier rdf:datatype="{$crm}E42_Identifier">
          <xsl:value-of select="@xml:id" />
        </crm:P48_has_preferred_identifier>
      </crm:E31_Document>
      <xsl:apply-templates select=".//tei:text[@type='record']" />
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="tei:text[@type='record']">
    <!-- The text element represents two resources: the record
         (abstract) and the document that carries that record
         (physical). -->
    <crm:E84_Information_Carrier rdf:about="{@xml:id}/#physical">
      <crm:P128_carries>
        <crm:E31_Document rdf:about="{@xml:id}/">
          <crm:P148i_is_component_of rdf:resource="{ancestor::tei:TEI/@xml:id}" />
          <crm:P149_is_identified_by rdf:datatype="{$crm}E41_Appellation">
            <xsl:apply-templates mode="appellation"
                                 select="tei:body/tei:head[@type='main']" />
          </crm:P149_is_identified_by>
          <crm:P48_has_preferred_identifier rdf:datatype="{$crm}E42_Identifier">
            <xsl:value-of select="@xml:id" />
          </crm:P48_has_preferred_identifier>
          <xsl:apply-templates mode="entity-references" />
        </crm:E31_Document>
      </crm:P128_carries>
    </crm:E84_Information_Carrier>
  </xsl:template>

  <xsl:template match="tei:head" mode="appellation">
    <xsl:value-of select="tei:placeName" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="tei:date" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="normalize-space(tei:title)" />
  </xsl:template>

  <xsl:template match="tei:*[@key]" mode="entity-references">
    <!-- Information about this entity is harvested from other
         sources, if at all. For the purposes of this example, grab
         the text that is used to refer to the entity (though this
         might not strictly be an Appellation. -->
    <crm:P67_refers_to>
      <rdf:Description rdf:about="{@key}">
        <crm:P1_is_identified_by rdf:datatype="{$crm}E41_Appellation">
          <xsl:value-of select="normalize-space(.)" />
        </crm:P1_is_identified_by>
        <crm:P48_has_preferred_identifier rdf:datatype="{$crm}E42_Identifier">
          <xsl:value-of select="substring-before(
            substring-after(@key, $ereed), '/')" />
        </crm:P48_has_preferred_identifier>
      </rdf:Description>
    </crm:P67_refers_to>
  </xsl:template>

  <xsl:template match="text()" mode="#all" />

</xsl:stylesheet>
