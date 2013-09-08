<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:ex="http://www.example.org/"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- XSLT to generate RDF/XML from TEI. -->

  <xsl:param name="base_uri" />

  <xsl:template match="tei:TEI">
    <rdf:RDF xml:base="{$base_uri}">
      <!-- Define a simple ontology for describing sending a
           letter. Normally this should be a separate resource that is
           harvested once. -->
      <rdfs:Class rdf:ID="Entity" />
      <rdfs:Class rdf:ID="CorrespondenceEvent">
        <rdfs:subClassOf rdf:resource="#Entity" />
      </rdfs:Class>
      <rdfs:Class rdf:ID="Date">
        <rdfs:subClassOf rdf:resource="#Entity" />
      </rdfs:Class>
      <rdfs:Class rdf:ID="Document">
        <rdfs:subClassOf rdf:resource="#Entity" />
      </rdfs:Class>
      <rdfs:Class rdf:ID="Person">
        <rdfs:subClassOf rdf:resource="#Entity" />
      </rdfs:Class>
      <rdfs:Class rdf:ID="Place">
        <rdfs:subClassOf rdf:resource="#Entity" />
      </rdfs:Class>
      <rdfs:Property rdf:ID="has_document">
        <rdfs:domain rdf:resource="#CorrespondenceEvent" />
        <rdfs:range rdf:resource="#Document" />
      </rdfs:Property>
      <rdfs:Property rdf:ID="has_identifier">
        <rdfs:domain rdf:resource="#Entity" />
        <rdfs:range rdf:resource="http://www.w3.org/2000/01/rdf-schema#Literal" />
      </rdfs:Property>
      <rdfs:Property rdf:ID="has_recipient">
        <rdfs:domain rdf:resource="#CorrespondenceEvent" />
        <rdfs:range rdf:resource="#Person" />
      </rdfs:Property>
      <rdfs:Property rdf:ID="has_sender">
        <rdfs:domain rdf:resource="#CorrespondenceEvent" />
        <rdfs:range rdf:resource="#Person" />
      </rdfs:Property>
      <rdfs:Property rdf:ID="occurred_at">
        <rdfs:domain rdf:resource="#CorrespondenceEvent" />
        <rdfs:range rdf:resource="#Place" />
      </rdfs:Property>
      <rdfs:Property rdf:ID="occurred_on">
        <rdfs:domain rdf:resource="#CorrespondenceEvent" />
        <rdfs:range rdf:resource="#Date" />
      </rdfs:Property>
      <CorrespondenceEvent rdf:about="{@xml:id}-event">
        <ex:has_document>
          <Document rdf:about="{@xml:id}">
            <ex:has_identifier>
              <xsl:value-of select="@xml:id" />
            </ex:has_identifier>
          </Document>
        </ex:has_document>
        <xsl:apply-templates />
      </CorrespondenceEvent>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="tei:opener//tei:addrLine/tei:placeName">
    <ex:occurred_at>
      <xsl:variable name="text" select="normalize-space(.)" />
      <Place rdf:about="{translate($text, ' ', '_')}">
        <ex:has_identifier>
          <xsl:value-of select="$text" />
        </ex:has_identifier>
      </Place>
    </ex:occurred_at>
  </xsl:template>

  <xsl:template match="tei:opener//tei:date">
    <ex:occurred_on>
      <Date rdf:about="{@when}">
        <ex:has_identifier>
          <xsl:value-of select="@when" />
        </ex:has_identifier>
      </Date>
    </ex:occurred_on>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:author">
    <ex:has_sender>
      <xsl:variable name="text" select="normalize-space(.)" />
      <Person rdf:about="{translate($text, ' ', '_')}">
        <ex:has_identifier>
          <xsl:value-of select="$text" />
        </ex:has_identifier>
      </Person>
    </ex:has_sender>
  </xsl:template>

  <xsl:template match="tei:teiHeader//tei:person[@role='recipient']">
    <ex:has_recipient>
      <xsl:variable name="text" select="normalize-space(.)" />
      <Person rdf:about="{translate($text, ' ', '_')}">
        <ex:has_identifier>
          <xsl:value-of select="$text" />
        </ex:has_identifier>
      </Person>
    </ex:has_recipient>
  </xsl:template>

  <xsl:template match="node()">
    <xsl:apply-templates />
  </xsl:template>

</xsl:stylesheet>
