<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transforms XML specifying Solr query parameters into an
       XInclude to retrieve the results of the query, calling the
       cocoon://_internal/solr/query pipeline.

       Expects a document of the form:

          <aggregation>
            ...
            <queries>
              <query>
                ...
              </query>
              ...
            </queries>
          </aggregation>

       The content of query elements is an unordered set of elements,
       whose names correspond with the supported Solr parameter names
       (eg, "q", "sort", "hl.fl", "facet.range.gap"). For the most
       part these elements should contain only the text value of that
       parameter. The exception is "sort", which can take an
       "ordering" attribute specifying either "asc" or
       "desc".

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

  <xsl:template match="/aggregation">
    <xsl:copy>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/aggregation/queries" priority="10">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="/aggregation/queries/query">
    <xi:include>
      <xsl:attribute name="href">
        <xsl:text>cocoon://_internal/solr/query/</xsl:text>
        <xsl:apply-templates select="*" />
      </xsl:attribute>
    </xi:include>
  </xsl:template>

  <xsl:template match="/aggregation/*">
    <xsl:copy-of select="*" />
  </xsl:template>

  <xsl:template match="fl">
    <xsl:choose>
      <xsl:when test="preceding-sibling::fl">
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&amp;fl=</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="mlt.fl">
    <xsl:choose>
      <xsl:when test="preceding-sibling::mlt.fl">
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&amp;mlt.fl=</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="sort">
    <xsl:choose>
      <xsl:when test="preceding-sibling::sort">
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&amp;sort=</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="value">
      <xsl:value-of select="." />
      <xsl:if test="@ordering">
        <xsl:text> </xsl:text>
        <xsl:value-of select="@ordering" />
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="encode-for-uri($value)" />
  </xsl:template>

  <!-- Catch-all for simple query parameters. -->
  <xsl:template match="query/*" priority="-1">
    <xsl:call-template name="simple-parameter" />
  </xsl:template>

  <xsl:template name="simple-parameter">
    <xsl:if test="preceding-sibling::*">
      <xsl:text>&amp;</xsl:text>
    </xsl:if>
    <xsl:value-of select="local-name(.)" />
    <xsl:text>=</xsl:text>
    <xsl:value-of select="encode-for-uri(.)" />
  </xsl:template>

</xsl:stylesheet>
