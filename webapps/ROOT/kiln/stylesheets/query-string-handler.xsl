<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT defines functions to construct a URL query string
       (including initial "?"). -->

  <xsl:variable name="allowed-chars-pattern">
    <xsl:text>[A-Za-z0-9\-\.\?=\$\(\)\+\*]</xsl:text>
  </xsl:variable>

  <xsl:function name="kiln:escape-for-query-string" as="xs:string">
    <xsl:param name="input" as="xs:string" />
    <xsl:variable name="chars">
      <xsl:analyze-string select="$input" regex="{$allowed-chars-pattern}">
        <xsl:matching-substring>
          <xsl:value-of select="." />
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:analyze-string select="." regex=".">
            <xsl:matching-substring>
              <xsl:choose>
                <xsl:when test=". = ' '">
                  <xsl:text>+</xsl:text>
                </xsl:when>
                <!-- This is the escaping that Solr requires for ":". -->
                <xsl:when test=". = ':'">
                  <xsl:text>%5c:</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="encode-for-uri(.)" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:matching-substring>
          </xsl:analyze-string>
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </xsl:variable>
    <xsl:value-of select="string-join($chars, '')" />
  </xsl:function>

  <xsl:function name="kiln:query-string-from-sequence" as="xs:string">
    <!-- Output a query string formed by combining each name in
         $modified-parameters with its corresponding (by order in the
         sequence) value in $modified-values, and adding in those
         items in $parameters whose names are not in
         $modified-parameters.

         E.g: kiln:query-string-from-sequence(
                ('start=0', 'rows=25'), ('rows', 'q'), (40, 'foo'))
         will output "?start=0&rows=40&q=foo"
    -->
    <xsl:param name="parameters" as="xs:string*" />
    <xsl:param name="modified-parameters" as="xs:string*" />
    <xsl:param name="modified-values" />
    <xsl:variable name="reduced-parameters" as="xs:string*">
      <xsl:for-each select="$parameters">
        <xsl:if test="not(substring-before(., '=') = $modified-parameters)">
          <xsl:sequence select="." />
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="merged-parameters" as="xs:string*">
      <xsl:text>?</xsl:text>
      <xsl:value-of select="string-join($reduced-parameters, '&amp;')" />
      <xsl:for-each select="$modified-parameters">
        <!-- If the new parameter value is empty, do not include
             it. This allows for parameters to be simply removed from
             the supplied $parameters sequence. -->
        <xsl:variable name="position" select="position()" />
        <xsl:if test="string($modified-values[$position]) != ''">
          <xsl:text>&amp;</xsl:text>
          <xsl:value-of select="." />
          <xsl:text>=</xsl:text>
          <xsl:value-of select="$modified-values[$position]" />
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="string-join($merged-parameters, '')" />
  </xsl:function>

  <xsl:function name="kiln:query-string-from-string" as="xs:string">
    <xsl:param name="query-string" as="xs:string" />
    <xsl:param name="modified-parameters" as="xs:string*" />
    <xsl:param name="parameter-values" />
    <xsl:value-of select="kiln:query-string-from-sequence(
                          tokenize($query-string, '\?|&amp;'),
                          $modified-parameters, $parameter-values)" />
  </xsl:function>

</xsl:stylesheet>
