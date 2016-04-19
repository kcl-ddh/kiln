<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../defaults.xsl"/>
  <xsl:include href="cocoon://_internal/url/reverse.xsl" />

  <xsl:template match="/aggregation/dir:directory" mode="tei">
    <h3>TEI</h3>

    <p>
      <a class="button round"
         href="{kiln:url-for-match('local-solr-index-all', ())}">
        <xsl:text>Index all (search)</xsl:text>
      </a>
      <xsl:text> </xsl:text>
      <a class="button round"
         href="{kiln:url-for-match('local-rdf-harvest-all-display', ())}">
        <xsl:text>Harvest all (RDF)</xsl:text>
      </a>
    </p>

    <table>
      <thead>
        <tr>
          <th scope="col">File</th>
          <th colspan="2" scope="col">Reports</th>
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
    <xsl:variable name="short-filepath">
      <xsl:value-of select="substring-after($filepath, 'tei/')" />
    </xsl:variable>
    <tr>
      <!-- File path. -->
      <td>
        <xsl:value-of select="$short-filepath"/>
        <xsl:text>.xml</xsl:text>
      </td>
      <!-- Default Schematron link. -->
      <td>
        <a title="Schematron validation report"
           href="{kiln:url-for-match('local-admin-schematron-validation',
                 ($filepath))}">
          <xsl:text>Schematron</xsl:text>
        </a>
      </td>
      <!-- Image checking. -->
      <td>
        <a href="{kiln:url-for-match('local-admin-resource-check',
                 ($filepath))}">
          <xsl:text>Missing images</xsl:text>
        </a>
      </td>
      <!-- Search indexing. -->
      <td>
        <a title="Index document in search server"
           href="{kiln:url-for-match('local-solr-index', ('tei', $filepath))}">
          <xsl:text>Index</xsl:text>
        </a>
      </td>
      <!-- RDF harvesting. -->
      <td>
        <a title="Harvest RDF from document"
           href="{kiln:url-for-match('local-rdf-harvest-display',
                                     ($filepath))}">
          <xsl:text>Harvest</xsl:text>
        </a>
      </td>
      <!-- View on site. -->
      <td>
        <a href="{kiln:url-for-match('local-tei-display-html',
                 ($short-filepath))}">
          <xsl:text>View</xsl:text>
        </a>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
