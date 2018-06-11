<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- XSLT to generate a list of XInclude elements for each file in a
       directory listing.

       Includes a file element wrapping each xi:include element
       specifying the file path of the file being processed. -->

  <!-- Prefix to be added to XInclude URLs. -->
  <xsl:param name="prefix" />

  <xsl:template match="dir:directory">
    <xincludes root="{@name}">
      <!-- Exclude the content directory from the path. -->
      <xsl:apply-templates select="*" />
    </xincludes>
  </xsl:template>

  <xsl:template match="dir:directory/dir:directory" priority="100">
    <xsl:param name="path" select="''" />
    <xsl:variable name="new_path" select="concat($path, @name, '/')" />
    <xsl:apply-templates select="dir:file">
      <xsl:with-param name="path" select="$new_path" />
    </xsl:apply-templates>
    <xsl:apply-templates select="dir:directory">
      <xsl:with-param name="path" select="$new_path" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="dir:file">
    <xsl:param name="path" />

    <xsl:variable name="filepath">
      <xsl:value-of select="$path" />
      <xsl:value-of select="@name" />
    </xsl:variable>

    <file path="{$filepath}">
      <xi:include href="{$prefix}{$filepath}" />
    </file>
  </xsl:template>

</xsl:stylesheet>
