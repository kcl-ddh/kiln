<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a TEI document together with an EATSML
       document into a Solr index document. -->

  <!-- Path to the TEI file being indexed. -->
  <xsl:param name="file-path" />

  <xsl:variable name="document-metadata">
    <xsl:apply-templates mode="document-metadata"
                         select="/*/tei/*/tei:teiHeader" />
  </xsl:variable>

  <xsl:variable name="free-text">
    <xsl:apply-templates mode="free-text" select="/*/tei/*/tei:text" />
  </xsl:variable>

  <xsl:template match="/">
    <!-- Entity mentions are restricted to the text of the document;
         entities keyed in the TEI header are document metadata. -->
    <xsl:apply-templates mode="entity-mention" select="/*/tei/*/tei:text//tei:*[@key]" />

    <!-- Text content -->
    <xsl:if test="normalize-space($free-text)">
      <doc>
        <xsl:sequence select="$document-metadata" />

        <field name="file_path">
          <xsl:value-of select="$file-path" />
        </field>
        <field name="document_id">
          <xsl:value-of select="/*/tei/tei:*/@xml:id" />
        </field>

        <field name="text">
          <xsl:value-of select="normalize-space($free-text)" />
        </field>
      </doc>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:title"
                mode="document-metadata">
    <field name="document_title">
      <xsl:value-of select="normalize-space(.)" />
    </field>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:author"
                mode="document-metadata">
    <field name="author">
      <xsl:value-of select="normalize-space(.)" />
    </field>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:editor"
                mode="document-metadata">
    <field name="editor">
      <xsl:value-of select="normalize-space(.)" />
    </field>
  </xsl:template>

  <xsl:template match="tei:sourceDesc//tei:publicationStmt/tei:date[1]"
                mode="document-metadata">
    <xsl:if test="@when">
      <field name="publication_date">
        <xsl:value-of select="@when" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template match="text()" mode="document-metadata" />

  <xsl:template match="node()" mode="free-text">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:*[@key]" mode="entity-mention">
    <doc>
      <xsl:sequence select="$document-metadata" />

      <xsl:variable name="entity-key" select="@key" />

      <field name="file_path">
        <xsl:value-of select="$file-path" />
      </field>
      <field name="document_id">
        <xsl:value-of select="/*/tei/tei:*/@xml:id" />
      </field>
      <field name="section_id">
        <xsl:value-of
          select="ancestor::tei:*[self::tei:div or self::tei:body or self::tei:front or self::tei:back or self::tei:group or self::tei:text][@xml:id][1]/@xml:id"
         />
      </field>
      <field name="entity_key">
        <xsl:value-of select="$entity-key" />
      </field>
      <field name="entity_name">
        <xsl:value-of select="normalize-space(.)" />
      </field>

      <xsl:for-each select="/*/eats/entities/entity[keys/key = $entity-key]/names/name">
        <field name="eats_entity_name">
          <xsl:value-of select="normalize-space(.)" />
        </field>
      </xsl:for-each>
    </doc>
  </xsl:template>
</xsl:stylesheet>
