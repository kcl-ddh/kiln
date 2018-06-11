<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                xmlns:gn="http://www.geonames.org/ontology#"
                xmlns:lawd="http://lawd.info/ontology/"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:so="http://schema.org/"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- XSLT to generate RDF/XML from an authority list.

  This XSLT is generic in the sense that it is designed to handle
  various XML markup for specifying authority lists in a single
  transformation. Currently it supports the TEI markup used in IOSPE's
  authority lists (tei:place and children, tei:person and children,
  tei:org and children, tei:item with tei:term and tei:gloss,
  etc).

  Further markup, TEI or not, can be added since there is little
  overlap in the markup structures for different things. -->

  <xsl:param name="base_uri" />
  <xsl:param name="filename" />

  <!-- Namespace variables for use in rdf:about attributes. Surely
       this is unnecessary and I just don't know what the correct
       XPath/XSLT is. -->
  <xsl:variable name="foaf_ns" select="'http://xmlns.com/foaf/0.1/'" />
  <xsl:variable name="gn_ns" select="'http://www.geonames.org/ontology#'" />
  <xsl:variable name="so_ns" select="'http://schema.org/'" />

  <xsl:template match="tei:TEI">
    <rdf:RDF>
      <xsl:attribute name="xml:base" select="$base_uri" />
      <xsl:call-template name="create-ontology" />
      <xsl:apply-templates />
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="tei:*[@xml:id]/tei:gloss">
    <so:name>
      <xsl:apply-templates select="@*" />
      <xsl:value-of select="." />
    </so:name>
  </xsl:template>

  <xsl:template match="tei:idno">
    <xsl:if test="@type = 'URI'">
      <owl:sameAs rdf:resource="{normalize-space(.)}" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:item[@xml:id]">
    <so:Thing>
      <xsl:call-template name="add-rdf-about-uri" />
      <xsl:apply-templates />
    </so:Thing>
  </xsl:template>
  
  <xsl:template match="tei:org[@xml:id]">
    <so:Organization>
      <xsl:call-template name="add-rdf-about-uri"/>
      <xsl:apply-templates/>
    </so:Organization>
  </xsl:template>
  
  <xsl:template match="tei:*[@xml:id]/tei:orgName">
    <so:name>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="."/>
    </so:name>
  </xsl:template>

  <xsl:template match="tei:person[@xml:id]/tei:persName">
    <foaf:name>
      <xsl:apply-templates select="@*" />
      <xsl:value-of select="normalize-space()" />
    </foaf:name>
  </xsl:template>

  <xsl:template match="tei:person[@xml:id]">
    <lawd:Person>
      <xsl:call-template name="add-rdf-about-uri" />
      <xsl:apply-templates />
    </lawd:Person>
  </xsl:template>

  <xsl:template match="tei:place[@xml:id]">
    <gn:Feature>
      <xsl:call-template name="add-rdf-about-uri" />
      <xsl:apply-templates />
    </gn:Feature>
  </xsl:template>

  <xsl:template match="tei:place[@xml:id]/tei:placeName">
    <gn:alternateName>
      <xsl:apply-templates select="@*" />
      <xsl:value-of select="." />
    </gn:alternateName>
  </xsl:template>

  <xsl:template match="tei:*[@xml:id]/tei:term">
    <so:name>
      <xsl:apply-templates select="@*" />
      <xsl:value-of select="." />
    </so:name>
  </xsl:template>

  <xsl:template match="@xml:lang">
    <xsl:copy-of select="." />
  </xsl:template>

  <xsl:template match="text()" />

  <xsl:template name="add-rdf-about-uri">
    <!-- Adds an rdf:about attribute to the context node with a value
         of the URI formed from the node's xml:id and the stylesheet
         parameter "filename". -->
    <xsl:attribute name="rdf:about" select="concat($filename, '#', @xml:id)" />
  </xsl:template>

  <xsl:template name="create-ontology">
    <owl:Class rdf:about="{$foaf_ns}name">
      <rdfs:subClassOf rdf:resource="{$so_ns}name" />
    </owl:Class>
    <owl:Class rdf:about="{$gn_ns}alternateName">
      <rdfs:subClassOf rdf:resource="{$so_ns}name" />
    </owl:Class>
  </xsl:template>

</xsl:stylesheet>
