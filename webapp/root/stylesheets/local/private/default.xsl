<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Default stylesheet for the private section of the site. Defines
       the templates that are called from the views stylesheets.  It
       should be imported by other project specific stylesheets, where
       the variables/templates should be overriden as needed. -->

  <xsl:import href="../../xmod/views/private.xsl"/>
  
  <xsl:param name="filedir"/>
  <xsl:param name="filename"/>
  <xsl:param name="fileextension"/>
  <xsl:param name="menutop" select="'false'"/>

  <xsl:variable name="xmg:title" select="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]"/>
  <xsl:variable name="xmg:pathroot" select="$filedir"/>
  <xsl:variable name="xmg:path" select="concat($filedir, '/', substring-before($filename, '.'), '.', $fileextension)"/>
  <xsl:variable name="xmg:menu-top">
    <xsl:choose>
      <xsl:when test="$menutop = 'false'">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="true()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:call-template name="xmv:screen"/>
  </xsl:template>
  
  <xsl:template name="xms:content">
    <xsl:apply-templates select="/*"/>
  </xsl:template>

  <xsl:template name="xms:submenu"/>

  <xsl:template name="xms:pagehead">
    <div class="pageHeader">
      <div class="t01">
        <xsl:if test="string($xmg:title)">
          <h1>
            <xsl:value-of select="$xmg:title"/>
          </h1>
        </xsl:if>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="xms:rhcontent"/>

  <xsl:template name="xms:toc"/>

  <xsl:template name="xms:footnotes"/>

  <xsl:template name="xms:options1"/>

  <xsl:template name="xms:options2"/>

  <xsl:template name="xms:option"/>

</xsl:stylesheet>
