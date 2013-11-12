<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../defaults.xsl" />
  <xsl:include href="cocoon://_internal/url/reverse.xsl" />
  <xsl:include href="results-pagination.xsl" />

  <!-- query-string is escaped, but according to different rules than
       both XPath's encode-for-uri and escape-html-uri
       functions. encode-for-uri being the standard to compare
       against, the query string has the following characters not
       escaped: "," (there may be others) -->
  <xsl:param name="query-string" />
  <xsl:variable name="escaped-query-string">
    <xsl:value-of select="replace($query-string, ',', '%2C')" />
  </xsl:variable>

  <xsl:template match="int" mode="search-results">
    <!-- A facet's count. -->
    <xsl:variable name="fq">
      <xsl:text>&amp;fq=</xsl:text>
      <xsl:value-of select="../@name" />
      <xsl:text>:"</xsl:text>
      <xsl:value-of select="@name" />
      <xsl:text>"</xsl:text>
    </xsl:variable>
    <xsl:variable name="escaped-fq">
      <xsl:value-of select="substring-before($fq, '&quot;')" />
      <xsl:value-of select="encode-for-uri(substring-after($fq, ':'))" />
    </xsl:variable>
    <xsl:if test="not(contains($escaped-query-string, $escaped-fq))">
      <li>
        <a>
          <xsl:attribute name="href">
            <xsl:text>?</xsl:text>
            <xsl:value-of select="$query-string" />
            <xsl:value-of select="$fq" />
          </xsl:attribute>
          <xsl:value-of select="@name" />
        </a>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="." />
        <xsl:text>)</xsl:text>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template match="lst[@name='facet_fields']" mode="search-results">
    <xsl:if test="lst/int">
      <h3>Facets</h3>

      <div class="section-container accordion"
           data-section="accordion">
        <xsl:apply-templates mode="search-results" />
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="lst[@name='facet_fields]/lst"
                mode="search-results">
    <section>
      <p class="title" data-section-title="">
        <a href="#">
          <xsl:apply-templates mode="search-results" select="@name" />
        </a>
      </p>
      <div class="content" data-section-content="">
        <ul class="no-bullet">
          <xsl:apply-templates mode="search-results" />
        </ul>
      </div>
    </section>
  </xsl:template>

  <xsl:template match="lst[@name='facet_fields']/lst/@name"
                mode="search-results">
    <xsl:for-each select="tokenize(., '_')">
      <xsl:value-of select="upper-case(substring(., 1, 1))" />
      <xsl:value-of select="substring(., 2)" />
      <xsl:if test="not(position() = last())">
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="result/doc" mode="search-results">
    <li>
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="url-for-match">
            <xsl:with-param name="match-id" select="'local-tei-display-html'" />
            <xsl:with-param name="parameters"
                            select="(str[@name='document_id'])" />
          </xsl:call-template>
        </xsl:attribute>
        <xsl:value-of select="arr[@name='document_title']/str[1]" />
      </a>
    </li>
  </xsl:template>

  <xsl:template match="response/result" mode="search-results">
    <xsl:choose>
      <xsl:when test="number(@numFound) = 0">
        <h3>No results found</h3>
      </xsl:when>
      <xsl:when test="doc">
        <ul>
          <xsl:apply-templates mode="search-results" select="doc" />
        </ul>

        <xsl:call-template name="add-results-pagination" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[@name='fq']" mode="search-results">
    <h3>Current filters</h3>

    <ul>
      <xsl:choose>
        <xsl:when test="local-name(.) = 'str'">
          <xsl:call-template name="display-applied-facet" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="str">
            <xsl:call-template name="display-applied-facet" />
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
    </ul>
  </xsl:template>

  <xsl:template name="display-applied-facet">
    <xsl:variable name="fq">
      <!-- Match the fq parameter as it appears in the query
           string. -->
      <xsl:text>&amp;fq=</xsl:text>
      <xsl:value-of select="substring-before(., '&quot;')" />
      <xsl:value-of select="encode-for-uri(substring-after(., ':'))" />
    </xsl:variable>
    <li>
      <xsl:value-of select="replace(., '[^:]+:&quot;(.*)&quot;$', '$1')" />
      <xsl:text> (</xsl:text>
      <!-- Create a link to unapply the facet. -->
      <a>
        <xsl:attribute name="href">
          <xsl:text>?</xsl:text>
          <xsl:value-of select="replace($escaped-query-string, $fq, '')" />
        </xsl:attribute>
        <xsl:text>x</xsl:text>
      </a>
      <xsl:text>)</xsl:text>
    </li>
  </xsl:template>

  <xsl:template match="text()" mode="search-results" />

</xsl:stylesheet>
