<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:request="http://apache.org/cocoon/request/2.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../defaults.xsl" />
  <xsl:include href="cocoon://_internal/url/reverse.xsl" />

  <xsl:template match="request:request">
    <xsl:apply-templates select="request:requestParameters/request:parameter[@name='url']" />
  </xsl:template>

  <xsl:template match="request:parameter">
    <xsl:variable name="value">
      <xsl:if test="not(starts-with(request:value, '/'))">
        <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$kiln:mount-path and
                        starts-with(request:value, concat('/',
                        $kiln:mount-path))">
          <xsl:value-of select="substring-after(request:value, concat('/',
                                $kiln:mount-path, '/'))" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="request:value" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xi:include href="{kiln:url-for-match('kiln-introspection-match-url',
                      (substring-after($value, '/')), 1)}" />
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
