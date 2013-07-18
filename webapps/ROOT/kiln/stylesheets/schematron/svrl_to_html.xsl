<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="cocoon://_internal/template/xsl/stylesheets/defaults.xsl" />

  <xsl:key name="failed-asserts-by-pattern" match="svrl:failed-assert"
           use="preceding-sibling::svrl:active-pattern[1]/@id"/>

  <xsl:variable name="schematron-images-path">
    <xsl:value-of select="$kiln:assets-path" />
    <xsl:text>/images/schematron</xsl:text>
  </xsl:variable>

  <xsl:template match="svrl:schematron-output">
    <div class="overall-status">
      <h2>Summary Status</h2>

      <xsl:choose>
        <xsl:when test="svrl:failed-assert">
          <xsl:if test="svrl:failed-assert/@flag='has-errors' or
                        svrl:failed-assert[not(@flag)]">
            <p class="error">
              <img src="{$schematron-images-path}/error.png" alt=""/>
              <xsl:text> Errors were found in the document!</xsl:text>
            </p>
          </xsl:if>
          <xsl:if test="svrl:failed-assert/@flag='has-warnings'">
            <p class="warning">
              <img src="{$schematron-images-path}/warning.png" alt=""/>
              <xsl:text> Warnings were found in the document!</xsl:text>
            </p>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <p class="clean">No errors or warnings reported.</p>
        </xsl:otherwise>
      </xsl:choose>
    </div>

    <xsl:apply-templates select="svrl:active-pattern"/>
  </xsl:template>

  <xsl:template match="svrl:active-pattern">
    <xsl:variable name="failed-asserts"
                  select="key('failed-asserts-by-pattern', @id)"/>

    <xsl:if test="$failed-asserts">
      <div class="pattern">
        <h2>
          <xsl:value-of select="@name"/>
        </h2>

        <table>
          <thead>
            <tr>
              <th/>
              <th scope="col">Failure message</th>
              <th scope="col">Diagnostic messages</th>
              <th scope="col">References</th>
              <th scope="col">XPath Location</th>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates select="$failed-asserts"/>
          </tbody>
        </table>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="svrl:failed-assert">
    <tr>
      <td>
        <xsl:choose>
          <xsl:when test="@when">
            <xsl:apply-templates select="@icon"/>
          </xsl:when>
          <xsl:otherwise>
            <img alt="Error!" src="{$schematron-images-path}/error.png" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:apply-templates select="svrl:text"/>
      </td>
      <td>
        <xsl:apply-templates select="svrl:diagnostic-reference"/>
      </td>
      <td>
        <xsl:apply-templates select="@see"/>
      </td>
      <td>
        <xsl:apply-templates select="@location"/>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="svrl:text">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="svrl:diagnostic-reference">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- QAZ: emph elements. -->

  <xsl:template match="@icon">
    <p>
      <img alt="">
        <xsl:attribute name="src">
          <xsl:value-of select="$schematron-images-path"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="."/>
        </xsl:attribute>
      </img>
    </p>
  </xsl:template>

  <xsl:template match="@location">
    <p>
      <xsl:value-of select="."/>
    </p>
  </xsl:template>

  <xsl:template match="@see">
    <!-- It is very annoying that this is simply a URL with no other
         identifying information that could make for a useful
         link. Assume that the URL is of the encoding guidelines if it
         is relative, and just use the URL if it is not. -->
    <p>
      <a href="{.}">
        <xsl:choose>
          <xsl:when test="starts-with(., 'http')">
            <xsl:value-of select="."/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Encoding guidelines</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </p>
  </xsl:template>

</xsl:stylesheet>
