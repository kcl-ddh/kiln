<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:variable name="block-elements">
    <xsl:text>ab back body div front group head note opener p TEI teiHeader text</xsl:text>
  </xsl:variable>

  <xsl:template name="verbid-style">
    <style type="text/css">
      div.source div { margin-left: 2em; text-indent: -1em; }
      .element-name { color: blue; background: white; }
      .attribute-name { color: red; background: white; }
      .attribute-value { color: green; background: white; }
    </style>
  </xsl:template>

  <xsl:template name="id">
    <xsl:variable name="id">
      <xsl:choose>
	<xsl:when test="normalize-space(@id)">
	  <xsl:value-of select="@id" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="generate-id(.)" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <a name="{$id}"/>
  </xsl:template>

  <xsl:template match="*" mode="verb">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', $block-elements, ' '),
		      concat(' ', local-name(), ' '))">
	<div>
	  <xsl:call-template name="element-content"/>
	</div>
      </xsl:when>
      <xsl:otherwise>
	<xsl:call-template name="element-content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="element-content">
    <xsl:call-template name="id"/>
    <xsl:text>&lt;</xsl:text>
    <span class="element-name">
      <xsl:value-of select="name()"/>
    </span>
    <xsl:for-each select="@*">
      <xsl:text> </xsl:text>
      <span class="attribute-name">
	<xsl:value-of select="name()"/>
      </span>
      <xsl:text>="</xsl:text>
      <span class="attribute-value">
	<xsl:value-of select="."/>
      </span>
      <xsl:text>"</xsl:text>
    </xsl:for-each>
    <xsl:choose>
      <xsl:when test="node()">
	<xsl:text>&gt;</xsl:text>
	<xsl:apply-templates mode="verb"/>
	<xsl:text>&lt;/</xsl:text>
	<span class="element-name">
	  <xsl:value-of select="name()"/>
	</span>
	<xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>/&gt;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
