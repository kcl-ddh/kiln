<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a TEI document's amendment-related markup into
       HTML. -->

  <!-- Additions, general -->
  <xsl:template match="tei:add">
    <xsl:choose>
      <xsl:when test="number($amendments)">
        <xsl:variable name="hand-title">
          <xsl:if test="@hand">
            <xsl:text> in the hand of </xsl:text>
            <xsl:value-of select="id(substring(@hand, 2))" />
          </xsl:if>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="@place">
            <ins>
              <xsl:attribute name="title">
                <xsl:value-of select="@place" />
                <xsl:text> addition</xsl:text>
                <xsl:value-of select="$hand-title" />
              </xsl:attribute>
              <xsl:apply-templates select="@*" />
              <xsl:call-template name="tei-assign-classes">
                <xsl:with-param name="html-element" select="'add'" />
                <xsl:with-param name="extra-classes"
                  select="concat('place-', @place)" />
              </xsl:call-template>
              <xsl:apply-templates select="node()" />
            </ins>
          </xsl:when>
          <xsl:otherwise>
            <ins>
              <xsl:attribute name="title">
                <xsl:text>addition</xsl:text>
                <xsl:value-of select="$hand-title" />
              </xsl:attribute>
              <xsl:apply-templates select="@*" />
              <xsl:apply-templates select="tei-assign-classes">
                <xsl:with-param name="html-element" select="'add'" />
              </xsl:apply-templates>
              <xsl:apply-templates select="node()" />
            </ins>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="node" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Additions, supralinear -->
  <xsl:template match="tei:add[@place='supralinear']">
    <xsl:choose>
      <xsl:when test="number($amendments)">
        <ins title="supralinear addition">
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="tei-assign-classes">
            <xsl:with-param name="html-element" select="'add'" />
          </xsl:call-template>
          <sup>
            <xsl:apply-templates select="node()" />
          </sup>
        </ins>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Additions, infralinear -->
  <xsl:template match="tei:add[@place='infralinear']">
    <ins title="infralinear addition">
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="'add'" />
      </xsl:call-template>
      <sub>
        <xsl:apply-templates select="node()" />
      </sub>
    </ins>
  </xsl:template>

  <!-- Deletions -->
  <xsl:template match="tei:del[text()|node()]">
    <xsl:if test="number($amendments)">
      <del title="deletion">
        <xsl:apply-templates select="@*" />
        <xsl:call-template name="tei-assign-classes" />
        <xsl:apply-templates />
      </del>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:del/@type">
    <xsl:attribute name="title">
      <xsl:value-of select="@type" />
    </xsl:attribute>
  </xsl:template>

  <!-- Sic -->
  <xsl:template match="tei:sic">
    <xsl:if test="number($corrections)">
      <span>
        <xsl:apply-templates select="@*" />
        <xsl:call-template name="tei-assign-classes" />
        <xsl:apply-templates select="node()" />
        <xsl:text> </xsl:text>
        <span class="tei sic-mark">
          <xsl:text>[sic</xsl:text>
          <xsl:variable name="corrected-text" select="../tei:corr" />
          <xsl:choose>
            <xsl:when test="$corrected-text = ''">
              <xsl:text>: </xsl:text>
              <span class="tei sic-none">
                <xsl:text>delete</xsl:text>
              </span>
            </xsl:when>
            <xsl:when test="$corrected-text">
              <xsl:text>: </xsl:text>
              <xsl:apply-templates mode="corrections" select="$corrected-text" />
            </xsl:when>
            <xsl:otherwise />
          </xsl:choose>
          <xsl:text>]</xsl:text>
        </span>
      </span>
    </xsl:if>
  </xsl:template>

  <!-- Corr -->
  <xsl:template match="tei:corr">
    <xsl:if test="not(number($corrections))">
      <span>
        <xsl:apply-templates select="@*" />
        <xsl:call-template name="tei-assign-classes" />
        <xsl:apply-templates select="node()" />
      </span>
    </xsl:if>
  </xsl:template>

  <!-- Corr, when being processed as the alternative to a displayed
       sic. -->
  <xsl:template match="tei:corr" mode="corrections">
    <xsl:apply-templates select="node()" />
  </xsl:template>

  <!-- Unclear, general -->
  <xsl:template match="tei:unclear">
    <xsl:choose>
      <xsl:when test="number($unclear)">
        <span>
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="tei-assign-classes" />
          <xsl:text>[</xsl:text>
          <span class="tei reason" lang="en">
            <xsl:text>unclear</xsl:text>
            <xsl:if test="@reason">
              <xsl:text> </xsl:text>
              <xsl:value-of select="@reason" />
            </xsl:if>
            <xsl:if test="normalize-space(.)">
              <xsl:text>: </xsl:text>
            </xsl:if>
          </span>
          <xsl:apply-templates select="node()" />
          <xsl:text>]</xsl:text>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Orig -->
  <xsl:template match="tei:orig">
    <xsl:if test="not(number($regularised))">
      <span>
        <!-- For now, just use a title attribute, though this assumes
             that the tei:reg does not contain meaningful markup. -->
        <xsl:attribute name="title">
          <xsl:apply-templates mode="regularised" select="../tei:reg" />
        </xsl:attribute>
        <xsl:apply-templates select="@*" />
        <xsl:call-template name="tei-assign-classes" />
        <xsl:apply-templates select="node()" />
      </span>
    </xsl:if>
  </xsl:template>

  <!-- Reg -->
  <xsl:template match="tei:reg">
    <xsl:if test="number($regularised)">
      <xsl:apply-templates select="node()" />
    </xsl:if>
  </xsl:template>

  <!-- Reg, when being processed as the alternative to a displayed
       orig. -->
  <xsl:template match="tei:reg" mode="regularised">
    <xsl:apply-templates select="node()" />
  </xsl:template>

  <!-- Abbr, general -->
  <xsl:template match="tei:abbr">
    <xsl:if test="not(number($regularised))">
      <abbr>
        <xsl:apply-templates select="@*" />
        <!-- Since HTML uses title for abbreviations, we can either
             just grab a string representation of the tei:expan, or
             hope that it doesn't contain meaningful markup and apply
             templates on it. -->
        <xsl:attribute name="title">
          <xsl:value-of select="../tei:expan" />
        </xsl:attribute>
        <xsl:call-template name="tei-assign-classes" />
        <xsl:apply-templates select="node()" />
      </abbr>
    </xsl:if>
  </xsl:template>

  <!-- Abbreviations, acronyms -->
  <xsl:template match="tei:abbr[@type='acronym']">
    <acronym>
      <xsl:apply-templates select="@*" />
      <!-- Since HTML uses title for abbreviations, we can either just
           grab a string representation of the tei:expan, or hope that
           it doesn't contain meaningful markup and apply templates on
           it. -->
      <xsl:attribute name="title">
        <xsl:value-of select="../tei:expan" />
      </xsl:attribute>
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="'abbr'" />
      </xsl:call-template>
      <xsl:apply-templates select="node()" />
    </acronym>
  </xsl:template>

  <!-- Expan -->
  <xsl:template match="tei:expan">
    <xsl:if test="number($regularised)">
      <xsl:apply-templates select="node()" />
    </xsl:if>
  </xsl:template>

  <!-- Gaps. -->
  <xsl:template match="tei:gap">
    <span lang="en">
      <xsl:apply-templates select="@*[not(local-name() = 'desc') and not(local-name() = 'reason')]" />
      <xsl:call-template name="tei-assign-classes" />
      <xsl:text>[</xsl:text>
      <span class="tei head"
            title="Material has been omitted from the transcription at this point.">
        <xsl:text>gap &#8212; </xsl:text>
      </span>
      <xsl:apply-templates select="@desc" />
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="@reason" />
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:gap/@desc">
    <span class="tei desc" lang="en">
      <xsl:text>omitted: </xsl:text>
      <xsl:value-of select="." />
    </span>
  </xsl:template>
  <xsl:template match="tei:gap/@reason">
    <span class="tei reason" lang="en">
      <xsl:text>reason: </xsl:text>
      <xsl:value-of select="." />
    </span>
  </xsl:template>

</xsl:stylesheet>
