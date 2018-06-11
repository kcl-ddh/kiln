<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transforms a context-free menu into one annotated based on the
       supplied context (ie, place in the menu structure). -->

  <xsl:import href="../../../stylesheets/defaults.xsl" />

  <xsl:param name="url" select="''" />

  <xsl:variable name="kiln:nav-url"
                select="concat($kiln:context-path, '/', $url)" />

  <xsl:template match="kiln:root">
    <kiln:nav>
      <ul type="menu">
        <xsl:apply-templates select="kiln:menu" mode="menu" />
      </ul>
      <ul type="breadcrumbs">
        <xsl:choose>
          <xsl:when test=".//*[@href=$kiln:nav-url]">
            <xsl:apply-templates mode="breadcrumbs"
                                 select=".//kiln:menu[descendant::*[@href=$kiln:nav-url]]" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="breadcrumbs"
                                 select=".//kiln:menu[starts-with($kiln:nav-url, @path)]" />
          </xsl:otherwise>
        </xsl:choose>
      </ul>
    </kiln:nav>
  </xsl:template>

  <xsl:template match="kiln:menu | kiln:item" mode="menu">
    <li>
      <!-- Active item. -->
      <xsl:if test="@href = $kiln:nav-url">
        <xsl:attribute name="class" select="'active'" />
      </xsl:if>
      <a>
        <xsl:if test="@href">
          <xsl:attribute name="href" select="@href" />
        </xsl:if>
        <xsl:apply-templates select="@label" />
      </a>
      <!-- Sub-items. -->
      <xsl:if test="child::*">
        <ul>
          <xsl:apply-templates mode="menu" />
        </ul>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="kiln:item[@delete='delete'] |
                       kiln:menu[@delete='delete']" mode="#all" />

  <xsl:template match="kiln:menu" mode="breadcrumbs">
    <li>
      <a href="{@href}">
        <xsl:apply-templates select="@label" />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="kiln:menu[not(@root)][not(@delete)]" mode="breadcrumbs" />

  <xsl:template match="@label">
    <i18n:text>
      <xsl:copy-of select="../@i18n:key" />
      <xsl:value-of select="." />
    </i18n:text>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
