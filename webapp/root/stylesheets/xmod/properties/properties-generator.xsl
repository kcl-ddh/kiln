<?xml version="1.0" encoding="UTF-8"?>
<!-- Creates XSLT variables from/for the properties defined in the properties.xml file. -->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" />

  <xsl:variable name="default-assets-path" select="'/_a'"/>
  <xsl:variable name="default-images-path" select="'/images'"/>

  <xsl:template match="//xmp:properties">
    <xsl:element name="xsl:stylesheet" namespace="http://www.w3.org/1999/XSL/Transform">
      <xsl:attribute name="exclude-result-prefixes">#all</xsl:attribute>
      <xsl:attribute name="version">2.0</xsl:attribute>
      <xsl:namespace name="xmp">http://www.cch.kcl.ac.uk/xmod/properties/1.0</xsl:namespace>
      <xsl:namespace name="xs">http://www.w3.org/2001/XMLSchema</xsl:namespace>

      <xsl:apply-templates select="xmp:property"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xmp:property">
    <xsl:call-template name="create-variable">
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="value" select="@value"/>
    </xsl:call-template>
  </xsl:template>

  <!-- If the assets-path property is not a fully-specified URL
       (starting with "http"), use the default assets path relative to
       the context path. -->
  <xsl:template match="xmp:property[@name='assets-path']">
    <xsl:call-template name="create-variable">
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="starts-with(@value, 'http')">
            <xsl:value-of select="@value"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="../xmp:property[@name='context-path']/@value"/>
            <xsl:value-of select="$default-assets-path"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- If the images-path property is not a fully-specified URL
       (starting with "http"), use the default images path relative to
       the context path. -->
  <xsl:template match="xmp:property[@name='images-path']">
    <xsl:call-template name="create-variable">
      <xsl:with-param name="name" select="@name"/>
      <xsl:with-param name="value">
        <xsl:choose>
          <xsl:when test="starts-with(@value, 'http')">
            <xsl:value-of select="@value"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="../xmp:property[@name='context-path']/@value"/>
            <xsl:value-of select="$default-images-path"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="create-variable">
    <xsl:param name="name"/>
    <xsl:param name="value"/>
    <xsl:element name="xsl:variable">
      <xsl:attribute name="name">
        <xsl:text>xmp:</xsl:text>
        <xsl:value-of select="$name"/>
      </xsl:attribute>
      <xsl:value-of select="$value"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
