<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transforms XML specifying Solr query parameters into an
       XInclude to retrieve the results of the query, calling the
       cocoon://_internal/solr/query pipeline.

       Expects a document of the form:

          <query>
            ...
          </query>

       The content of query element is an unordered set of elements,
       whose names correspond with the supported Solr parameter names
       (eg, "q", "sort", "hl.fl", "facet.range.gap"). For the most
       part these elements should contain only the text value of that
       parameter. The exception is "sort", which takes an
       "ordering" attribute specifying either "asc" or "desc".

       Multiple elements of the same name can be used where
       appropriate. In such cases, the order of the elements in the
       source document is retained. To produce a query that sorts of
       the fields "score" (descending) and "price" (ascending), use:

          <sort @ordering="desc">score</sort>
          <sort @ordering="asc">price</sort>

       Alternatively, the value of a single "sort" element may contain
       the whole string in the required format:

          <sort>score desc,price asc</sort>

       The same is true of other parameters that can contain multiple
       values, such as "fl". The two following snippets produce the
       same query:

          <fl>price</fl>
          <fl>score</fl>

          <fl>price,score</fl>

       Where a parameter may be specified multiple times, such as
       "fq", use a separate element for each. The XSLT knows which
       elements should be joined (and how), and which are not.

       This XSLT performs URI escaping on all parameter values
       (typically equivalent to the textual content of query/*).

  -->

  <xsl:template match="query">
    <xi:include>
      <xsl:attribute name="href">
        <xsl:text>cocoon://_internal/solr/query/</xsl:text>
        <xsl:apply-templates select="*" />
      </xsl:attribute>
    </xi:include>
  </xsl:template>

  <xsl:template match="fl | mlt.fl | sort">
    <xsl:call-template name="complex-parameter">
      <xsl:with-param name="field" select="local-name()" />
    </xsl:call-template>
  </xsl:template>

  <!-- Catch-all for simple query parameters. -->
  <xsl:template match="*">
    <xsl:if test="preceding-sibling::*">
      <xsl:text>&amp;</xsl:text>
    </xsl:if>
    <xsl:call-template name="simple-parameter" />
  </xsl:template>

  <xsl:template match="@ordering">
    <xsl:text> </xsl:text>
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template name="complex-parameter">
    <!-- Complex parameters must be grouped into a single parameter
         with comma separated values. Collect all of the values on the
         first matching element. -->
    <xsl:param name="field" />
    <xsl:if test="not(preceding-sibling::*[local-name() = $field])">
      <xsl:if test="preceding-sibling::*">
        <xsl:text>&amp;</xsl:text>
      </xsl:if>
      <xsl:value-of select="$field" />
      <xsl:text>=</xsl:text>
      <xsl:variable name="value">
        <xsl:value-of select="." />
        <xsl:apply-templates select="@*" />
      </xsl:variable>
      <xsl:value-of select="$value" />
      <xsl:for-each select="following-sibling::*[local-name() = $field]">
        <xsl:text>,</xsl:text>
        <xsl:variable name="next-value">
          <xsl:value-of select="." />
          <xsl:apply-templates select="@*" />
        </xsl:variable>
        <xsl:value-of select="$next-value" />
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="simple-parameter">
    <xsl:value-of select="local-name(.)" />
    <xsl:text>=</xsl:text>
    <xsl:value-of select="." />
  </xsl:template>

</xsl:stylesheet>
