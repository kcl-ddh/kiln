<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:import href="../../../stylesheets/defaults.xsl" />

  <!-- Large self-contained aspects of rendering are kept in
       individual files. -->
  <xsl:include href="to-html-amendment.xsl" />
  <xsl:include href="to-html-list.xsl" />
  <xsl:include href="to-html-note.xsl" />
  <xsl:include href="to-html-rend.xsl" />
  <xsl:include href="to-html-table.xsl" />
  <xsl:include href="to-html-teiheader.xsl" />

  <xsl:param name="amendments" select="1" />
  <xsl:param name="corrections" select="1" />
  <xsl:param name="page-numbers" select="1" />
  <xsl:param name="regularised" select="0" />
  <xsl:param name="unclear" select="1" />

  <!-- Generate divs for TEI sections. -->
  <xsl:template match="tei:group | tei:text | tei:floatingText |
                       tei:front | tei:body | tei:back | tei:div">
    <xsl:call-template name="tei-make-div" />
  </xsl:template>

  <!-- Div heading becomes HTML heading. -->
  <xsl:template match="tei:div/tei:head">
    <xsl:call-template name="tei-make-hx" />
  </xsl:template>

  <xsl:template match="tei:head">
    <xsl:call-template name="tei-make-p" />
  </xsl:template>

  <xsl:template match="tei:p | tei:ab">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @kiln:class, ' '), ' block ')">
        <xsl:call-template name="tei-make-div" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="tei-make-p" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:q | tei:quote">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @kiln:class, ' '), ' block ')">
        <blockquote>
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="tei-assign-classes" />
          <xsl:apply-templates select="node()" />
        </blockquote>
      </xsl:when>
      <xsl:otherwise>
        <q>
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="tei-assign-classes" />
          <xsl:apply-templates select="node()" />
        </q>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Letter elements. -->
  <xsl:template match="tei:opener">
    <xsl:call-template name="tei-make-div" />
  </xsl:template>
  <xsl:template match="tei:closer">
    <xsl:call-template name="tei-make-div" />
  </xsl:template>
  <xsl:template match="tei:dateline">
    <xsl:call-template name="tei-make-p" />
  </xsl:template>
  <xsl:template match="tei:salute">
    <xsl:call-template name="tei-make-p" />
  </xsl:template>
  <xsl:template match="tei:signed">
    <xsl:call-template name="tei-make-p" />
  </xsl:template>

  <!-- Poetry -->

  <!-- Line groups that contain other line groups -->
  <xsl:template match="tei:lg">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @kiln:class, ' '), ' block ')">
        <xsl:call-template name="tei-make-div" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="tei-make-p" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Line group headings -->
  <xsl:template match="tei:lg/tei:head">
    <xsl:call-template name="tei-make-span" />
    <br />
  </xsl:template>

  <!-- Lines -->
  <xsl:template match="tei:l" name="l">
    <xsl:call-template name="tei-make-span" />
    <xsl:if test="following-sibling::tei:l">
      <br />
    </xsl:if>
  </xsl:template>

  <!-- Index terms -->
  <xsl:template match="tei:index">
    <span>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="'index'" />
        <xsl:with-param name="extra-classes" select="'index-item'" />
      </xsl:call-template>
      <xsl:apply-templates select="node()" />
    </span>
  </xsl:template>

  <xsl:template match="tei:index/tei:term[preceding-sibling::tei:term]">
    <xsl:text>; </xsl:text>
    <xsl:apply-templates select="node()" />
  </xsl:template>

  <xsl:template match="tei:emph">
    <strong>
      <xsl:apply-templates />
    </strong>
  </xsl:template>

  <xsl:template match="tei:foreign">
    <xsl:call-template name="tei-make-span" />
  </xsl:template>

  <xsl:template match="tei:name[@key]|tei:rs[@key]">
    <xsl:call-template name="tei-make-span" />
  </xsl:template>

  <!-- References. -->
  <xsl:template match="tei:ref[starts-with(@target, '#')]">
    <xsl:variable name="target" select="id(substring(@target, 2))" />
    <xsl:call-template name="tei-make-ref-link">
      <xsl:with-param name="target" select="@target" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:ref">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @kiln:class, ' '), ' nested-link ')">
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="tei-make-ref-link">
          <xsl:with-param name="target" select="@target" />
          <xsl:with-param name="n" select="@n" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:seg">
    <xsl:call-template name="tei-make-span" />
  </xsl:template>

  <!-- Figures. -->

  <xsl:template match="tei:figure">
    <xsl:param name="nested-link" select="0" />
    <xsl:variable name="container-element">
      <xsl:choose>
        <xsl:when test="contains(concat(' ', @kiln:class, ' '), ' block ')">
          <xsl:text>div</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>span</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$container-element}">
      <xsl:attribute name="id">
        <xsl:value-of select="@xml:id" />
      </xsl:attribute>
      <xsl:call-template name="tei-assign-classes" />
      <xsl:variable name="root-id"
                    select="ancestor::tei:TEI/@xml:id | ancestor::tei:teiCorpus/@xml:id" />
      <img src="{$kiln:content-path}/images/{$root-id}/{tei:graphic/@url}">
        <xsl:apply-templates mode="tei-alt-text" select="." />
      </img>
      <xsl:apply-templates select="*" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:figure" mode="tei-alt-text">
    <xsl:attribute name="alt">
      <xsl:choose>
        <xsl:when test="normalize-space(tei:figDesc)">
          <xsl:value-of select="normalize-space(tei:figDesc)" />
        </xsl:when>
        <xsl:when test="normalize-space(tei:head)">
          <xsl:value-of select="normalize-space(tei:head)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:text />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="tei:figDesc" />

  <!-- Glyphs. -->
  <xsl:template match="tei:g">
    <xsl:variable name="root" select="ancestor::tei:TEI | ancestor::tei:teiCorpus" />
    <xsl:variable name="image-id" select="substring(@ref, 2)" />
    <xsl:variable name="glyph" select="ancestor::tei:TEI/tei:teiHeader/tei:encodingDesc/tei:charDecl/tei:glyph[@xml:id=$image-id]" />
    <xsl:variable name="url" select="$glyph/tei:graphic/@url" />
    <xsl:variable name="title" select="normalize-space($glyph/tei:glyphName)" />
    <xsl:variable name="alt" select="normalize-space(.)" />
    <xsl:choose>
      <xsl:when test="$url">
        <xsl:apply-templates select="@*" />
        <span class="tei glyph">
          <img alt="{$alt}" src="/etexts/{$root/@xml:id}/{$url}">
            <xsl:if test="$title">
              <xsl:attribute name="title">
                <xsl:value-of select="$title" />
              </xsl:attribute>
            </xsl:if>
          </img>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Anchors. -->
  <xsl:template match="tei:anchor|tei:milestone[@xml:id]">
    <a id="{@xml:id}" name="{@xml:id}" />
  </xsl:template>

  <!-- Page breaks. -->
  <xsl:template match="tei:pb">
    <xsl:choose>
      <xsl:when test="number($page-numbers)">
        <span class="tei pb" lang="en">
          <xsl:apply-templates select="@xml:id" />
          <xsl:variable name="page-label">
            <xsl:choose>
              <xsl:when test="normalize-space(@n)">
                <xsl:text>page </xsl:text>
                <xsl:value-of select="normalize-space(@n)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>page break</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="not(contains(concat(' ', @kiln:class, ' '), ' nested-link ')) and @xml:id">
              <a class="tei pb" href="#{@xml:id}" title="page break">
                <xsl:value-of select="$page-label" />
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$page-label" />
            </xsl:otherwise>
          </xsl:choose>
        </span>
      </xsl:when>
      <xsl:when test="@xml:id">
        <span class="tei pb" id="{@xml:id}" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Line breaks. -->
  <xsl:template match="tei:lb">
    <br />
  </xsl:template>

  <xsl:template match="tei:*">
    <xsl:choose>
      <xsl:when test="@rend">
        <xsl:call-template name="tei-make-span" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="i18n:*|@i18n:*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@xml:id">
    <xsl:attribute name="id">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@xml:lang">
    <xsl:attribute name="lang">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@*" />

  <!-- Named templates. -->

  <xsl:template name="tei-assign-classes">
    <xsl:param name="node" select="." />
    <xsl:param name="html-element" select="''" />
    <xsl:param name="extra-classes" select="''" />
    <xsl:variable name="classes">
      <xsl:if test="$html-element != local-name($node)">
        <xsl:value-of select="local-name($node)" />
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="normalize-space($node/@type)">
        <xsl:value-of select="normalize-space($node/@type)" />
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="$node/self::tei:head and $node/parent::tei:figure">
        <xsl:text>figurehead </xsl:text>
      </xsl:if>
      <xsl:if test="$node/self::tei:note[@place]">
        <xsl:text>note-float </xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="rend-class" select="$node/@rend" />
      <xsl:value-of select="$extra-classes" />
    </xsl:variable>
    <xsl:variable name="actual-classes" select="normalize-space($classes)" />
    <xsl:if test="$actual-classes">
      <xsl:attribute name="class">
        <xsl:text>tei </xsl:text>
        <xsl:value-of select="$actual-classes" />
      </xsl:attribute>
    </xsl:if>
    <xsl:variable name="styles">
      <xsl:apply-templates mode="rend-style" select="$node/@rend" />
    </xsl:variable>
    <xsl:variable name="actual-styles" select="normalize-space($styles)" />
    <xsl:if test="$actual-styles">
      <xsl:attribute name="style">
        <xsl:value-of select="$actual-styles" />
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template name="tei-generate-heading-level">
    <!-- Get the level of the heading, based on how many div ancestors
         the head has. -->
    <xsl:variable name="x">
      <!-- HTML heading elements only go up to 6. Therefore, change
           any deeper level head elements into h6 elements. -->
      <xsl:value-of select="count(ancestor::tei:div)" />
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$x > 5">
        <xsl:value-of select="6" />
      </xsl:when>
      <xsl:otherwise>
        <!-- Add one to the value because the whole text is not
             enclosed in a div. -->
        <xsl:value-of select="$x+1" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="tei-make-div">
    <div>
      <xsl:apply-templates select="@*" />
      <xsl:if test="not(@xml:lang) and ancestor::*[@xml:lang]">
        <xsl:attribute name="lang">
          <xsl:value-of select="ancestor::*[@xml:lang][1]/@xml:lang" />
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="'div'" />
      </xsl:call-template>
      <xsl:call-template name="tei-make-run-in-heading" />
      <xsl:apply-templates select="node()" />
    </div>
  </xsl:template>

  <!-- Convert current element to an HTML h?. -->
  <xsl:template name="tei-make-hx">
    <xsl:variable name="hx">
      <xsl:call-template name="tei-generate-heading-level" />
    </xsl:variable>
    <xsl:element name="h{$hx}">
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="'head'" />
      </xsl:call-template>
      <xsl:apply-templates select="node()" />
    </xsl:element>
  </xsl:template>

  <xsl:template name="tei-make-p">
    <p>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes">
        <xsl:with-param name="html-element" select="'p'" />
      </xsl:call-template>
      <xsl:call-template name="tei-make-run-in-heading" />
      <xsl:apply-templates select="node()" />
    </p>
  </xsl:template>

  <xsl:template name="tei-make-ref-link">
    <xsl:param name="target" />
    <xsl:param name="title" select="''" />
    <xsl:param name="n" select="''" />
    <xsl:variable name="link">
      <a href="{$target}">
        <xsl:apply-templates select="@*" />
        <xsl:if test="normalize-space($title)">
          <xsl:attribute name="title">
            <xsl:value-of select="$title" />
          </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="tei-assign-classes">
          <xsl:with-param name="html-element" select="'ref'" />
        </xsl:call-template>
        <xsl:apply-templates select="node()" />
      </a>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="parent::tei:cit and not(ancestor::tei:p)">
        <p class="tei cite">
          <xsl:copy-of select="$link" />
        </p>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$link" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Add a run-in heading if appropriate. -->
  <xsl:template name="tei-make-run-in-heading">
    <xsl:variable name="run-in-heading"
                  select="preceding-sibling::*[1]/self::tei:head[contains(@rend, 'run-in')]" />
    <xsl:if test="$run-in-heading">
      <xsl:variable name="hx">
        <xsl:call-template name="tei-generate-heading-level" />
      </xsl:variable>
      <span>
        <xsl:call-template name="tei-assign-classes">
          <xsl:with-param name="node" select="$run-in-heading" />
          <xsl:with-param name="html-element" select="'head'" />
          <xsl:with-param name="extra-classes" select="concat('h', $hx)" />
        </xsl:call-template>
        <xsl:apply-templates select="$run-in-heading/node()" />
        <xsl:text> </xsl:text>
      </span>
    </xsl:if>
  </xsl:template>

  <xsl:template name="tei-make-span">
    <span>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="tei-assign-classes" />
      <xsl:apply-templates select="node()" />
    </span>
  </xsl:template>

</xsl:stylesheet>
