<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:map="http://apache.org/cocoon/sitemap/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a complete map:match into HTML. -->

  <xsl:template match="map:match" mode="kiln-visualise" priority="10">
    <xsl:variable name="id" select="generate-id(.)" />
    <div class="visualise-indent visualise-match" title="Sitemap file: {@kiln:sitemap}">
      <span class="visualise-dedent">
        <span class="switch" id="{$id}-switch"
              onclick="toggle('{$id}', '+', '−')">+</span>
        <xsl:call-template name="start-tag" />
      </span>
      <div id="{$id}" style="display: none;">
        <xsl:apply-templates mode="kiln-visualise" />
      </div>
      <xsl:call-template name="end-tag" />
    </div>
  </xsl:template>

  <xsl:template match="*" mode="kiln-visualise">
    <div class="visualise-indent">
      <xsl:call-template name="start-tag">
        <xsl:with-param name="empty" select="1" />
      </xsl:call-template>
    </div>
  </xsl:template>

  <xsl:template match="*[*]" mode="kiln-visualise">
    <div class="visualise-indent">
      <xsl:call-template name="start-tag" />
      <xsl:apply-templates mode="kiln-visualise" />
      <xsl:call-template name="end-tag" />
    </div>
  </xsl:template>

  <xsl:template name="attribute" mode="kiln-visualise">
    <xsl:param name="check-kiln-value" select="0" />
    <xsl:text> </xsl:text>
    <span class="visualise-attribute-name">
      <xsl:value-of select="name(.)" />
    </span>
    <xsl:text>="</xsl:text>
    <span class="visualise-attribute-value">
      <xsl:variable name="kiln-attr"
                  select="../@kiln:*[local-name()=local-name(.)]" />
      <xsl:if test="$check-kiln-value and $kiln-attr and not(. = $kiln-attr)">
        <xsl:attribute name="title" select="$kiln-attr" />
      </xsl:if>
      <xsl:value-of select="." />
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
    <xsl:apply-templates mode="kiln-visualise" select="@*" />
    <xsl:if test="$empty">
      <xsl:text> /</xsl:text>
    </xsl:if>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="@src | @value" mode="kiln-visualise">
    <xsl:call-template name="attribute">
      <xsl:with-param name="check-kiln-value" select="1" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="@kiln:*" mode="kiln-visualise" />

  <xsl:template match="@*" mode="kiln-visualise">
    <xsl:call-template name="attribute" />
  </xsl:template>

</xsl:stylesheet>
