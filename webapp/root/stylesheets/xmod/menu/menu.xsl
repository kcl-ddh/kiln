<?xml version="1.0" encoding="UTF-8"?>
<!-- Displays the navigation menu. -->
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
                xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="xmm:menu">
    <xsl:apply-templates select="/*/xmm:root" />
  </xsl:template>

  <xsl:template match="xmm:root">
    <div id="pn">
      <h3>
        <span>
          <xsl:value-of select="@label" />
        </span>
      </h3>

      <ul class="pn1">
        <xsl:apply-templates />
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="xmm:menu">
    <xsl:call-template name="xmm:menu-item" />
  </xsl:template>

  <xsl:template name="xmm:menu-item">
    <xsl:param name="output-sub-items" select="true()" />

    <li>
      <xsl:choose>
        <!-- Active item with children. -->
        <xsl:when test="child::* and @href = $xmg:path">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'i1'" />
            <xsl:with-param name="last" select="'ix'" />
            <xsl:with-param name="active" select="true()" />
          </xsl:call-template>
        </xsl:when>
        <!-- Active item. -->
        <xsl:when test="@href = $xmg:path">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'i1'" />
            <xsl:with-param name="last" select="'ix'" />
            <xsl:with-param name="active" select="true()" />
          </xsl:call-template>
        </xsl:when>
        <!-- Ancestor of active item. -->
        <xsl:when test="child::* and starts-with($xmg:path, @path)">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'i1'" />
            <xsl:with-param name="last" select="'ix'" />
          </xsl:call-template>
        </xsl:when>
        <!-- Inactive item with children. -->
        <xsl:when test="child::*">
          <xsl:call-template name="xmm:menu-item-class">
            <xsl:with-param name="first" select="'i1'" />
            <xsl:with-param name="last" select="'ix'" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="xmm:menu-item-class" />
        </xsl:otherwise>
      </xsl:choose>

      <a>
        <xsl:if test="@href">
          <xsl:attribute name="href">
            <xsl:value-of select="@href" />
          </xsl:attribute>
        </xsl:if>
        <b>
          <xsl:value-of select="@label" />
        </b>
      </a>

      <xsl:if test="$output-sub-items = true()">
        <xsl:if test="child::* and starts-with($xmg:path, @path)">
          <ul class="pn{count(ancestor::xmm:menu) + 2}">
            <xsl:apply-templates />
          </ul>
        </xsl:if>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template name="xmm:menu-item-class">
    <xsl:param name="first" select="'i1'" />
    <xsl:param name="last" select="'ix'" />
    <xsl:param name="active" select="false()" />

    <xsl:variable name="cur-item" select="local-name()" />

    <xsl:choose>
      <xsl:when test="not(preceding-sibling::*[name() = $cur-item])">
        <xsl:attribute name="class">
          <xsl:value-of select="$first" />

          <xsl:if test="$active = true()"> s1</xsl:if>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="not(following-sibling::*[name() = $cur-item])">
        <xsl:attribute name="class">
          <xsl:value-of select="$last" />
          <xsl:if test="$active = true()"> s1</xsl:if>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$active = true()">
        <xsl:attribute name="class">s1</xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="xmm:item">
    <xsl:call-template name="xmm:menu-item" />
  </xsl:template>

  <xsl:template match="xmm:external">
    <li>
      <a class="ext" href="{@href}">
        <xsl:value-of select="@label" />
      </a>
    </li>
  </xsl:template>

  <xsl:template name="xmm:breadcrumbs">
    <div class="nvs" id="ss">
      <h3>Location:</h3>

      <!-- Find the lowest node in the menu that matches
             $xmg:path. This path may not be fully represented in the
             menu, so starts-with is used and possible multiple
             matches (an xmm:menu with no @href and its first child)
             are handled in the templates. -->
      <ul>
        <xsl:apply-templates mode="breadcrumbs"
          select="/*/xmm:root//*[starts-with($xmg:path, @path)][not(descendant::*[starts-with($xmg:path, @path)])]" />
        <li class="ix s1" title="{$xmg:title} (the current page)">
          <xsl:value-of select="$xmg:title" />
        </li>
      </ul>
    </div>
  </xsl:template>

  <!-- Traverse up the menu hierarchy from the node(s) that best match
       the current path. -->
  <!-- Ignore any top-level menu that is a root, since this will
       always match and is never wanted. -->
  <xsl:template match="xmm:root/xmm:menu[@root]" mode="breadcrumbs" />

  <!-- Do not provide a link for the menu element that exactly
       represents the current path, unless there is a subitem with the
       same path. -->
  <xsl:template match="xmm:*[@href=$xmg:path]" mode="breadcrumbs">
    <xsl:apply-templates select="parent::xmm:menu" mode="breadcrumbs"/>
    <xsl:if test="xmm:*[@href=$xmg:path]">
      <xsl:call-template name="xmm:breadcrumbs-links"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xmm:menu" mode="breadcrumbs">
    <xsl:apply-templates mode="breadcrumbs" select="parent::xmm:menu" />
    <xsl:call-template name="xmm:breadcrumbs-links" />
  </xsl:template>

  <xsl:template match="*" mode="breadcrumbs" />

  <xsl:template name="xmm:breadcrumbs-links">
    <li>
      <a href="{@href}" title="Back to: {@label}">
        <xsl:value-of select="@label" />
      </a>
    </li>
  </xsl:template>

  <xsl:template name="xmm:menu-top">
    <div id="ns">
      <ul class="nvg">
        <xsl:for-each select="/*/xmm:root/xmm:menu">
          <xsl:call-template name="xmm:menu-item">
            <xsl:with-param name="output-sub-items" select="false()" />
          </xsl:call-template>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

  <xsl:template name="xmm:menu-top-sub">
    <xsl:for-each select="/*/xmm:root/xmm:menu">
      <xsl:choose>
        <xsl:when test="@root = $xmg:pathroot">
          <xsl:call-template name="xmm:format-top-sub" />
        </xsl:when>
        <xsl:when test="@root and starts-with($xmg:pathroot, @path) = true()">
          <xsl:call-template name="xmm:format-top-sub" />
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="xmm:format-top-sub">
    <h3>
      <xsl:value-of select="@label" />
    </h3>
    <ul class="nvl">
      <xsl:apply-templates />
    </ul>
  </xsl:template>
</xsl:stylesheet>
