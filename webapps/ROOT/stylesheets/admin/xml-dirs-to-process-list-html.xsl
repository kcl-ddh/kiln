<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../defaults.xsl"/>
  <xsl:include href="cocoon://_internal/url/reverse.xsl" />

  <xsl:template match="/aggregation/dir:directory" mode="#all">
    <xsl:param name="directory" />
    <xsl:param name="header" />

    <h3><xsl:value-of select="$header" /></h3>

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
        <xsl:apply-templates mode="#current"
                             select=".//dir:directory[@name=$directory]" />
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="/aggregation/dir:directory" mode="authority"
                priority="10">
    <xsl:param name="directory" />
    <xsl:param name="header" />

    <h3><xsl:value-of select="$header" /></h3>

    <table>
      <thead>
        <tr>
          <th scope="col">File</th>
          <th scope="col">RDF</th>
          <th scope="col">Concordance</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates mode="authority" select=".//dir:directory[@name=$directory]" />
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="/aggregation/dir:directory" mode="indices"
                priority="10">
    <xsl:param name="directory" />
    <xsl:param name="header" />

    <h3><xsl:value-of select="$header" /></h3>

    <p>Each index file specifies (by way of its filename) which
    subdirectory in content/xml the indices it defines apply to. The
    index link for a file will index all documents in the appropriate
    directory according to all of the indices defined in that
    file.</p>

    <table>
      <thead>
        <tr>
          <th scope="col">File</th>
          <th scope="col">Index</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates mode="indices" select=".//dir:directory[@name=$directory]" />
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

  <xsl:template match="dir:file" mode="authority">
    <xsl:param name="path" />
    <xsl:variable name="filepath">
      <xsl:value-of select="$path" />
      <xsl:value-of select="substring-before(@name, '.xml')" />
    </xsl:variable>
    <xsl:variable name="short-filepath"
                  select="substring-after($filepath, 'authority/')" />
    <tr>
      <!-- File path. -->
      <td>
        <xsl:value-of select="$short-filepath" />
        <xsl:text>.xml</xsl:text>
      </td>
      <!-- RDF harvesting. -->
      <td>
        <a title="Harvest RDF from document"
           href="{kiln:url-for-match('local-rdf-harvest-display',
                                     ($filepath), 0)}">
          <xsl:text>Harvest</xsl:text>
        </a>
      </td>
      <td>
        <xsl:if test="@name = concat($concordance-bibliography-file, '.xml')">
          <a title="Harvest bibliographic concordance information"
             href="{kiln:url-for-match('local-solr-index', ('concordance', 'authority/bibliography'), 0)}">
            <xsl:text>Index</xsl:text>
          </a>
        </xsl:if>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="dir:file" mode="epidoc">
    <xsl:param name="path" />
    <xsl:variable name="filepath">
      <xsl:value-of select="$path" />
      <xsl:value-of select="substring-before(@name, '.xml')" />
    </xsl:variable>
    <xsl:variable name="short-filepath"
                  select="substring-after($filepath, 'epidoc/')" />
    <tr>
      <!-- File path. -->
      <td>
        <xsl:value-of select="$short-filepath" />
        <xsl:text>.xml</xsl:text>
      </td>
      <td></td>
      <td></td>
      <td>
        <a title="Index document in search server"
           href="{kiln:url-for-match('local-solr-index', ('tei', $filepath), 0)}">
          <xsl:text>Index</xsl:text>
        </a>
      </td>
      <td></td>
      <td>
        <a href="{kiln:url-for-match('local-epidoc-display-html',
                 ($language, $short-filepath), 0)}">
          <xsl:text>View</xsl:text>
        </a>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="dir:file" mode="indices">
    <xsl:param name="path" />
    <xsl:variable name="filepath">
      <xsl:value-of select="$path" />
      <xsl:value-of select="substring-before(@name, '.xml')" />
    </xsl:variable>
    <xsl:variable name="short-filepath"
                  select="substring-after($filepath, 'indices/')" />
    <tr>
      <td>
        <xsl:value-of select="$short-filepath" />
        <xsl:text>.xml</xsl:text>
      </td>
      <td>
        <a href="{kiln:url-for-match('local-solr-index-indices', ($short-filepath), 0)}">
          <xsl:text>Index</xsl:text>
        </a>
      </td>
    </tr>
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
                 ($filepath), 0)}">
          <xsl:text>Schematron</xsl:text>
        </a>
      </td>
      <!-- Image checking. -->
      <td>
        <a href="{kiln:url-for-match('local-admin-resource-check',
                 ($filepath), 0)}">
          <xsl:text>Missing images</xsl:text>
        </a>
      </td>
      <!-- Search indexing. -->
      <td>
        <a title="Index document in search server"
           href="{kiln:url-for-match('local-solr-index', ('tei', $filepath), 0)}">
          <xsl:text>Index</xsl:text>
        </a>
      </td>
      <!-- RDF harvesting. -->
      <td>
        <a title="Harvest RDF from document"
           href="{kiln:url-for-match('local-rdf-harvest-display',
                                     ($filepath), 0)}">
          <xsl:text>Harvest</xsl:text>
        </a>
      </td>
      <!-- View on site. -->
      <td>
        <a href="{kiln:url-for-match('local-tei-display-html',
                 ($language, $short-filepath), 0)}">
          <xsl:text>View</xsl:text>
        </a>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
