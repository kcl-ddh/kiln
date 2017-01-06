<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a menu document into a normalised form, with all
       hrefs expanded into full root relative paths. -->

  <xsl:import href="cocoon://_internal/template/xsl/stylesheets/defaults.xsl" />

  <xsl:import href="cocoon://_internal/url/reverse.xsl" />

  <xsl:template match="kiln:menu[not(@href)][not(@match)][not(kiln:external)]">
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

  <xsl:template match="@match">
    <xsl:attribute name="href">
      <xsl:value-of select="kiln:url-for-match(., tokenize(../@params, '\s+'), 0)" />
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
