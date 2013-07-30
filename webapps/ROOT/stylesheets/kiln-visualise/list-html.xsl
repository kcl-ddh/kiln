<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:map="http://apache.org/cocoon/sitemap/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="aggregation/map:sitemap" mode="kiln-visualise">
    <xsl:apply-templates mode="kiln-visualise" select=".//map:match[@id]">
      <xsl:sort select="@id" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="map:match[@id]" mode="kiln-visualise">
    <li>
      <a href="match/{@id}.html">
        <xsl:value-of select="@id" />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="dir:directory" mode="kiln-visualise">
    <xsl:param name="path" select="'/'" />
    <xsl:apply-templates mode="kiln-visualise">
      <xsl:with-param name="path" select="concat($path, @name, '/')" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="dir:file[ends-with(@name, '.xml')]"
                mode="kiln-visualise">
    <xsl:param name="path" select="'/'" />
    <xsl:variable name="base-url">
      <xsl:text>template</xsl:text>
      <xsl:value-of select="$path" />
      <xsl:value-of select="substring-before(@name, '.xml')" />
    </xsl:variable>
    <li>
      <xsl:value-of select="$path" />
      <xsl:value-of select="@name" />
      <xsl:text>: </xsl:text>
      <a href="{$base-url}.xsl">full XSLT</a>
      <xsl:text> | </xsl:text>
      <a href="{$base-url}.html">empty document</a>
    </li>
  </xsl:template>

</xsl:stylesheet>
