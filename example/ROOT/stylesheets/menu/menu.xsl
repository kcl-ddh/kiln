<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/aggregation/div[@type='menu']" mode="menu">
    <xsl:apply-templates mode="menu" />
  </xsl:template>

  <xsl:template match="ul" mode="menu">
    <ul class="nav">
      <xsl:apply-templates mode="menu" />
    </ul>
  </xsl:template>

  <xsl:template match="li/ul" mode="menu" />

  <xsl:template match="@class" mode="menu">
    <xsl:if test=". = 'active-menu-item'">
      <xsl:attribute name="class">
        <xsl:text>active</xsl:text>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*|node()" mode="menu">
    <xsl:copy>
      <xsl:apply-templates mode="menu" select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
