<xsl:stylesheet exclude-result-prefixes="#all"
		version="2.0"
                xmlns="http://www.w3.org/1999/xhtml"
		xmlns:saxon="http://saxon.sf.net/"
		xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="cocoon://_internal/properties/properties.xsl"/>

  <xsl:key name="failed-asserts-by-pattern" match="svrl:failed-assert"
	   use="preceding-sibling::svrl:active-pattern[1]/@id"/>

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
	<title>
          <xsl:text>Schematron validation results for </xsl:text>
          <xsl:value-of select="$file"/>
        </title>
	<style type="text/css">
	  div.overall-status { border: 2px solid grey; margin: 1em 6em 2em 4em; }
	  div.overall-status h2 { color: #0C393F; background: #F0F0F0; margin-top: 0; padding: 0.5em 0; text-align: center; border-bottom: 1px solid grey; }
	  div.overall-status p { margin: 1em 3em 1em 2em; font-weight: bold; }
	  p.error { color: red; background: white; }
	  p.warning { color: #F57900; background: white; }
	  p.clean { color: green; background: white; }
	  table { border-collapse: collapse; border: 2px solid grey; }
          td, th { vertical-align: top; border: 1px solid grey; padding: 0.5em; }
          th { color: #0C393F; background: #F0F0F0; }
	</style>
      </head>
      <body>
        <h1>
          <xsl:text>Schematron validation results for </xsl:text>
          <xsl:value-of select="$file"/>
        </h1>

	<div class="overall-status">
	  <h2>Summary Status</h2>
	  <xsl:if test="/svrl:schematron-output/svrl:failed-assert/@flag='has-errors'">
	    <p class="error">
              <img src="{$xmp:images-path}/xmod/schematron/error.png" alt=""/>
              <xsl:text> Errors were found in the document!</xsl:text>
            </p>
	  </xsl:if>
	  <xsl:if test="/svrl:schematron-output/svrl:failed-assert/@flag='has-warnings'">
	    <p class="warning">
              <img src="{$xmp:images-path}/xmod/schematron/warning.png" alt=""/>
              <xsl:text> Warnings were found in the document!</xsl:text>
            </p>
	  </xsl:if>
	  <xsl:if test="not(/svrl:schematron-output/svrl:failed-assert)">
	    <p class="clean">No errors or warnings reported.</p>
	  </xsl:if>
	</div>

	<xsl:apply-templates select="/svrl:schematron-output/svrl:active-pattern"/>
      </body>
    </html>
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
              <th scope="col">Mark</th>
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
	<xsl:apply-templates select="@icon"/>
      </td>
      <td>
        <p>
          <input type="checkbox"/>
        </p>
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
          <xsl:value-of select="$xmp:images-path"/>
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