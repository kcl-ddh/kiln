<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- XSLT to generate RDF/XML from TEI. -->

  <xsl:param name="base_uri" />

  <xsl:template match="tei:TEI">
    <rdf:RDF>
      <xsl:attribute name="xml:base" select="$base_uri" />
    </rdf:RDF>
  </xsl:template>

</xsl:stylesheet>
