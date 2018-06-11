<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transforms XML specifying Solr query parameters into an
       XInclude to retrieve the results of the query, calling the
       cocoon://_internal/solr/query pipeline.

       Expects a document of the form:

          <query>
            ...
          </query>

       The content of the query element is an unordered set of
       elements, whose names correspond with the supported Solr
       parameter names (eg, "q", "sort", "hl.fl",
       "facet.range.gap"). For the most part these elements should
       contain only the text value of that parameter. There are three
       exceptions:

       * "sort", which takes an "ordering" attribute specifying either
       "asc" or "desc".

       * field names with a "type" attribute value of "range_start" or
       "range_end". These are appended to the value of the "q"
       parameter to make an inclusive range query ANDed to the
       existing value.

       * facet field names with a "join" attribute value of "and" or
       "or". These are used to determine whether this facet's values
       are ANDed or ORed together.

       Multiple elements of the same name can be used where
       appropriate. In such cases, the order of the elements in the
       source document is retained. To produce a query that sorts on
       the fields "score" (descending) and "price" (ascending), use:

          <sort ordering="desc">score</sort>
          <sort ordering="asc">price</sort>

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
    <xsl:variable name="query-string-parts" as="xs:string*">
      <!-- This may look strange, but it is designed so that each
           template's sequence that is returned is lumped
           together. -->
      <xsl:for-each select="*">
        <xsl:variable name="part">
          <xsl:apply-templates select="." />
        </xsl:variable>
        <xsl:if test="normalize-space($part)">
          <xsl:value-of select="$part" />
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xi:include>
      <xsl:attribute name="href">
        <xsl:text>cocoon://_internal/solr/query/</xsl:text>
        <xsl:value-of select="string-join($query-string-parts, '&amp;')" />
      </xsl:attribute>
    </xi:include>
  </xsl:template>

  <xsl:template match="facet.field[@join='or']" priority="10">
    <xsl:value-of select="local-name(.)" />
    <xsl:text>={!ex=</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>Tag}</xsl:text>
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="fl | mlt.fl | sort">
    <xsl:call-template name="complex-parameter">
      <xsl:with-param name="field" select="local-name()" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="q">
    <!-- q parameters are bundled together and handled by the first q
         element, so do not process this at all if if it is preceded
         by a q. -->
    <xsl:if test="not(preceding-sibling::q)">
      <xsl:call-template name="q-parameter" />
    </xsl:if>
  </xsl:template>

  <!-- Facet field values. -->
  <xsl:template match="*[@join='and']">
    <xsl:text>fq=</xsl:text>
    <xsl:value-of select="local-name()" />
    <xsl:text>:"</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="*[@join='or']">
    <xsl:variable name="name" select="local-name()" />
    <xsl:if test="not(preceding-sibling::*[local-name()=$name])">
      <xsl:text>fq={!tag=</xsl:text>
      <xsl:value-of select="$name" />
      <xsl:text>Tag}</xsl:text>
      <xsl:value-of select="$name" />
      <xsl:text>:(</xsl:text>
      <xsl:for-each select="../*[local-name()=$name]">
        <xsl:text>"</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>"</xsl:text>
        <xsl:if test="position() != last()">
          <xsl:text>+OR+</xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Range fields are handled by the first q field. -->
  <xsl:template match="*[@type=('range_start', 'range_end')]" />

  <!-- Catch-all for simple query parameters. -->
  <xsl:template match="*">
    <xsl:call-template name="simple-parameter" />
  </xsl:template>

  <xsl:template match="*" mode="range-parameter">
    <xsl:variable name="field" select="local-name(.)" />
    <xsl:value-of select="$field" />
    <xsl:text>:[</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>+TO+</xsl:text>
    <xsl:value-of select="../*[local-name()=$field][@type='range_end']" />
    <xsl:text>]</xsl:text>
  </xsl:template>

  <xsl:template match="@ordering">
    <xsl:text>+</xsl:text>
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

  <xsl:template name="q-parameter">
    <xsl:value-of select="local-name(.)" />
    <xsl:text>=</xsl:text>
    <xsl:variable name="non-range-query">
      <xsl:if test="normalize-space()">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>)</xsl:text>
      </xsl:if>
      <!-- Look for extra q parameters to add in. -->
      <xsl:for-each select="following-sibling::q">
        <xsl:if test="normalize-space()">
          <xsl:text>+AND+</xsl:text>
        </xsl:if>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>)</xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="normalize-space($non-range-query)" />
    <!-- Look for range parameters to add in. -->
    <xsl:variable name="range_parameters"
                  select="../*[@type='range_start'][normalize-space()]" />
    <xsl:if test="$range_parameters">
      <xsl:if test="normalize-space($non-range-query)">
        <xsl:text>+AND+</xsl:text>
      </xsl:if>
      <xsl:for-each select="$range_parameters">
        <xsl:apply-templates mode="range-parameter" select="." />
        <xsl:if test="not(position() = last())">
          <xsl:text>+AND+</xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="simple-parameter">
    <xsl:value-of select="local-name(.)" />
    <xsl:text>=</xsl:text>
    <xsl:value-of select="." />
  </xsl:template>

</xsl:stylesheet>
