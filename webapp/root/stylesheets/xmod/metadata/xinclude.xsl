<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:dir="http://apache.org/cocoon/directory/2.0"
  xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" />

  <xsl:param name="type" />

  <xsl:template match="/">
    <xsl:element name="{$type}">
      <!-- Skip the containing directory as it is built into the
           Cocoon pipelines etc, and we know exactly what it is. -->
      <xsl:apply-templates select="dir:directory/dir:*"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dir:directory">
    <xsl:param name="root" select="''" />

    <xsl:apply-templates>
      <xsl:with-param name="root" select="concat($root, @name, '/')" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="dir:file[matches(@name, '.xml$')]">
    <xsl:param name="root" select="''" />

    <xi:include href="cocoon://_internal/metadata/{$type}/{$root}{@name}" />
  </xsl:template>
</xsl:stylesheet>
