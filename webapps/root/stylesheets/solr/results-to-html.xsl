<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <html>
      <head>
        <title>Result of indexing all XML documents</title>
      </head>
      <body>
        <h1>Result of indexing all XML documents</h1>

        <xsl:apply-templates />
      </body>
    </html>
  </xsl:template>

  <xsl:template match="delete">
    <h2>Deleting all documents</h2>

    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="file">
    <h3><xsl:apply-templates /></h3>

    <xsl:if test="not(local-name(following-sibling::*[1])='report')">
      <p>Failed!</p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="insert">
    <h2>Indexing all XML documents</h2>

    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="optimise">
    <h2>Optimising</h2>

    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="responseHeader">
    <xsl:choose>
      <xsl:when test="contains(., 'status=0')">
        <p>Succeeded!</p>
      </xsl:when>
      <xsl:otherwise>
        <p>Failed!</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
