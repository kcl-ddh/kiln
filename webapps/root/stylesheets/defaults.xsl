<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
      Defaults stylesheet. Defines default globals and reads parameters from the sitemap.
  -->

  <xsl:param name="filedir" />
  <xsl:param name="filename" />
  <xsl:param name="fileextension" />

  <xsl:variable name="xmg:pathroot" select="concat($xmp:context-path, '/', $filedir)" />
  <xsl:variable name="xmg:path"
    select="concat($xmg:pathroot, '/', substring-before($filename, '.'), '.', $fileextension)" />

  <!-- Base URL for assets (non-content images, CSS, JavaScript,
       etc). If these are being served by Cocoon, this should be
       specified as relative to $context-path. Otherwise, a full URL
       including protocol and domain is required.
       
       This URL must not include a trailing slash. -->
  <xsl:variable name="xmg:assets-url" select="'/assets'" />
  <xsl:variable name="xmg:assets-path">
    <xsl:if test="not(starts-with($xmg:assets-url, 'http'))">
      <xsl:value-of select="$xmp:context-path" />
    </xsl:if>
    <xsl:value-of select="$xmg:assets-url" />
  </xsl:variable>
  <!-- Base URL for non-textual content (images, video, etc). If these
       are being served by Cocoon, this should be specified as
       relative to $context-path. Otherwise, a full URL including
       protocol and domain is required.
       
       This URL must not include a trailing slash. -->
  <xsl:variable name="xmg:content-url" select="''" />
  <xsl:variable name="xmg:content-path">
    <xsl:if test="not(starts-with($xmg:content-url, 'http'))">
      <xsl:value-of select="$xmp:context-path" />
    </xsl:if>
    <xsl:value-of select="$xmg:content-url" />
  </xsl:variable>
</xsl:stylesheet>
