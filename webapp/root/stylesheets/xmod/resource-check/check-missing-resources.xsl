<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:dir="http://apache.org/cocoon/directory/2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform an aggregated list of files and list of file
       references into a list of file references that do not have a
       corresponding file.
       
       Also report on any mismatches between values for attributes
       that exist on both the file reference and the referenced
       file. -->

  <xsl:template match="/aggregation">
    <report>
      <missing_files>
        <xsl:apply-templates select="referring_file" mode="missing"/>
      </missing_files>
      <mismatched_files>
        <xsl:apply-templates select="referring_file" mode="mismatched"/>
      </mismatched_files>
    </report>
  </xsl:template>

  <xsl:template match="referring_file" mode="missing">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates mode="missing"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="missing">
    <xsl:if test="not(/aggregation/files/file[@path=current()/@path])">
      <file path="{@path}"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="referring_file" mode="mismatched">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates mode="mismatched"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*" mode="mismatched">
    <xsl:variable name="referenced-file"
                  select="/aggregation/files/file[@path=current()/@path]"/>
    <xsl:variable name="mismatched-attributes">
      <xsl:apply-templates select="@*" mode="mismatched">
        <xsl:with-param name="referenced-file" select="$referenced-file"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="normalize-space($mismatched-attributes)">
      <reference path="{@path}">
        <xsl:attribute name="attributes">
          <xsl:value-of select="normalize-space($mismatched-attributes)"/>
        </xsl:attribute>
      </reference>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*" mode="mismatched">
    <xsl:param name="referenced-file"/>
    <xsl:variable name="name" select="local-name()"/>
    <xsl:variable name="paired-attribute" select="$referenced-file/@*[local-name()=$name]"/>
    <xsl:if test="$paired-attribute and $paired-attribute != .">
      <xsl:value-of select="$name"/>
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>