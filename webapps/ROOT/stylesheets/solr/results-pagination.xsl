<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:h="http://apache.org/cocoon/request/2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- XSLT to handle pagination of search results.

       Assumes that the search results are in
       /aggregation/response. -->

  <xsl:import href="../../kiln/stylesheets/query-string-handler.xsl" />

  <!-- Request parameters element. -->
  <xsl:variable name="request"
                select="/aggregation/h:request/h:requestParameters" />

  <xsl:variable name="query-string-parameters" as="xs:string*">
    <xsl:for-each select="$request/h:parameter/h:value">
      <xsl:value-of select="concat(../@name, '=', kiln:escape-for-query-string(.))" />
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="query-string-at-start"
                select="kiln:query-string-from-sequence(
                        $query-string-parameters, ('start'), 0)" />
  <xsl:variable name="rows" select="/aggregation/response/lst[@name='responseHeader']/lst[@name='params']/str[@name='rows']" />
  <xsl:variable name="start"
                select="number(/aggregation/response/result/@start)" />
  <xsl:variable name="number-results"
                select="number(/aggregation/response/result/@numFound)" />
  <xsl:variable name="current-page"
                select="xs:integer(floor($start div $rows)) + 1" />
  <xsl:variable name="total-pages"
                select="xs:integer(ceiling($number-results div $rows))" />

  <xsl:template name="add-results-pagination">
    <xsl:if test="$total-pages &gt; 1">
      <div class="pagination-centered">
        <ul class="pagination">
          <li class="arrow">
            <a>
              <xsl:if test="$current-page != 1">
                <xsl:attribute name="href"
                               select="kiln:query-string-from-sequence(
                                       $query-string-parameters,
                                       ('start'), ($start - $rows))" />
              </xsl:if>
              <xsl:text>«</xsl:text>
            </a>
          </li>
          <xsl:choose>
            <!-- Display up to seven pages at once. -->
            <xsl:when test="$total-pages &lt; 8">
              <xsl:for-each select="1 to $total-pages">
                <xsl:call-template name="make-pagination-list" />
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="first-page"
                            select="max(($current-page - 3, 1))" />
              <xsl:variable name="last-page"
                            select="min(($current-page + 3, $total-pages))" />
              <xsl:if test="$first-page &gt; 1">
                <xsl:call-template name="pagination-ellipsis" />
              </xsl:if>
              <xsl:for-each select="$first-page to $last-page">
                <xsl:call-template name="make-pagination-list" />
              </xsl:for-each>
              <xsl:if test="$last-page &lt; $total-pages">
                <xsl:call-template name="pagination-ellipsis" />
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
          <li class="arrow">
            <a>
              <xsl:if test="$current-page != $total-pages">
                <xsl:attribute name="href"
                               select="kiln:query-string-from-sequence(
                                       $query-string-parameters,
                                       ('start'), ($start + $rows))" />
              </xsl:if>
              <xsl:text>»</xsl:text>
            </a>
          </li>
        </ul>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="make-pagination-list">
    <li>
      <xsl:if test=". = $current-page">
        <xsl:attribute name="class" select="'current'" />
      </xsl:if>
      <a>
        <xsl:if test=". != $current-page">
          <xsl:attribute name="href"
                         select="kiln:query-string-from-sequence(
                                 $query-string-parameters, ('start'),
                                 ($rows * (. - 1)))" />
        </xsl:if>
        <xsl:value-of select="." />
      </a>
    </li>
  </xsl:template>

  <xsl:template name="pagination-ellipsis">
    <li class="unavailable">
      <a>…</a>
    </li>
  </xsl:template>

</xsl:stylesheet>
