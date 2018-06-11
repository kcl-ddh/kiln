<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform the XML returned from indexing the indices specified
       in an index document into Solr. -->

  <xsl:import href="../escape-xml.xsl" />
  <xsl:import href="index-to-html.xsl" />

  <xsl:template match="file" mode="solr-table">
    <tr>
      <td><xsl:value-of select="@path" /></td>
      <xsl:apply-templates mode="solr-table" />
    </tr>
  </xsl:template>

  <xsl:template match="insert" mode="solr">
    <section>
      <h1>Add new data</h1>

      <table class="pure-table pure-table-horizontal">
        <thead>
          <tr>
            <th scope="col">Index</th>
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

  <xsl:template match="index" mode="solr-table">
    <tr>
      <td>
        <xsl:value-of select="@name" />
        <xsl:text> (#</xsl:text>
        <xsl:value-of select="@xml:id" />
        <xsl:text>)</xsl:text>
      </td>
      <xsl:apply-templates mode="solr-table" />
    </tr>
  </xsl:template>

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

</xsl:stylesheet>
