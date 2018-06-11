<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Output XML escaped to be suitable for inclusion as a string
       within other markup.

       Uses the mode "escape-xml". -->

  <xsl:template match="*" mode="escape-xml">
    <xsl:param name="depth" select="0" />
    <xsl:call-template name="escape-xml-indent">
      <xsl:with-param name="depth" select="$depth" />
    </xsl:call-template>
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name(.)" />
    <xsl:apply-templates mode="escape-xml" select="@*" />
    <xsl:text>&gt;</xsl:text>
    <xsl:if test="*">
      <xsl:text>
</xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="escape-xml">
      <xsl:with-param name="depth" select="$depth + 1" />
    </xsl:apply-templates>
    <xsl:if test="*">
      <xsl:call-template name="escape-xml-indent">
        <xsl:with-param name="depth" select="$depth" />
      </xsl:call-template>
    </xsl:if>
    <xsl:text>&lt;/</xsl:text>
    <xsl:value-of select="name(.)" />
    <xsl:text>&gt;
</xsl:text>
  </xsl:template>

  <xsl:template match="@*" mode="escape-xml">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name(.)" />
    <xsl:text>="</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template name="escape-xml-indent">
    <xsl:param name="depth" />
    <xsl:if test="$depth &gt; 0">
      <xsl:text>    </xsl:text>
      <xsl:call-template name="escape-xml-indent">
        <xsl:with-param name="depth" select="$depth - 1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
