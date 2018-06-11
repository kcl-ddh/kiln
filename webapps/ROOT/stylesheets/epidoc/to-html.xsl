<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs h" version="2.0"
                xmlns:h="http://apache.org/cocoon/request/2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <xsl:import href="../../kiln/stylesheets/epidoc/start-edition.xsl"/>

  <xsl:param name="default-edition-type"/>
  <xsl:param name="default-edn-structure"/>
  <xsl:param name="default-external-app-style"/>
  <xsl:param name="default-internal-app-style"/>
  <xsl:param name="default-leiden-style"/>
  <xsl:param name="default-line-inc"/>
  <xsl:param name="default-verse-lines"/>

  <xsl:template match="/">
    <xsl:variable name="edition-type">
      <xsl:call-template name="merge-parameter">
        <xsl:with-param name="param-name" select="'edition-type'"/>
        <xsl:with-param name="variable" select="$default-edition-type"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="edn-structure">
      <xsl:call-template name="merge-parameter">
        <xsl:with-param name="param-name" select="'edn-structure'"/>
        <xsl:with-param name="variable" select="$default-edn-structure"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="external-app-style">
      <xsl:call-template name="merge-parameter">
        <xsl:with-param name="param-name" select="'external-app-style'"/>
        <xsl:with-param name="variable" select="$default-external-app-style"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="internal-app-style">
      <xsl:call-template name="merge-parameter">
        <xsl:with-param name="param-name" select="'internal-app-style'"/>
        <xsl:with-param name="variable" select="$default-internal-app-style"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="leiden-style">
      <xsl:call-template name="merge-parameter">
        <xsl:with-param name="param-name" select="'leiden-style'"/>
        <xsl:with-param name="variable" select="$default-leiden-style"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="line-inc">
      <xsl:call-template name="merge-parameter">
        <xsl:with-param name="param-name" select="'line-inc'"/>
        <xsl:with-param name="variable" select="$default-line-inc"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="verse-lines">
      <xsl:call-template name="merge-parameter">
        <xsl:with-param name="param-name" select="'verse-lines'"/>
        <xsl:with-param name="variable" select="$default-verse-lines"/>
      </xsl:call-template>
    </xsl:variable>

    <section>
      <xsl:for-each select="aggregation/tei:*">
        <xsl:choose>
          <xsl:when test="$edn-structure='default'">
            <xsl:call-template name="default-body-structure">
              <xsl:with-param name="parm-edition-type" select="$edition-type" tunnel="yes"/>
              <xsl:with-param name="parm-edn-structure" select="$edn-structure" tunnel="yes"/>
              <xsl:with-param name="parm-external-app-style" select="$external-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-internal-app-style" select="$internal-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-leiden-style" select="$leiden-style" tunnel="yes"/>
              <xsl:with-param name="parm-line-inc" select="$line-inc" tunnel="yes" as="xs:double"/>
              <xsl:with-param name="parm-verse-lines" select="$verse-lines" tunnel="yes"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$edn-structure='dol'">
            <xsl:call-template name="dol-body-structure">
              <xsl:with-param name="parm-edition-type" select="$edition-type" tunnel="yes"/>
              <xsl:with-param name="parm-edn-structure" select="$edn-structure" tunnel="yes"/>
              <xsl:with-param name="parm-external-app-style" select="$external-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-internal-app-style" select="$internal-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-leiden-style" select="$leiden-style" tunnel="yes"/>
              <xsl:with-param name="parm-line-inc" select="$line-inc" tunnel="yes" as="xs:double"/>
              <xsl:with-param name="parm-verse-lines" select="$verse-lines" tunnel="yes"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$edn-structure='edak'">
            <xsl:call-template name="edak-body-structure">
              <xsl:with-param name="parm-edition-type" select="$edition-type" tunnel="yes"/>
              <xsl:with-param name="parm-edn-structure" select="$edn-structure" tunnel="yes"/>
              <xsl:with-param name="parm-external-app-style" select="$external-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-internal-app-style" select="$internal-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-leiden-style" select="$leiden-style" tunnel="yes"/>
              <xsl:with-param name="parm-line-inc" select="$line-inc" tunnel="yes" as="xs:double"/>
              <xsl:with-param name="parm-verse-lines" select="$verse-lines" tunnel="yes"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$edn-structure='inslib'">
            <xsl:call-template name="inslib-body-structure">
              <xsl:with-param name="parm-edition-type" select="$edition-type" tunnel="yes"/>
              <xsl:with-param name="parm-edn-structure" select="$edn-structure" tunnel="yes"/>
              <xsl:with-param name="parm-external-app-style" select="$external-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-internal-app-style" select="$internal-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-leiden-style" select="$leiden-style" tunnel="yes"/>
              <xsl:with-param name="parm-line-inc" select="$line-inc" tunnel="yes" as="xs:double"/>
              <xsl:with-param name="parm-verse-lines" select="$verse-lines" tunnel="yes"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$edn-structure='iospe'">
            <xsl:call-template name="iospe-body-structure">
              <xsl:with-param name="parm-edition-type" select="$edition-type" tunnel="yes"/>
              <xsl:with-param name="parm-edn-structure" select="$edn-structure" tunnel="yes"/>
              <xsl:with-param name="parm-external-app-style" select="$external-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-internal-app-style" select="$internal-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-leiden-style" select="$leiden-style" tunnel="yes"/>
              <xsl:with-param name="parm-line-inc" select="$line-inc" tunnel="yes" as="xs:double"/>
              <xsl:with-param name="parm-verse-lines" select="$verse-lines" tunnel="yes"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="$edn-structure='spes'">
            <xsl:call-template name="spes-body-structure">
              <xsl:with-param name="parm-edition-type" select="$edition-type" tunnel="yes"/>
              <xsl:with-param name="parm-edn-structure" select="$edn-structure" tunnel="yes"/>
              <xsl:with-param name="parm-external-app-style" select="$external-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-internal-app-style" select="$internal-app-style" tunnel="yes"/>
              <xsl:with-param name="parm-leiden-style" select="$leiden-style" tunnel="yes"/>
              <xsl:with-param name="parm-line-inc" select="$line-inc" tunnel="yes" as="xs:double"/>
              <xsl:with-param name="parm-verse-lines" select="$verse-lines" tunnel="yes"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </section>
  </xsl:template>

  <xsl:template name="merge-parameter">
    <xsl:param name="param-name"/>
    <xsl:param name="variable"/>
    <xsl:choose>
      <xsl:when test="normalize-space(aggregation/h:request/h:requestParameters/h:parameter[@name=$param-name]/h:value)">
        <xsl:value-of select="normalize-space(aggregation/h:request/h:requestParameters/h:parameter[@name=$param-name]/h:value)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$variable"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
