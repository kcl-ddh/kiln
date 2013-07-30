<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Page breaks within a table but not within a cell are associated
       with their first preceding cell. This does not check that a pb
       has a preceding cell within the same table; a Schematron rule
       should enforce that it does. -->
  <xsl:key match="tei:pb[parent::tei:table]"
           name="pbs-by-preceding-cell"
           use="generate-id(preceding::tei:cell[1])"/>

  <!-- Page breaks within a list but not within an item are associated
       with their first preceding item. This does not check that a pb
       has a preceding item within the same list; a Schematron rule
       should enforce that it does. -->
  <xsl:key match="tei:pb[parent::tei:list]"
           name="pbs-by-preceding-item"
           use="generate-id(preceding::tei:item[1])"/>

  <!-- Annotate a tei:p regarding whether it contains only inline
       material or not. -->
  <xsl:template match="tei:p">
    <xsl:variable name="is-block">
      <xsl:call-template name="has-block-descendants"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="annotate-element">
        <xsl:with-param name="is-block" select="$is-block"/>
      </xsl:call-template>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:q | tei:quote">
    <xsl:variable name="is-block">
      <xsl:call-template name="has-block-descendants"/>
      <xsl:if test="not(ancestor::tei:cell or ancestor::tei:p or ancestor::tei:item)">
        <xsl:text>true</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="annotate-element">
        <xsl:with-param name="is-block" select="$is-block"/>
      </xsl:call-template>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:note[not(@n)][not(@target)]">
    <xsl:variable name="is-block">
      <xsl:call-template name="has-block-descendants"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="annotate-element">
        <xsl:with-param name="is-block" select="$is-block"/>
      </xsl:call-template>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:figure">
    <xsl:variable name="is-block">
      <xsl:choose>
        <xsl:when test="ancestor::tei:teiHeader"/>
        <xsl:when test="*[not(self::tei:figDesc) and not(self::tei:graphic)]">
          <xsl:text>true</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="annotate-element">
        <xsl:with-param name="is-block" select="$is-block"/>
      </xsl:call-template>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:lg">
    <xsl:variable name="is-block">
      <xsl:if test="tei:lg">
        <xsl:text>true</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="annotate-element">
        <xsl:with-param name="is-block" select="$is-block"/>
      </xsl:call-template>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Mark nested links. -->
  <xsl:template match="tei:ref|tei:name[@key]|tei:rs[@key]|tei:pb">
    <xsl:variable name="is-nested-link">
      <xsl:if test="ancestor::tei:ref | ancestor::tei:name[@key] | ancestor::tei:rs[@key]">
        <xsl:text>true</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="annotate-element">
        <xsl:with-param name="is-nested-link" select="$is-nested-link"/>
      </xsl:call-template>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- Return true if an element has block-level descendants. -->
  <xsl:template name="has-block-descendants">
    <xsl:if test=".//tei:p | .//tei:figure[*[not(self::tei:figDesc) and not(self::tei:graphic)]] | .//tei:list | .//tei:table | .//tei:lg | .//tei:note[not(@n)][not(@target)] |.//tei:floatingText">
      <xsl:text>true</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="annotate-element">
    <xsl:param name="is-block"/>
    <xsl:param name="is-nested-link"/>
    <xsl:variable name="classes">
      <xsl:if test="normalize-space($is-block)">
        <xsl:text>block </xsl:text>
      </xsl:if>
      <xsl:if test="normalize-space($is-nested-link)">
        <xsl:text>nested-link </xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:if test="normalize-space($classes)">
      <xsl:attribute name="kiln:class">
        <xsl:value-of select="normalize-space($classes)"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <!-- Move tei:pb that occurs with a table but outside of a cell into
       the first preceding cell. -->
  <xsl:template match="tei:cell">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:variable name="associated-pbs" select="key('pbs-by-preceding-cell', generate-id(.))"/>
      <xsl:for-each select="$associated-pbs">
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="tei:pb[parent::tei:table]"/>

  <!-- Move tei:pb that occurs within a list but outside of an item
       into the first preceding item. -->
  <xsl:template match="tei:item">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:variable name="associated-pbs" select="key('pbs-by-preceding-item', generate-id(.))"/>
      <xsl:for-each select="$associated-pbs">
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="tei:pb[parent::tei:list]"/>

  <!-- Identity transform. -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
