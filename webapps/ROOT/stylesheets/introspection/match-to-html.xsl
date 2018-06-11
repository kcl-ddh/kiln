<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:map="http://apache.org/cocoon/sitemap/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a complete map:match into HTML. -->

  <xsl:template match="map:match" mode="introspection" priority="10">
    <xsl:variable name="id" select="generate-id(.)" />
    <xsl:variable name="is_expanded" select="ancestor::map:match" />
    <div class="visualise-indent visualise-match" title="Sitemap file: {@kiln:sitemap}">
      <span class="visualise-dedent">
        <span class="switch" id="{$id}-switch"
              onclick="toggle('{$id}', '+', '−')">
          <xsl:choose>
            <xsl:when test="$is_expanded">+</xsl:when>
            <xsl:otherwise>−</xsl:otherwise>
          </xsl:choose>
        </span>
        <xsl:call-template name="start-tag" />
      </span>
      <div id="{$id}">
        <xsl:if test="$is_expanded">
          <xsl:attribute name="style" select="'display: none;'" />
        </xsl:if>
        <xsl:apply-templates mode="introspection" />
      </div>
      <xsl:call-template name="end-tag" />
    </div>
  </xsl:template>

  <xsl:template match="*" mode="introspection">
    <div class="visualise-indent">
      <xsl:call-template name="start-tag">
        <xsl:with-param name="empty" select="1" />
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template match="*[*]" mode="introspection">
    <div class="visualise-indent">
      <xsl:call-template name="start-tag" />
      <xsl:apply-templates mode="introspection" />
      <xsl:call-template name="end-tag" />
    </div>
  </xsl:template>

  <xsl:template name="attribute">
    <xsl:param name="check-kiln-value" select="0" />
    <xsl:param name="link" select="''" />
    <xsl:text> </xsl:text>
    <span class="visualise-attribute-name">
      <xsl:value-of select="name(.)" />
    </span>
    <xsl:text>="</xsl:text>
    <span class="visualise-attribute-value">
      <xsl:variable name="kiln-attr"
                    select="../@kiln:*[local-name(current())=local-name(.)]" />
      <xsl:if test="$check-kiln-value and $kiln-attr and not(. = $kiln-attr)">
        <xsl:attribute name="title" select="$kiln-attr" />
      </xsl:if>
      <xsl:choose>
        <xsl:when test="normalize-space($link)">
          <a href="{$link}">
            <xsl:value-of select="." />
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="." />
        </xsl:otherwise>
      </xsl:choose>
    </span>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template name="end-tag">
    <span class="visualise-markup">&lt;/</span>
    <span class="visualise-element-name">
      <xsl:value-of select="name(.)" />
    </span>
    <span class="visualise-markup">&gt;</span>
  </xsl:template>

  <xsl:template name="start-tag">
    <xsl:param name="empty" select="0" />
    <span class="visualise-markup">&lt;</span>
    <span class="visualise-element-name">
      <xsl:value-of select="name(.)" />
    </span>
    <xsl:apply-templates mode="introspection" select="@*" />
    <xsl:if test="$empty">
      <xsl:text> /</xsl:text>
    </xsl:if>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="map:generate/@src" mode="introspection">
    <xsl:variable name="link">
      <xsl:choose>
        <xsl:when test="starts-with(../@kiln:src, 'assets/templates')">
          <xsl:value-of select="kiln:url-for-match(
            'local-admin-introspection-template-xslt',
            (substring-after(substring-before(../@kiln:src, '.xml'),
             'assets/templates/')), 0)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="attribute">
      <xsl:with-param name="check-kiln-value" select="1" />
      <xsl:with-param name="link" select="$link" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="map:transform/@src" mode="introspection">
    <xsl:variable name="link">
      <xsl:choose>
        <xsl:when test="not(starts-with(../@kiln:src, 'cocoon://'))">
          <xsl:text>../xslt/</xsl:text>
          <xsl:value-of select="../@kiln:src" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="attribute">
      <xsl:with-param name="check-kiln-value" select="1" />
      <xsl:with-param name="link" select="$link" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@pattern | @src | @value" mode="introspection">
    <xsl:call-template name="attribute">
      <xsl:with-param name="check-kiln-value" select="1" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@kiln:*" mode="introspection" />

  <xsl:template match="@*" mode="introspection">
    <xsl:call-template name="attribute" />
  </xsl:template>

</xsl:stylesheet>
