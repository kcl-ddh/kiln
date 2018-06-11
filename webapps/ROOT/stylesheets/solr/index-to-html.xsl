<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform the XML returned from indexing a document in
       Solr. -->

  <xsl:import href="../escape-xml.xsl" />

  <xsl:template match="add" mode="solr">
    <section>
      <h1>Add new data</h1>

      <xsl:apply-templates mode="solr" />
    </section>
  </xsl:template>

  <xsl:template match="delete" mode="solr">
    <section>
      <h1>Remove old data</h1>

      <xsl:apply-templates mode="solr" />
    </section>
  </xsl:template>

  <xsl:template match="optimize" mode="solr">
    <section>
      <h1>Optimise the index</h1>

      <xsl:apply-templates mode="solr" />
    </section>
  </xsl:template>

  <xsl:template match="aggregation/response" mode="solr">
    <xsl:apply-templates mode="solr" />
  </xsl:template>

  <xsl:template match="response" mode="solr">
    <xsl:apply-templates mode="solr" />
    <xsl:variable name="id" select="generate-id(.)" />
    <p>
      <xsl:text>Full XML response: </xsl:text>
      <span class="switch" id="{$id}-switch"
            onclick="toggle('{$id}', '[show]', '[hide]')">[show]</span>
    </p>
    <pre id="{$id}" style="display: none">
      <xsl:apply-templates mode="escape-xml" select="." />
    </pre>
  </xsl:template>

  <xsl:template match="responseHeader" mode="solr">
    <xsl:choose>
      <xsl:when test="contains(., 'status=0')">
        <p>This operation succeeded.</p>
      </xsl:when>
      <xsl:otherwise>
        <p>This operation failed.</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="kiln:nav" mode="solr" />

</xsl:stylesheet>
