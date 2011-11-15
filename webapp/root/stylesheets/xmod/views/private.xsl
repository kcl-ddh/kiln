<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
                xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
                xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0"
                xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Defines the display structure for a page in the private section
     of the site. Calls templates (namespace xms) that are defined in
     local/private/default.xsl. -->

  <xsl:include href="cocoon://_internal/properties/properties.xsl"/>

  <xsl:template name="xmv:screen">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <xsl:call-template name="xmv:header"/>
      <xsl:call-template name="xmv:body"/>
    </html>
  </xsl:template>

  <xsl:template name="xmv:header">
    <head>
      <title>
        <xsl:value-of select="$xmp:title"/>
        <xsl:if test="string($xmg:title)">
          <xsl:text>: </xsl:text>
          <xsl:value-of select="$xmg:title"/>
        </xsl:if>
      </title>
      <xsl:call-template name="xmv:metadata"/>
      <xsl:call-template name="xmv:css"/>
      <xsl:call-template name="xmv:script"/>
    </head>
  </xsl:template>

  <xsl:template name="xmv:metadata"/>

  <xsl:template name="xmv:css">
    <link href="{$xmp:assets-path}/c/default.css" media="screen, projection" rel="stylesheet" type="text/css"/>
    <link href="{$xmp:assets-path}/c/personality.css" media="screen, projection" rel="stylesheet" type="text/css"/>
  </xsl:template>

  <xsl:template name="xmv:script">
    <script src="{$xmp:assets-path}/j/jquery-1.4.2.min.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/config.js" type="text/javascript">&#160;</script>
  </xsl:template>

  <xsl:template name="xmv:body">
    <body>
      <xsl:call-template name="xmv:banner"/>
      <div id="mainContent">
        <xsl:call-template name="xms:content"/>
      </div>
      <xsl:call-template name="xmv:footer"/>
    </body>
  </xsl:template>

  <xsl:template name="xmv:banner"/>

  <xsl:template name="xmv:footer">
    <div>
      <p>
        <xsl:text>Powered by </xsl:text>
        <a href="http://www.cch.kcl.ac.uk/xmod/" title="xMod home page">
          <xsl:text>xMod</xsl:text>
        </a>
      </p>

      <p>
        <xsl:text>&#xa9;&#160;</xsl:text>
        <strong>
          <xsl:value-of select="format-date(current-date(), '[Y]')"/>
        </strong>
        <xsl:text> King's College London, Strand, London WC2R 2LS, England, United Kingdom. Tel +44 (0)20 7836 5454</xsl:text>
      </p>
    </div>
  </xsl:template>
</xsl:stylesheet>
