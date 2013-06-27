<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:xmg="http://www.cch.kcl.ac.uk/xmod/global/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="get-filter-query">
    <xsl:param name="remove-fq" />

    <xsl:for-each select="/aggregation/response/lst/lst[@name = 'params']/*[@name = 'fq']">
      <xsl:for-each select="node()">
        <xsl:variable name="fq" select="." />

        <xsl:if test="normalize-space($fq) != normalize-space($remove-fq)">
          <xsl:text>fq=</xsl:text>
          <xsl:value-of select="$fq" />
          <xsl:text>&amp;</xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="search-filters">
    <div class="btn-group">
      <xsl:choose>
        <xsl:when
            test="/aggregation/response/lst/lst[@name = 'params']/*[@name = 'fq']">
          <xsl:for-each
              select="/aggregation/response/lst/lst[@name = 'params']/*[@name = 'fq']">
            <a class="btn btn-small">Filters:</a>
            <xsl:for-each select="node()">
              <xsl:variable name="key" select="substring-after(., ':')" />

              <xsl:variable name="remove-fq">
                <xsl:call-template name="get-filter-query">
                  <xsl:with-param name="remove-fq" select="." />
                </xsl:call-template>
              </xsl:variable>

              <xsl:for-each
                  select="/aggregation/response//lst[@name = 'facet_fields']//int[substring-before(@name, '::') = $key]">
                <a class="btn btn-small" href="/search/{$remove-fq}/">
                  <xsl:value-of select="substring-before(ancestor::*[1]/@name, '_entity')" />
                  <xsl:text>: </xsl:text>
                  <xsl:value-of select="substring-after(@name, '::')" />
                  <i class="icon-remove" />
                </a>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <a class="btn btn-small">No filters</a>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>
</xsl:stylesheet>
