<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- For the main menu, display only the top level items. -->
  <xsl:template match="/aggregation/div[@type='menu']" mode="main-menu">
    <xsl:apply-templates mode="main-menu" />
  </xsl:template>

  <xsl:template match="li/ul" mode="main-menu" />

  <!-- For the local menu, display only the siblings of the active
       item. -->
  <xsl:template match="/aggregation/div[@type='menu']"
                mode="local-menu">
    <ul>
      <xsl:apply-templates
          select=".//ul[li/@class='active-menu-item']/li"
          mode="local-menu" />
    </ul>
  </xsl:template>

  <xsl:template match="li/ul" mode="local-menu" />

  <xsl:template match="@*|node()" mode="main-menu">
    <xsl:copy>
      <xsl:apply-templates mode="main-menu" select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*|node()" mode="local-menu">
    <xsl:copy>
      <xsl:apply-templates mode="local-menu" select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
