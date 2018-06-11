<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform the XML returned from indexing all documents into
       Solr. -->

  <xsl:import href="../escape-xml.xsl" />
  <xsl:import href="index-to-html.xsl" />

  <xsl:template match="delete" mode="solr">
    <section>
      <h1>Remove old data</h1>

      <xsl:apply-templates mode="solr" />
    </section>
  </xsl:template>

  <xsl:template match="file" mode="solr-table">
    <tr>
      <td><xsl:value-of select="@path" /></td>
      <xsl:apply-templates mode="solr-table" />
    </tr>
  </xsl:template>

  <xsl:template match="index" mode="solr-table">
    <tr>
      <td>
        <xsl:value-of select="@name" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="../@path" />
        <xsl:text>#</xsl:text>
        <xsl:value-of select="@xml:id" />
        <xsl:text>)</xsl:text>
      </td>
      <xsl:apply-templates mode="solr-table" />
    </tr>
  </xsl:template>

  <xsl:template match="insert" mode="solr">
    <section>
      <h1>Add new data from "<xsl:value-of select="xincludes/@root" />"</h1>

      <table class="pure-table pure-table-horizontal">
        <thead>
          <tr>
            <th scope="col">File</th>
            <th scope="col">Status</th>
            <th scope="col">Full XML response</th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates mode="solr-table" />
        </tbody>
      </table>
    </section>
  </xsl:template>

  <xsl:template match="optimize" mode="solr">
    <section>
      <h1>Optimise the index</h1>

      <xsl:apply-templates mode="solr" />
    </section>
  </xsl:template>

  <xsl:template match="aggregation/*" mode="solr" priority="-10" />

  <xsl:template match="response" mode="solr-table">
    <xsl:apply-templates mode="solr-table" />
    <xsl:variable name="id" select="generate-id(.)" />
    <td>
      <span class="switch" id="{$id}-switch"
            onclick="toggle('{$id}', '[show]', '[hide]')">[show]</span>
      <pre id="{$id}" style="display: none">
        <xsl:apply-templates mode="escape-xml" select="." />
      </pre>
    </td>
  </xsl:template>

  <xsl:template match="responseHeader" mode="solr-table">
    <td>
      <xsl:choose>
        <xsl:when test="contains(., 'status=0')">
          <xsl:text>This operation succeeded.</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>This operation failed.</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </xsl:template>

  <xsl:template match="xincludes[@root='indices']" mode="solr-table">
    <xsl:apply-templates mode="solr-table" select="file/index" />
  </xsl:template>

</xsl:stylesheet>
