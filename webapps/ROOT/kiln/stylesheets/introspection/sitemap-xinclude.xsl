<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:map="http://apache.org/cocoon/sitemap/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Generate a single XML document containing a sitemap and all of
       the sitemaps mounted (recursively) from it, in a nested
       hierarchy. All references are made absolute (for cocoon: URLs)
       or root relative.

       Each mounted sitemaps are included as the child of the map:mount
       element that references it.

       Also supports mount tables. -->

  <xsl:param name="dir" />
  <xsl:param name="file" />
  <xsl:param name="uri_prefix" />

  <xsl:template match="map:generate | map:part | map:read | map:transform">
    <xsl:copy>
      <xsl:call-template name="add-expanded-src">
        <xsl:with-param name="src" select="@src" />
      </xsl:call-template>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="map:match[@type='mount-table']">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xi:include>
        <xsl:attribute name="href">
          <xsl:text>cocoon://_internal/introspection/mount-table/</xsl:text>
          <xsl:value-of select="$dir" />
          <xsl:value-of select="@pattern" />
        </xsl:attribute>
      </xi:include>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="map:match">
    <xsl:copy>
      <xsl:attribute name="kiln:pattern">
        <xsl:value-of select="$uri_prefix" />
        <xsl:value-of select="@pattern" />
      </xsl:attribute>
      <xsl:call-template name="add-regexp-pattern">
        <xsl:with-param name="pattern" select="concat($uri_prefix, @pattern)" />
      </xsl:call-template>
      <xsl:call-template name="add-pattern-groups">
        <xsl:with-param name="pattern" select="@pattern" />
      </xsl:call-template>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="map:mount">
    <xsl:copy>
      <xsl:call-template name="add-expanded-src">
        <xsl:with-param name="src" select="@src" />
      </xsl:call-template>
      <xsl:apply-templates select="@*|node()" />
      <xi:include>
        <xsl:attribute name="href">
          <xsl:text>cocoon://_internal/introspection/pipeline/</xsl:text>
          <xsl:value-of select="$dir" />
          <xsl:value-of select="@src" />
          <xsl:text>/</xsl:text>
          <xsl:value-of select="$uri_prefix" />
          <xsl:value-of select="@uri-prefix" />
        </xsl:attribute>
      </xi:include>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="map:sitemap">
    <xsl:copy>
      <xsl:attribute name="kiln:file">
        <xsl:call-template name="reduce-path">
          <xsl:with-param name="path" select="concat($dir, $file)" />
        </xsl:call-template>
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template name="add-expanded-src">
    <xsl:param name="src" />
    <xsl:if test="normalize-space(@src)">
      <xsl:attribute name="kiln:src">
        <xsl:choose>
          <xsl:when test="starts-with($src, 'cocoon://')">
            <xsl:value-of select="$src" />
          </xsl:when>
          <xsl:when test="starts-with($src, 'cocoon:/')">
            <xsl:text>cocoon://</xsl:text>
            <xsl:call-template name="reduce-path">
              <xsl:with-param name="path" select="concat($uri_prefix, substring-after($src, 'cocoon:/'))" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="starts-with($src, 'empty:')">
            <xsl:value-of select="$src" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="reduce-path">
              <xsl:with-param name="path" select="concat($dir, $src)" />
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="add-pattern-groups">
    <!-- Add numbered attributes for each wildcard in $pattern. -->
    <xsl:param name="pattern" />
    <!-- In order to avoid having an empty first group, that will
         break the count from position(), ensure that all text before
         the first wildcard is removed. -->
    <xsl:variable name="stripped-pattern">
      <xsl:value-of select="substring($pattern,
                            string-length(substring-before($pattern,
                            '*')) + 1)" />
    </xsl:variable>
    <xsl:for-each select="tokenize($stripped-pattern, '[^*]+')">
      <xsl:if test="normalize-space(.)">
        <xsl:attribute name="kiln:g{position()}">
          <xsl:choose>
            <xsl:when test=". = '**'">
              <xsl:text>FOO/BAR</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>BAZ</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="add-regexp-pattern">
    <xsl:param name="pattern" />
    <!-- Escape regular expression characters that should not be
         treated as such (anything except *). -->
    <xsl:variable name="escaped" select="replace($pattern,
                                         '[\-\|\^{}()?+.$\\\[\]]', '\\$0')" />
    <xsl:attribute name="kiln:regexp">
      <xsl:text>^</xsl:text>
      <xsl:value-of select="replace(replace($escaped, '\*\*', '(.+)'), '\*', '([^/]+)')" />
      <xsl:text>$</xsl:text>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="reduce-path">
    <!-- Reduce a root relative path containing "../" into a short
         form that does not contain such. -->
    <xsl:param name="path" />
    <xsl:variable name="elements" select="tokenize($path, '/')" />
    <xsl:variable name="indices" select="index-of($elements, '..')" />
    <xsl:choose>
      <xsl:when test="exists($indices)">
        <xsl:variable name="reduced-elements"
                      select="remove(remove($elements, $indices[1]-1), $indices[1]-1)" />
        <xsl:call-template name="reduce-path">
          <xsl:with-param name="path"
                          select="string-join($reduced-elements, '/')" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$path" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
