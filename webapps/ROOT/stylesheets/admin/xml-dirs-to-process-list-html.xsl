<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../defaults.xsl"/>

  <xsl:param name="initial_path" select="''"/>

  <xsl:template match="/aggregation/dir:directory" mode="tei">
    <h3>TEI</h3>

    <p>
      <a class="button round" href="solr/index/all.html">Index all
      (search)</a>
      <xsl:text> </xsl:text>
      <a class="button round" href="rdf/harvest/all.html">Harvest all
      (RDF)</a>
    </p>

    <table>
      <thead>
        <tr>
          <th scope="col">File</th>
          <th colspan="2" scope="col">Validation</th>
          <th scope="col">Search</th>
          <th scope="col">RDF</th>
          <th scope="col">View</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates mode="tei"
                             select=".//dir:directory[@name='tei']" />
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="dir:directory" mode="#all">
    <xsl:param name="path"/>
    <xsl:variable name="new_path" select="concat($path, @name, '/')"/>
    <xsl:apply-templates select="dir:file" mode="#current">
      <xsl:with-param name="path" select="$new_path"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="dir:directory" mode="#current">
      <xsl:with-param name="path" select="$new_path"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="dir:file" mode="tei">
    <xsl:param name="path"/>
    <xsl:variable name="filepath">
      <xsl:value-of select="$path"/>
      <xsl:value-of select="substring-before(@name, '.xml')"/>
    </xsl:variable>
    <tr>
      <!-- File path. -->
      <td>
        <xsl:value-of select="$filepath"/>
        <xsl:text>.xml</xsl:text>
      </td>
      <!-- Default Schematron link. -->
      <td>
        <a href="schematron/{$initial_path}{$filepath}.html">Validate</a>
      </td>
      <!-- Image checking. -->
      <td>
        <a href="resource-check/images/{$initial_path}{$filepath}.html">Check images</a>
      </td>
      <!-- Search indexing. -->
      <td>
        <a href="../solr/index/{$path}{$initial_path}{$filepath}.html"
            title="Index document in search server">Index</a>
      </td>
      <!-- RDF harvesting. -->
      <td>
        <a href="../rdf/harvest/{$initial_path}{$filepath}.html"
           title="Harvest RDF from document">Harvest</a>
      </td>
      <!-- View on site. -->
      <td>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$kiln:mount-path" />
            <xsl:text>/text/</xsl:text>
            <xsl:value-of select="substring-after($filepath, 'tei/')" />
            <xsl:text>.html</xsl:text>
          </xsl:attribute>
          <xsl:text>View</xsl:text>
        </a>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
