<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Convert test case information into XInclude statements to
       include both the expected and actual data for each test. -->

  <xsl:param name="test-case-path" />

  <xsl:import href="cocoon://_internal/url/reverse.xsl" />

  <xsl:template match="kiln:actual">
    <xsl:copy>
      <xsl:variable name="parameters" as="xs:string*">
        <xsl:sequence select="kiln:parameters/kiln:parameter/text()" />
      </xsl:variable>
      <xi:include href="{kiln:url-for-match(kiln:match_id, $parameters, 1)}" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="kiln:expected">
    <xsl:copy>
      <xi:include href="{kiln:url-for-match('local-admin-test-expected-data', (text()), 1)}" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="kiln:tests">
    <xsl:copy>
      <xsl:attribute name="path" select="$test-case-path" />
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
