<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="kiln:test">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="kiln:description" />
      <kiln:result>
        <xsl:variable name="passed" select="deep-equal(kiln:actual/*, kiln:expected/*)" />
        <xsl:attribute name="pass" select="$passed" />
        <xsl:if test="not($passed)">
          <kiln:actual>
            <xsl:apply-templates mode="compare" select="kiln:actual/*">
              <xsl:with-param name="former-other-node" select="kiln:expected" />
            </xsl:apply-templates>
          </kiln:actual>
          <kiln:expected>
            <xsl:apply-templates mode="compare" select="kiln:expected/*">
              <xsl:with-param name="former-other-node" select="kiln:actual" />
            </xsl:apply-templates>
          </kiln:expected>
        </xsl:if>
      </kiln:result>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*" mode="compare">
    <xsl:param name="former-other-node" />
    <xsl:variable name="current-other-node" select="$former-other-node/@*[node-name(.)=node-name(current())]" />
    <xsl:if test="deep-equal(., $current-other-node)">
      <xsl:sequence select="node-name(.)" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="compare">
    <xsl:param name="former-other-node" />
    <xsl:variable name="current-node-name" select="node-name(.)" />
    <xsl:variable name="current-position" select="count(preceding-sibling::*[node-name(.)=$current-node-name])+1" />
    <xsl:variable name="current-other-node" select="$former-other-node/*[node-name(.)=node-name(current())][position()=$current-position]" />
    <xsl:choose>
      <xsl:when test="deep-equal(., $current-other-node)">
        <kiln:same />
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*" />
          <xsl:variable name="identical-attributes" as="xs:QName*">
            <xsl:apply-templates mode="compare" select="@*">
              <xsl:with-param name="former-other-node" select="$current-other-node" />
            </xsl:apply-templates>
          </xsl:variable>
          <xsl:if test="not(empty($identical-attributes))">
            <xsl:attribute name="kiln:same-attributes">
              <xsl:text> </xsl:text>
              <xsl:for-each select="$identical-attributes">
                <xsl:value-of select="." />
                <xsl:text> </xsl:text>
              </xsl:for-each>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$current-other-node">
            <xsl:attribute name="kiln:same-element" select="true()" />
          </xsl:if>
          <xsl:apply-templates mode="compare" select="node()">
            <xsl:with-param name="former-other-node" select="$current-other-node" />
          </xsl:apply-templates>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text()" mode="compare">
    <xsl:param name="former-other-node" />
    <xsl:variable name="current-node-name" select="node-name(.)" />
    <xsl:variable name="current-position" select="count(preceding-sibling::*[node-name(.)=$current-node-name])+1" />
    <xsl:variable name="current-other-node" select="$former-other-node/*[node-name(.)=node-name(current())][position()=$current-position]" />
    <xsl:if test="not(deep-equal(., $current-other-node))">
      <kiln:text>
        <xsl:value-of select="." />
      </kiln:text>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
