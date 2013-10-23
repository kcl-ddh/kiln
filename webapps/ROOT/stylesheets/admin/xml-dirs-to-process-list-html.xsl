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
      <a class="button round">
        <xsl:attribute name="href">
          <xsl:call-template name="url-for-match">
            <xsl:with-param name="match-id"
                            select="'local-solr-index-all'" />
          </xsl:call-template>
        </xsl:attribute>
        <xsl:text>Index all (search)</xsl:text>
      </a>
      <xsl:text> </xsl:text>
      <a class="button round">
        <xsl:attribute name="href">
          <xsl:call-template name="url-for-match">
            <xsl:with-param name="match-id"
                            select="'local-rdf-harvest-all-display'" />
          </xsl:call-template>
        </xsl:attribute>
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
    <tr>
      <!-- File path. -->
      <td>
        <xsl:value-of select="substring-after($filepath, 'tei/')"/>
        <xsl:text>.xml</xsl:text>
      </td>
      <!-- Default Schematron link. -->
      <td>
        <a title="Schematron validation report">
          <xsl:attribute name="href">
            <xsl:call-template name="url-for-match">
              <xsl:with-param name="match-id"
                              select="'local-admin-schematron-validation'" />
              <xsl:with-param name="parameters" select="($filepath)" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Schematron</xsl:text>
        </a>
      </td>
      <!-- Image checking. -->
      <td>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="url-for-match">
              <xsl:with-param name="match-id"
                              select="'local-admin-resource-check'" />
              <xsl:with-param name="parameters" select="($filepath)" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Missing images</xsl:text>
        </a>
      </td>
      <!-- Search indexing. -->
      <td>
        <a title="Index document in search server">
          <xsl:attribute name="href">
            <xsl:call-template name="url-for-match">
              <xsl:with-param name="match-id"
                              select="'local-solr-index'" />
              <xsl:with-param name="parameters"
                              select="('tei', $filepath)" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Index</xsl:text>
        </a>
      </td>
      <!-- RDF harvesting. -->
      <td>
        <a title="Harvest RDF from document">
          <xsl:attribute name="href">
            <xsl:call-template name="url-for-match">
              <xsl:with-param name="match-id"
                              select="'local-rdf-harvest-display'" />
              <xsl:with-param name="parameters" select="($filepath)" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Harvest</xsl:text>
        </a>
      </td>
      <!-- View on site. -->
      <td>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="url-for-match">
              <xsl:with-param name="match-id"
                              select="'local-tei-display-html'" />
              <xsl:with-param name="parameters"
                              select="(substring-after($filepath, 'tei/'))" />
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>View</xsl:text>
        </a>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
