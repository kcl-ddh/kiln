<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:zip="http://apache.org/cocoon/zip-archive/1.0">

  <!-- Converts a directory listing document into a ZIP archive
       document suitable for serialization via the zip serializer.

       The path-prefix parameter is the prefix to be appended to each
       zip:entry/@src attribute and should either be an absolute URI
       or a relative path from the calling sitemap to the parent (not
       the directory itself) of the listed directory in the input
       document. -->

  <xsl:param name="path-prefix" />

  <xsl:template match="/">
    <zip:archive>
      <xsl:apply-templates>
        <xsl:with-param name="root" select="''" />
      </xsl:apply-templates>
    </zip:archive>
  </xsl:template>

  <xsl:template match="dir:directory">
    <xsl:param name="root" />
    <xsl:variable name="new-root">
      <xsl:if test="$root != ''">
        <xsl:value-of select="$root" />
        <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:value-of select="@name" />
    </xsl:variable>
    <xsl:apply-templates>
      <xsl:with-param name="root" select="$new-root" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:param name="root" />
    <xsl:variable name="path" select="concat($root, '/', @name)" />
    <zip:entry name="{$path}" src="{concat($path-prefix, $path)}" />
  </xsl:template>

</xsl:stylesheet>
