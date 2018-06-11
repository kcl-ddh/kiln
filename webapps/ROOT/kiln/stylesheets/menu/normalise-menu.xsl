<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a menu document into a normalised form, with all
       hrefs expanded into full root relative paths. -->

  <xsl:import href="cocoon://_internal/template/xsl/stylesheets/defaults.xsl" />

  <xsl:import href="cocoon://_internal/url/reverse.xsl" />

  <xsl:param name="url" />
  <xsl:variable name="full-url" select="concat('/', $url)" />

  <xsl:template match="kiln:menu[not(@href)][not(@match)][not(@language_switch)]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:call-template name="make-full-href">
        <xsl:with-param name="attribute" select="*[1]/@href"/>
      </xsl:call-template>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@href">
    <xsl:choose>
      <xsl:when test="contains(., '://')">
        <xsl:copy-of select="." />
      </xsl:when>
      <xsl:when test="starts-with(., '//')">
        <xsl:copy-of select="." />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="make-full-href">
          <xsl:with-param name="attribute" select="."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Link target is the current URL with a different language
       code. Rather than be always correct but slow (by using
       introspection to look up the current URL to get the map:match
       ID and the path variables), just assume that the language code
       appears once and perform string manipulation on the current
       URL. -->
  <xsl:template match="@language_switch">
    <xsl:variable name="url-start"
                  select="substring-before($full-url,
                  concat('/', $language, '/'))"/>
    <xsl:variable name="url-end"
                 select="substring-after($full-url,
                 concat($url-start, '/', $language))"/>
    <xsl:choose>
      <xsl:when test=". = $language">
        <xsl:attribute name="delete" select="'delete'" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="href">
          <xsl:text>/</xsl:text>
          <xsl:value-of select="$url-start" />
          <xsl:value-of select="." />
          <xsl:value-of select="if (string($url-end)) then $url-end else '/'" />
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@match">
    <!-- Use the language code in @language if present; otherwise, the
         language supplied to the XSLT. This allows for a menu item to
         reference a URL in a different language. -->
    <xsl:variable name="language-code">
      <xsl:choose>
        <xsl:when test="../@language">
          <xsl:value-of select="../@language" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$language" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:attribute name="href">
      <xsl:value-of select="kiln:url-for-match(., tokenize(normalize-space(concat($language-code, ' ', ../@params)), '\s+'), 0)" />
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="make-full-href">
    <!-- $attribute is an @href attribute. -->
    <xsl:param name="attribute"/>
    <xsl:variable name="path">
      <xsl:choose>
        <xsl:when test="starts-with($attribute, '/')">
          <xsl:value-of select="$kiln:context-path"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="get-path">
            <xsl:with-param name="context" select="$attribute"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:attribute name="href">
      <xsl:value-of select="$path"/>
      <xsl:if test="not(starts-with($attribute, '/'))">
        <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:value-of select="$attribute"/>
    </xsl:attribute>
    <xsl:attribute name="path">
      <xsl:value-of select="$path"/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template name="get-path">
    <xsl:param name="context"/>
    <xsl:value-of select="$kiln:context-path"/>
    <xsl:for-each select="$context/ancestor-or-self::*[@root]">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="@root"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
