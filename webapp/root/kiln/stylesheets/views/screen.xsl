<?xml version="1.0" encoding="UTF-8"?>
<!--
  Defines the display structure for a page.
  Calls templates (namespace xms) that are defined in local/default.xsl.
  
  $Id$
-->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
  xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0" xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:xms="http://www.cch.kcl.ac.uk/xmod/spec/1.0" xmlns:xmv="http://www.cch.kcl.ac.uk/xmod/views/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="../menu/menu.xsl" />
  <xsl:include href="cocoon://_internal/properties/properties.xsl" />

  <xsl:template name="xmv:screen">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="id">
        <xsl:choose>
          <xsl:when test="/aggregation/tei:TEI/@xml:id">
            <xsl:value-of select="/aggregation/tei:TEI/@xml:id" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="generate-id()" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:call-template name="xmv:header" />
      <xsl:call-template name="xmv:body" />
    </html>
  </xsl:template>

  <xsl:template name="xmv:header">
    <head>
      <xsl:call-template name="xmv:metadata" />

      <title>
        <xsl:value-of select="$xmp:title" />
        <xsl:if test="string($xmg:title[1])">
          <xsl:text>: </xsl:text>
          <xsl:value-of select="$xmg:title" />
        </xsl:if>
      </title>

      <xsl:call-template name="xmv:css" />
      <xsl:call-template name="xmv:script" />
    </head>
  </xsl:template>

  <xsl:template name="xmv:metadata">
    <meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
    <meta content="{format-date(current-date(), '[Y0001]-[M01]-[D01]')}" name="date" />
    <xsl:if test="$xmp:metadata-author">
      <meta content="{$xmp:metadata-author}" name="author" />
    </xsl:if>
    <xsl:if test="$xmp:metadata-copyright">
      <meta content="{$xmp:metadata-copyright}" name="copyright" />
    </xsl:if>
    <meta content="{$xmp:metadata-description}" name="description" />
    <meta content="{$xmp:metadata-keywords}" name="keywords" />
  </xsl:template>

  <xsl:template name="xmv:css">
    <link href="{$xmp:assets-path}/c/a.css" media="screen, projection" rel="stylesheet" type="text/css" />
    <link href="{$xmp:assets-path}/c/s.css" media="screen, projection" rel="stylesheet" type="text/css" />
  </xsl:template>

  <xsl:template name="xmv:script">
    <script src="{$xmp:assets-path}/s/jquery-1.4.2.min.js" type="text/javascript">&#160;</script>
    <script src="{$xmp:assets-path}/s/c.js" type="text/javascript">&#160;</script>
  </xsl:template>

  <xsl:template name="xmv:body">
    <body class="o0">
      <div id="gw">
        <div id="hs">
          <!-- banner -->
          <xsl:call-template name="xmv:banner" />

          <!-- top navigation: menu-top.xsl -->
          <xsl:if test="$xmg:menu-top = true()">
            <xsl:call-template name="xmm:menu-top" />
          </xsl:if>
        </div>

        <!-- breadcrumb navigation: menu.xsl -->
        <xsl:call-template name="xmm:breadcrumbs" />

        <div id="cs">
          <div class="cg n2">
            <!-- content: local stylesheets -->
            <div class="m">
              <div class="c c1">
                <xsl:call-template name="xms:rhcontent" />

                <xsl:call-template name="xms:options1" />

                <xsl:call-template name="xms:submenu" />

                <xsl:call-template name="xms:pagehead" />

                <xsl:call-template name="xms:toc1" />

                <xsl:call-template name="xms:content" />

                <xsl:call-template name="xms:footnotes" />

                <xsl:call-template name="xms:toc2" />

                <xsl:call-template name="xms:options2" />
              </div>
            </div>

            <!-- left navigation: menu.xsl -->
            <div class="c c2">
              <xsl:text>&#160;</xsl:text>
              <xsl:choose>
                <xsl:when test="$xmg:menu-top = true()">
                  <xsl:call-template name="xmm:menu-top-sub" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="xmm:menu" />
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>
        </div>

        <xsl:call-template name="xmv:footer" />
      </div>
    </body>
  </xsl:template>

  <xsl:template name="xmv:banner">
    <div id="bs">
      <h3 title="{$xmp:title}">
        <a href="/" title="Return to the Homepage">Home</a>
      </h3>
      <h4 title="{$xmp:title}">
        <a href="/" title="Return to the {$xmp:title} Homepage">
          <xsl:value-of select="$xmp:title" />
        </a>
      </h4>
      <div class="gx gx0" title="[Image: ]">[Image: ]</div>
    </div>
  </xsl:template>

  <xsl:template name="xmv:footer">
    <div id="fs">
      <div class="r1">
        <ul class="img">
          <li>
            <a href="http://www.kcl.ac.uk/" title="King's College London">
              <img alt="" height="40" src="{$xmp:assets-path}/i/kcl.png" width="61" />
            </a>
          </li>
        </ul>
      </div>
      <div class="r2">
        <a class="gx" href="/" title="Return to the Homepage">
          <xsl:value-of select="$xmp:title" />
        </a>
        <ul>
          <li class="i1">
            <a href="#cs" title="#">Top of Page</a>
          </li>
          <li>
            <a href="#" title="#">Sitemap</a>
          </li>
          <li>
            <a href="#" title="#">Copyright and License Information</a>
          </li>
          <li class="ix">
            <a href="#" title="#">About this website</a>
          </li>
        </ul>
        <p>&#xa9; 2010 King's College London</p>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
