<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:map="http://apache.org/cocoon/sitemap/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="cocoon://_internal/url/reverse.xsl" />

  <xsl:template match="aggregation/map:sitemap" mode="introspection">
    <xsl:apply-templates mode="introspection" select=".//map:match[@id]">
      <xsl:sort select="@id" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="map:match[@id]" mode="introspection">
    <li>
      <a href="{kiln:url-for-match('local-admin-introspection-match', (@id), 0)}">
        <xsl:value-of select="@id" />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="dir:directory" mode="introspection">
    <xsl:param name="path" select="''" />
    <xsl:apply-templates mode="introspection">
      <xsl:with-param name="path" select="concat($path, @name, '/')" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="dir:file[ends-with(@name, '.xml')]"
                mode="introspection">
    <xsl:param name="path" select="''" />
    <xsl:variable name="base-name">
      <xsl:value-of select="$path" />
      <xsl:value-of select="substring-before(@name, '.xml')" />
    </xsl:variable>
    <li>
      <xsl:value-of select="$path" />
      <xsl:value-of select="@name" />
      <xsl:text>: </xsl:text>
      <a href="{kiln:url-for-match('local-admin-introspection-template-xslt',
               ($base-name), 0)}">
        <xsl:text>full XSLT</xsl:text>
      </a>
      <xsl:text> | </xsl:text>
      <a href="{kiln:url-for-match('local-admin-introspection-template-empty',
               ($base-name), 0)}">
        <xsl:text>empty document</xsl:text>
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>
