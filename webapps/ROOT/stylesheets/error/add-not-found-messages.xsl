<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:ex="http://apache.org/cocoon/exception/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Add specific error messages for known problems related to not
       found resources. -->

  <xsl:param name="base-uri" />
  <xsl:param name="repository" />
  <xsl:param name="server" />

  <xsl:template match="ex:exception-report/ex:message">
    <xsl:copy>
      <p>The resource you requested was not found.</p>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
