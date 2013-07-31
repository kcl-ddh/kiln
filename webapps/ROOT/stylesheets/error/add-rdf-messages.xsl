<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:ex="http://apache.org/cocoon/exception/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Add specific error messages for known problems occurring during
       RDF processing. -->

  <xsl:param name="base-uri" />
  <xsl:param name="repository" />
  <xsl:param name="server" />

  <xsl:template match="ex:exception-report/ex:message">
    <xsl:copy>
      <xsl:choose>
        <xsl:when test="not($base-uri)">
          <p>Unconfigured RDF server: a base URI must be
          specified. See the Kiln documentation for details.</p>
        </xsl:when>
        <xsl:when test="not(starts-with($base-uri, 'http'))">
          <p>Unconfigured RDF server: the base URI must be a
          fully-specified URI.</p>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
