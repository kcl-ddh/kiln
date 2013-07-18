<xsl:stylesheet version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform an XML report on checking for local resources into
       HTML. -->

  <xsl:template match="report">
    <div>
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="missing_files">
    <div id="missing_files">
      <h2>Missing Files</h2>
      <xsl:choose>
        <xsl:when test=".//file">
          <table>
            <thead>
              <tr>
                <th scope="col">
                  <xsl:text>TEI file ID</xsl:text>
                </th>
                <th scope="col">
                  <xsl:text>TEI file path</xsl:text>
                </th>
                <th scope="col">
                  <xsl:text>Missing files</xsl:text>
                </th>
              </tr>
            </thead>
            <tbody>
              <xsl:apply-templates/>
            </tbody>
          </table>
        </xsl:when>
        <xsl:otherwise>
          <p>There are no missing files.</p>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match="referring_file[file]">
    <xsl:variable name="number_missing" select="count(file)"/>
    <tr>
      <td rowspan="{$number_missing}" style="vertical-align: top;">
        <xsl:value-of select="@xml:id"/>
      </td>
      <td rowspan="{$number_missing}" style="vertical-align: top;">
        <xsl:value-of select="@path"/>
      </td>
      <xsl:apply-templates select="*[position()=1]"/>
    </tr>
    <xsl:for-each select="*[position()!=1]">
      <tr>
        <xsl:apply-templates select="."/>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="file">
    <td>
      <xsl:value-of select="@path"/>
    </td>
  </xsl:template>

  <xsl:template match="mismatched_files">
    <xsl:if test=".//reference">
      <div id="mismatched_files">
        <h2>Mismatched attributes</h2>

        <table>
          <thead>
            <tr>
              <th scope="col">
              </th>
            </tr>
          </thead>
        </table>
      </div>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
