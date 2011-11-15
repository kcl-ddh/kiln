<xsl:stylesheet exclude-result-prefixes="xmtp"
                version="2.0"
                xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias" 
                xmlns:xmtp="http://www.cch.kcl.ac.uk/xmod/template/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a document that includes every template in the
       inheritance chain into a single template with the content
       merged up the chain. -->

  <xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>

  <xsl:template match="/">
    <axsl:stylesheet version="2.0"
                     xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:copy-of select="//xsl:import"/>
      <xsl:copy-of select="//xsl:include"/>
      <axsl:template match="/">
        <xsl:apply-templates/>
      </axsl:template>
    </axsl:stylesheet>
  </xsl:template>

  <xsl:template match="xmtp:block">
    <!-- Process the leaf instance of this named block (ie, the
         definition closest to the template being rendered, and
         consequently the last with its name in the XML). -->
    <xsl:apply-templates select="//xmtp:block[@name=current()/@name][not(following::xmtp:block[@name=current()/@name])]"
                         mode="render"/>
  </xsl:template>

  <!-- Render a block's content. -->
  <xsl:template match="xmtp:block" mode="render">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Render an attribute block. -->
  <xsl:template match="xmtp:block[@attribute]" mode="render">
    <axsl:attribute name="{@attribute}">
      <!-- Create a variable holding only the textual content of this
           block. This allows for the result to have whitespace
           correctly handled (there must be a space between each
           attribute value, and no starting or trailing
           whitespace). Further, it removes any unwanted repetitions
           of the markup created in this template. -->
      <xsl:variable name="att_value">
        <xsl:apply-templates/>
      </xsl:variable>
      <xsl:variable name="normalized_att_value">
        <xsl:for-each select="$att_value//text()">
          <xsl:value-of select="normalize-space(.)"/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="normalize-space($normalized_att_value)"/>
    </axsl:attribute>
  </xsl:template>

  <!-- Render the content of this block as defined in the inherited
       template. -->
  <xsl:template match="xmtp:super">
    <xsl:variable name="block-name" select="ancestor::xmtp:block[1]/@name"/>
    <xsl:apply-templates select="preceding::xmtp:block[@name=$block-name][1]"
                         mode="render"/>
  </xsl:template>

  <!-- Copy anything which is not template XML or XSLT import/include. -->
  <xsl:template match="xmtp:child"/>
  <xsl:template match="xmtp:*">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="xsl:import"/>
  <xsl:template match="xsl:include"/>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>