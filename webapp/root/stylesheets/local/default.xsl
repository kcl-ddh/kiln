<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
      Default stylesheet. Defines the templates that are called from
      the views stylesheets.
      
      It should be imported by other project specific stylesheets,
      where the variables/templates should be overriden as
      needed. Project-wide changes should be made here.
  -->

  <xsl:import href="../xmod/views/screen.xsl" />
  <xsl:import href="../xmod/tei/p5.xsl" />
  
  <xsl:param name="filedir" />
  <xsl:param name="filename" />
  <xsl:param name="fileextension" />
  <xsl:param name="menutop" select="'false'" />

  <xsl:variable name="xmg:title" select="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]" />
  <xsl:variable name="xmg:pathroot" select="concat($xmp:context-path, '/', $filedir)" />
  <xsl:variable name="xmg:path" select="concat($xmg:pathroot, '/', substring-before($filename, '.'), '.', $fileextension)" />
  <xsl:variable name="xmg:menu-top">
    <xsl:choose>
      <xsl:when test="$menutop = 'false'">
        <xsl:value-of select="false()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="true()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:call-template name="xmv:screen" />
  </xsl:template>
  
  <xsl:template name="xms:content">
    <xsl:apply-templates select="//tei:TEI" />
  </xsl:template>

</xsl:stylesheet>
