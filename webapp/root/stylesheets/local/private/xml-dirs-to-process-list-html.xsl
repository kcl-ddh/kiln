<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="default.xsl"/>

  <xsl:param name="initial_path"/>

  <xsl:template match="/dir:directory">
    <table>
      <thead>
        <tr>
          <th scope="col">File</th>
          <th colspan="2" scope="col">Validation</th>
          <th scope="col">Search</th>
          <th scope="col">View</th>
        </tr>
      </thead>
      <tbody>
        <!-- Skip the containing directory since it will not always be
             wanted in generated URLs. The global parameter
             $initial_path can be used to add it where needed. -->
        <xsl:apply-templates select="dir:file">
          <xsl:with-param name="path" select="''"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="dir:directory">
          <xsl:with-param name="path" select="''"/>
        </xsl:apply-templates>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="dir:directory">
    <xsl:param name="path"/>
    <xsl:variable name="new_path" select="concat($path, @name, '/')"/>
    <xsl:apply-templates select="dir:file">
      <xsl:with-param name="path" select="$new_path"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="dir:directory">
      <xsl:with-param name="path" select="$new_path"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="dir:file">
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
        <a href="schematron/{$initial_path}{$filepath}.html">
          <xsl:text>Validate</xsl:text>
        </a>
      </td>
      <!-- Image checking. -->
      <td>
        <a href="resource-check/images/{$initial_path}{$filepath}.html">
          <xsl:text>Check images</xsl:text>
        </a>
      </td>
      <!-- Search indexing. -->
      <td>
        <xsl:text>Index</xsl:text>
      </td>
      <!-- View on site. -->
      <td>
        <a href="../../{$filepath}.html">
          <xsl:text>View</xsl:text>
        </a>
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>