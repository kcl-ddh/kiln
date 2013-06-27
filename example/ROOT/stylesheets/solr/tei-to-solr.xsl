<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../kiln/stylesheets/solr/tei-to-solr.xsl" />

  <!-- Path to the TEI file being indexed. -->
  <xsl:param name="file-path" />

  <xsl:template match="/">
    <add>
      <xsl:apply-templates />
    </add>
  </xsl:template>

  <xsl:template match="tei:TEI">
    <xsl:variable name="document-metadata">
      <xsl:apply-templates mode="document-metadata" select="tei:teiHeader" />
    </xsl:variable>

    <xsl:apply-templates select="tei:text/tei:group/tei:text[@xml:id]">
      <xsl:with-param name="document-metadata" select="$document-metadata"
                      tunnel="yes" />
      <xsl:with-param name="file-path" select="$file-path" tunnel="yes" />
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt" mode="document-metadata">
    <field name="document_title">
      <xsl:for-each select="tei:title">
        <xsl:value-of select="." />
        <xsl:if test="position != last()">
          <xsl:text>: </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </field>
    <xsl:apply-templates select="tei:author" />
    <xsl:apply-templates select="tei:editor" />
  </xsl:template>

  <xsl:template match="tei:text[@xml:id]">
    <xsl:param name="document-metadata" tunnel="yes" />

    <xsl:variable name="document-id" select="ancestor::tei:TEI/@xml:id" />
    <doc>
      <xsl:sequence select="$document-metadata" />
      <field name="document_id">
        <xsl:value-of select="$document-id" />
      </field>
      <field name="file_path">
        <xsl:value-of select="$file-path" />
      </field>
      <field name="record_id">
        <xsl:value-of select="@xml:id" />
      </field>
      <field name="record_title">
        <xsl:value-of select="tei:body/tei:head[@type = 'main']" />
      </field>
      <field name="record_subtitle">
        <xsl:value-of select="tei:body/tei:head[@type = 'sub']" />
      </field>
      <field name="document_type">
        <xsl:value-of select="@type" />
      </field>

      <xsl:apply-templates select="tei:body/tei:head[@type = 'main']/tei:date" />
      <xsl:apply-templates mode="entity-mention-by-tei"
                           select=".//tei:*[@key]" />

      <xsl:variable name="free-text">
        <xsl:apply-templates mode="free-text" />
      </xsl:variable>

      <field name="text">
        <xsl:value-of select="normalize-space($free-text)" />
      </field>
    </doc>
  </xsl:template>

  <xsl:template match="tei:date">
    <xsl:if test="@when-iso">
      <field name="year">
        <xsl:value-of select="substring(@when-iso, 1, 4)" />
      </field>
      <field name="year_sort">
        <xsl:value-of select="substring(@when-iso, 1, 4)" />
      </field>
    </xsl:if>
    <xsl:if test="@notBefore-iso">
      <field name="year">
        <xsl:value-of select="substring(@notBefore-iso, 1, 4)" />
      </field>
      <field name="year_sort">
        <xsl:value-of select="substring(@notBefore-iso, 1, 4)" />
      </field>
    </xsl:if>
    <xsl:if test="@notAfter-iso">
      <field name="year">
        <xsl:value-of select="substring(@notAfter-iso, 1, 4)" />
      </field>
    </xsl:if>
    <xsl:if test="@from-iso and @to-iso">
      <xsl:for-each select="xs:integer(substring(@from-iso, 1, 4)) to xs:integer(substring(@to-iso, 1, 4))">
        <field name="year">
          <xsl:value-of select="." />
        </field>
      </xsl:for-each>
      <field name="year_sort">
        <xsl:value-of select="substring(@from-iso, 1, 4)" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:*[@key]" mode="entity-mention-by-tei">
    <xsl:if test="normalize-space(@type)">
      <field name="entity_url">
        <xsl:value-of select="@key" />
      </field>
      <field name="entity_type">
        <xsl:value-of select="@type" />
      </field>
      <field name="entity_name">
        <xsl:value-of select="normalize-space(.)" />
      </field>
      <field name="{@type}_name">
        <xsl:value-of select="normalize-space(.)" />
      </field>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
