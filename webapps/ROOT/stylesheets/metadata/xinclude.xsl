<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="cocoon://_internal/url/reverse.xsl" />

  <xsl:param name="base_dir" />
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
    <xsl:variable name="name" select="substring-before(@name, '.xml')" />
    <xi:include href="{kiln:url-for-match('local-typed-metadata',
                      ($type, $base_dir, concat($root, $name)), 1)}" />
  </xsl:template>
</xsl:stylesheet>
