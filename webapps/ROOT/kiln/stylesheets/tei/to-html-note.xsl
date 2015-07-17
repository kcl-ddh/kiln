<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a TEI document's notes into HTML. -->

  <!-- Notes, without target -->
  <xsl:template match="tei:note">
    <div>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes" />
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="tei:note[not(@n)][not(@target)]">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @kiln:class, ' '), ' block ')">
        <div>
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="tei-assign-classes" />
          <xsl:if test="@resp">
            <p class="tei resp">
              <xsl:text>[Note added by </xsl:text>
              <xsl:apply-templates select="id(substring(@resp, 2))" />
              <xsl:text>:] </xsl:text>
            </p>
          </xsl:if>
          <xsl:apply-templates select="node()" />
        </div>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="tei-assign-classes" />
          <xsl:if test="@resp">
            <span class="tei resp">
              <xsl:text>[Note added by </xsl:text>
              <xsl:apply-templates select="id(substring(@resp, 2))" />
              <xsl:text>:] </xsl:text>
            </span>
          </xsl:if>
          <xsl:apply-templates select="node()" />
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:note[@n]">
    <xsl:variable name="extra-classes">
      <xsl:text>footnote</xsl:text>
      <xsl:if test="not(following-sibling::tei:*[1][local-name()='note'][@n])">
        <xsl:text> last</xsl:text>
      </xsl:if>
    </xsl:variable>
    <div>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="'note'" />
        <xsl:with-param name="extra-classes" select="$extra-classes" />
      </xsl:call-template>
      <!-- If the first element in the footnote is not a paragraph,
           then add in a paragraph with the reference back to the
           marker. -->
      <xsl:if test="local-name(child::*[1]) != 'p'">
        <p>
          <a href="#reference-to-{@xml:id}" title="back">
            <sup>
              <xsl:value-of select="@n" />
            </sup>
            <xsl:text> </xsl:text>
          </a>
        </p>
      </xsl:if>
      <xsl:apply-templates select="node()" />
      <xsl:if test="@resp">
        <p class="tei resp">
          <xsl:text>[Note added by </xsl:text>
          <xsl:apply-templates select="id(substring(@resp, 2))" />
          <xsl:text>]</xsl:text>
        </p>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="tei:note[@n]/tei:p[1]">
    <!-- Insert a reference back to the footnote marker if this
         paragraph is the first element in the footnote. -->
    <p>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes" />
      <xsl:if test="not(normalize-space(preceding-sibling::*))">
        <a href="#reference-to-{../@xml:id}" title="back">
          <sup>
            <xsl:value-of select="../@n" />
          </sup>
          <xsl:text> </xsl:text>
        </a>
      </xsl:if>
      <xsl:apply-templates select="node()" />
    </p>
  </xsl:template>

  <!-- Notes, with target -->
  <xsl:template match="tei:note[@target]">
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="substring(@target, 2)" />
      </xsl:attribute>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes" />
      <xsl:apply-templates />
    </a>
  </xsl:template>

</xsl:stylesheet>
