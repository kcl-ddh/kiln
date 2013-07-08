<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform the XML returned from harvesting RDF into the Sesame
       server into HTML. -->

  <xsl:import href="../escape-xml.xsl" />

  <xsl:template match="error" mode="rdf">
    <td class="fail">
      <xsl:text>Failed: </xsl:text>
      <xsl:value-of select="." />
    </td>
  </xsl:template>

  <xsl:template match="file" mode="rdf">
    <tr>
      <td><xsl:value-of select="@path" /></td>
      <xsl:apply-templates mode="rdf" />
    </tr>
  </xsl:template>

  <xsl:template match="file/response" mode="rdf">
    <xsl:apply-templates mode="rdf" />
    <xsl:variable name="id" select="generate-id(.)" />
    <td>
      <span class="switch" id="{$id}-switch"
            onclick="toggle('{$id}', '[show]', '[hide]')">[show]</span>

      <pre id="{$id}" style="display: none">
        <xsl:apply-templates mode="escape-xml" select="." />
      </pre>
    </td>
  </xsl:template>

  <xsl:template match="success" mode="rdf">
    <td class="success">
      <xsl:text>Succeeded</xsl:text>
    </td>
  </xsl:template>

  <xsl:template match="xincludes" mode="rdf">
    <table class="pure-table pure-table-horizontal">
      <thead>
        <th scope="col">File</th>
        <th scope="col">Remove old data</th>
        <th scope="col">Add new data</th>
        <th scope="col">Full XML response</th>
      </thead>
      <tbody>
        <xsl:apply-templates mode="rdf" />
      </tbody>
    </table>
  </xsl:template>

</xsl:stylesheet>
