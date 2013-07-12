<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:request="http://apache.org/cocoon/request/2.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../defaults.xsl" />

  <xsl:template match="/">
    <aggregation>
      <xsl:apply-templates select="//request:parameter[@name='url']" />
    </aggregation>
  </xsl:template>

  <xsl:template match="request:parameter">
    <xsl:variable name="value">
      <xsl:choose>
        <xsl:when test="$kiln:mount-path and
                        starts-with(request:value, concat('/',
                        $kiln:mount-path))">
          <xsl:value-of select="substring-after(request:value, concat('/',
                                $kiln:mount-path))" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="request:value" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xi:include>
      <xsl:attribute name="href">
        <xsl:text>cocoon://_internal/visualise/url</xsl:text>
        <xsl:value-of select="$value" />
      </xsl:attribute>
    </xi:include>
  </xsl:template>

</xsl:stylesheet>
