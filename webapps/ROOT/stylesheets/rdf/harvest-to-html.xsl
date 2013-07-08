<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform the XML returned from harvesting RDF into the Sesame
       server into HTML. -->

  <xsl:import href="../escape-xml.xsl" />

  <xsl:template match="add" mode="rdf">
    <section>
      <h1>Add new data</h1>

      <xsl:apply-templates mode="rdf" />
    </section>
  </xsl:template>

  <xsl:template match="clear" mode="rdf">
    <section>
      <h1>Remove old data</h1>

      <xsl:apply-templates mode="rdf" />
    </section>
  </xsl:template>

  <xsl:template match="error" mode="rdf">
    <p>This operation failed with the error message:</p>
    <blockquote>
      <p><xsl:value-of select="." /></p>
    </blockquote>
  </xsl:template>

  <xsl:template match="aggregation/response" mode="rdf">
    <xsl:apply-templates mode="rdf" />
  </xsl:template>

  <xsl:template match="response" mode="rdf">
    <xsl:apply-templates mode="rdf" />
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

  <xsl:template match="success" mode="rdf">
    <p>This operation succeeded.</p>
  </xsl:template>

</xsl:stylesheet>
