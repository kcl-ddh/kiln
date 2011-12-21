<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
  xmlns:nzetc="http://www.nzetc.org/structure"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="create-entity-links" select="'false'" />
  <xsl:param name="pagenumbers" select="1" />
  <xsl:param name="linebreaks" select="1" />
  <xsl:param name="amendments" select="1" />
  <xsl:param name="corrections" select="1" />
  <xsl:param name="unclear" select="1" />
  <xsl:param name="regularised" select="0" />
  <xsl:param name="full-size-images" select="0" />

  <xsl:key match="tei:*" name="corresp" use="@corresp" />

  <!-- Generate divs for TEI sections. -->
  <xsl:template
    match="tei:group|tei:text|tei:floatingText|tei:front|tei:body|tei:back|tei:div">
    <xsl:call-template name="make-div" />
  </xsl:template>

  <!-- Headings. -->

  <!-- Div heading becomes HTML heading. -->
  <xsl:template match="tei:div/tei:head">
    <xsl:call-template name="make-hx" />
  </xsl:template>

  <xsl:template match="tei:head">
    <xsl:call-template name="make-p" />
  </xsl:template>

  <xsl:template match="tei:p">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @nzetc:class, ' '), ' block ')">
        <xsl:call-template name="make-div" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="make-p" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:q|tei:quote">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @nzetc:class, ' '), ' block ')">
        <blockquote>
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="assign-classes" />
          <xsl:apply-templates select="node()" />
        </blockquote>
      </xsl:when>
      <xsl:otherwise>
        <q>
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="assign-classes" />
          <xsl:apply-templates select="node()" />
        </q>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Letter elements. -->
  <xsl:template match="tei:opener">
    <xsl:call-template name="make-div" />
  </xsl:template>
  <xsl:template match="tei:closer">
    <xsl:call-template name="make-div" />
  </xsl:template>
  <xsl:template match="tei:dateline">
    <xsl:call-template name="make-p" />
  </xsl:template>
  <xsl:template match="tei:salute">
    <xsl:call-template name="make-p" />
  </xsl:template>
  <xsl:template match="tei:signed">
    <xsl:call-template name="make-p" />
  </xsl:template>

  <xsl:template match="tei:titlePart|tei:docImprint|tei:imprimatur">
    <xsl:call-template name="make-p" />
  </xsl:template>

  <xsl:template match="tei:byline">
    <xsl:call-template name="make-p" />
  </xsl:template>

  <xsl:template match="tei:epigraph|tei:argument">
    <xsl:call-template name="make-div" />
  </xsl:template>

  <!-- Bibls. -->

  <xsl:template match="tei:listBibl[tei:bibl/@n]">
    <table>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes" />
      <xsl:apply-templates mode="labelled-bibl" select="tei:bibl" />
    </table>
  </xsl:template>
  <xsl:template match="tei:bibl">
    <xsl:call-template name="make-p" />
  </xsl:template>
  <xsl:template
    match="tei:p[not(contains(concat(' ', @nzetc:class, ' '), ' block '))]//tei:bibl">
    <xsl:apply-templates />
  </xsl:template>
  <xsl:template match="tei:bibl" mode="labelled-bibl">
    <tr>
      <td>
        <xsl:value-of select="@n" />
      </td>
      <td>
        <xsl:apply-templates select="@*" />
        <xsl:call-template name="assign-classes" />
        <xsl:apply-templates select="node()" />
      </td>
    </tr>
  </xsl:template>

  <!-- Tables. -->

  <xsl:template match="tei:table">
    <table>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes" />
      <xsl:apply-templates select="node()" />
    </table>
  </xsl:template>

  <xsl:template match="tei:table/tei:head">
    <caption>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes" />
      <xsl:apply-templates select="node()" />
    </caption>
  </xsl:template>

  <xsl:template match="tei:row">
    <tr>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes" />
      <xsl:apply-templates select="node()" />
    </tr>
  </xsl:template>

  <xsl:template match="tei:cell">
    <xsl:variable name="cell-element">
      <xsl:choose>
        <xsl:when test="@role='label' or parent::tei:row/@role='label'">
          <xsl:text>th</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>td</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$cell-element}">
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes">
        <xsl:with-param name="html-element" select="'cell'" />
      </xsl:call-template>
      <xsl:apply-templates select="node()" />
    </xsl:element>
  </xsl:template>

  <!-- Lists. -->

  <xsl:template match="tei:list">
    <xsl:apply-templates select="tei:head" />
    <!-- Determine whether ordered or unordered list -->
    <xsl:variable name="listtype">
      <xsl:choose>
        <xsl:when test="@type = 'ordered'">
          <xsl:value-of select="'ol'" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'ul'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$listtype}">
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes">
        <xsl:with-param name="html-element" select="local-name()" />
      </xsl:call-template>
      <xsl:apply-templates select="tei:item" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:list[tei:label]">
    <xsl:apply-templates select="tei:head" />
    <table>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes" />
      <xsl:apply-templates select="tei:item" />
    </table>
  </xsl:template>

  <xsl:template match="tei:item">
    <li>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes">
        <xsl:with-param name="html-element" select="local-name()" />
      </xsl:call-template>
      <xsl:apply-templates select="node()" />
    </li>
  </xsl:template>

  <xsl:template match="tei:list[tei:label]/tei:item">
    <tr>
      <xsl:apply-templates select="preceding-sibling::tei:label[1]" />
      <td>
        <xsl:apply-templates select="@*" />
        <xsl:call-template name="assign-classes" />
        <xsl:apply-templates select="node()" />
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="tei:list/tei:label">
    <td>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes" />
      <xsl:apply-templates select="node()" />
    </td>
  </xsl:template>

  <!-- Poetry -->

  <!-- Line groups that contain other line groups -->
  <xsl:template match="tei:lg">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @nzetc:class, ' '), ' block ')">
        <xsl:call-template name="make-div" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="make-p" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Line group headings -->
  <xsl:template match="tei:lg/tei:head">
    <xsl:call-template name="make-span" />
    <br />
  </xsl:template>

  <!-- Lines -->
  <xsl:template match="tei:l" name="l">
    <xsl:call-template name="make-span" />
    <xsl:if test="following-sibling::tei:l">
      <br />
    </xsl:if>
  </xsl:template>

  <!-- Notes. -->

  <!-- Notes, without target -->
  <xsl:template match="tei:note">
    <div>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes" />
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="tei:note[not(@n)][not(@target)]">
    <xsl:choose>
      <xsl:when test="contains(concat(' ', @nzetc:class, ' '), ' block ')">
        <div>
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="assign-classes" />
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
          <xsl:if test="@resp">
            <span class="tei resp">
              <xsl:text>[Note added by </xsl:text>
              <xsl:apply-templates select="id(substring(@resp, 2))" />
              <xsl:text>:] </xsl:text>
            </span>
          </xsl:if>
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="assign-classes" />
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
      <xsl:call-template name="assign-classes">
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
      <xsl:call-template name="assign-classes" />
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
      <xsl:call-template name="assign-classes" />
      <xsl:apply-templates />
    </a>
  </xsl:template>

  <!-- Index terms -->
  <xsl:template match="tei:index">
    <span>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes">
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

  <xsl:template match="tei:foreign">
    <xsl:call-template name="make-span" />
  </xsl:template>

  <xsl:template match="tei:name[@key]|tei:rs[@key]">
    <xsl:choose>
      <xsl:when test="$create-entity-links='true'">
        <a href="{@key}.html">
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="assign-classes">
            <xsl:with-param name="extra-classes">
              <xsl:text>topic-ref </xsl:text>
              <xsl:choose>
                <xsl:when test="ancestor::tei:bibl">
                  <xsl:text>citation </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>mention </xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:apply-templates select="node()" />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="make-span" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template
    match="tei:name[@key][contains(concat(' ', @nzetc:class, ' '), ' nested-link ')] |
                       tei:rs[@key][contains(concat(' ', @nzetc:class, ' '), ' nested-link ')]">
    <xsl:call-template name="make-span" />
  </xsl:template>

  <!-- References. -->
  <xsl:template match="tei:ref[starts-with(@target, '#')]">
    <xsl:variable name="target" select="id(substring(@target, 2))" />
    <xsl:variable name="target-id">
      <xsl:choose>
        <xsl:when test="$create-entity-links='true'">
          <xsl:choose>
            <xsl:when test="$target/@nzetc:id">
              <xsl:text>#</xsl:text>
              <xsl:value-of select="$target/@nzetc:id" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@target" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="link-title">
      <xsl:choose>
        <xsl:when test="$target/self::tei:note">
          <xsl:variable name="excerpt">
            <xsl:apply-templates mode="hyperlink-title" select="$target" />
          </xsl:variable>
          <xsl:if test="$excerpt != .">
            <xsl:value-of select="normalize-space($excerpt)" />
          </xsl:if>
        </xsl:when>
        <xsl:when test="$target/self::tei:div or $target/self::tei:figure">
          <xsl:variable name="excerpt">
            <xsl:apply-templates mode="hyperlink-title"
              select="$target/tei:head[1]" />
          </xsl:variable>
          <xsl:if test="$excerpt != .">
            <xsl:value-of select="normalize-space($excerpt)" />
          </xsl:if>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="make-ref-link">
      <xsl:with-param name="target" select="$target-id" />
      <xsl:with-param name="title" select="$link-title" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tei:ref">
    <xsl:call-template name="make-ref-link">
      <xsl:with-param name="target" select="@target" />
      <xsl:with-param name="n" select="@n" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template
    match="tei:ref[contains(concat(' ', @nzetc:class, ' '), ' nested-link ')]"
    priority="1000">
    <xsl:apply-templates select="node()" />
  </xsl:template>

  <xsl:template name="make-ref-link">
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

        <xsl:call-template name="assign-classes">
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

  <xsl:template match="tei:seg">
    <xsl:call-template name="make-span" />
  </xsl:template>

  <!-- Figures. -->

  <xsl:template match="tei:figure">
    <xsl:param name="nested-link" select="0" />
    <xsl:variable name="figure-id">
      <xsl:choose>
        <xsl:when test="$create-entity-links = 'true' and @nzetc:id">
          <xsl:value-of select="@nzetc:id" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@xml:id" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="is-page-facsimile" select="ancestor::tei:teiHeader" />
    <xsl:variable name="container-element">
      <xsl:choose>
        <xsl:when test="contains(concat(' ', @nzetc:class, ' '), ' block ')">
          <xsl:text>div</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>span</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$container-element}">
      <xsl:attribute name="id">
        <xsl:value-of select="$figure-id" />
      </xsl:attribute>
      <xsl:call-template name="assign-classes">
        <xsl:with-param name="extra-classes">
          <xsl:if test="$is-page-facsimile">
            <xsl:text>page-facsimile</xsl:text>
          </xsl:if>
        </xsl:with-param>
      </xsl:call-template>
      <!-- Use a scaled-down version of the image, with a link to the
           full-size image. -->
      <xsl:variable name="root-id"
        select="/tei:TEI/@xml:id | /tei:teiCorpus/@xml:id" />
      <xsl:variable name="src">
        <xsl:text>/etexts/</xsl:text>
        <xsl:value-of select="$root-id" />
        <xsl:text>/</xsl:text>
        <xsl:value-of select="tei:graphic/@url" />
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$full-size-images">
          <a class="tei figure" href="{$src}">
            <img src="{$src}">
              <xsl:apply-templates mode="alt-text" select="." />
            </img>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="scale">
            <xsl:choose>
              <xsl:when test="$is-page-facsimile">
                <xsl:text>w110</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>h280</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$nested-link">
              <img
                src="/etexts/{$root-id}/{substring-before(tei:graphic/@url, '.')}({$scale}).{substring-after(tei:graphic/@url, '.')}">
                <xsl:apply-templates mode="alt-text" select="." />
              </img>
            </xsl:when>
            <xsl:otherwise>
              <a>
                <xsl:attribute name="href">
                  <xsl:choose>
                    <xsl:when test="$is-page-facsimile">
                      <xsl:value-of select="$src" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="@nzetc:id" />
                      <xsl:text>.html</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <img
                  src="/etexts/{$root-id}/{substring-before(tei:graphic/@url, '.')}({$scale}).{substring-after(tei:graphic/@url, '.')}">
                  <xsl:apply-templates mode="alt-text" select="." />
                </img>
              </a>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when
          test="@type='advert' or @n='advert' or @type='adverts' or @n='adverts' or
                        ancestor::tei:div[1][@type='advert' or @n='advert' or @type='adverts' or @n='adverts']">
          <xsl:apply-templates select="tei:head" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="*" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:figure" mode="alt-text">
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
    <xsl:variable name="root" select="/tei:TEI | /tei:teiCorpus" />
    <xsl:variable name="image-id" select="substring(@ref, 2)" />
    <xsl:variable name="glyph"
      select="/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:charDecl/tei:glyph[@xml:id=$image-id]" />
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
      <xsl:when test="number($pagenumbers)">
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
            <xsl:when
              test="not(contains(concat(' ', @nzetc:class, ' '), ' nested-link ')) and @xml:id">
              <a class="tei pb" href="#{@xml:id}" title="page break">
                <xsl:value-of select="$page-label" />
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$page-label" />
            </xsl:otherwise>
          </xsl:choose>
        </span>
        <xsl:if test="@corresp">
          <xsl:variable name="figure-id" select="substring(@corresp, 2)" />
          <xsl:apply-templates
            select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:notesStmt/tei:note[@xml:id='page-images']//tei:figure[@xml:id=$figure-id]">
            <xsl:with-param name="nested-link"
              select="contains(concat(' ', @nzetc:class, ' '), ' nested-link ')"
             />
          </xsl:apply-templates>
        </xsl:if>
      </xsl:when>
      <xsl:when test="@xml:id">
        <span class="tei pb" id="{@xml:id}" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Line breaks. -->
  <xsl:template match="tei:lb">
    <xsl:choose>
      <xsl:when test="number($linebreaks) or ancestor::tei:head">
        <br />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Amendments. -->

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
              <xsl:call-template name="assign-classes">
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
              <xsl:apply-templates select="assign-classes">
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
          <xsl:call-template name="assign-classes">
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
      <xsl:call-template name="assign-classes">
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
        <xsl:call-template name="assign-classes" />
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
        <xsl:call-template name="assign-classes" />
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
              <xsl:apply-templates mode="corrections" select="$corrected-text"
               />
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
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes" />
      <xsl:apply-templates select="node()" />
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
          <xsl:call-template name="assign-classes" />
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
        <xsl:call-template name="assign-classes" />
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
        <xsl:call-template name="assign-classes" />
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
      <xsl:call-template name="assign-classes">
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
      <xsl:apply-templates
        select="@*[not(local-name() = 'desc') and not(local-name() = 'reason')]" />
      <xsl:call-template name="assign-classes" />
      <xsl:text>[</xsl:text>
      <span class="tei head"
        title="Material has been omitted from the transcription at this point."
        >gap &#8212; </span>
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

  <!-- Highlighted text. -->

  <!-- Generic (CSS-based) -->
  <xsl:template match="tei:hi[@rend]">
    <xsl:variable name="class">
      <xsl:apply-templates mode="rend-class" select="@rend" />
    </xsl:variable>
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="normalize-space($class)" />
      </xsl:attribute>
      <xsl:apply-templates />
    </span>
  </xsl:template>

  <!-- Italics -->
  <xsl:template match="tei:hi[@rend='i']">
    <i>
      <xsl:apply-templates />
    </i>
  </xsl:template>

  <!-- Bold -->
  <xsl:template match="tei:hi[@rend='b']">
    <b>
      <xsl:apply-templates />
    </b>
  </xsl:template>

  <!-- Subscript -->
  <xsl:template match="tei:hi[@rend='sub']">
    <sub>
      <xsl:apply-templates />
    </sub>
  </xsl:template>

  <!-- Superscript -->
  <xsl:template match="tei:hi[@rend='sup']">
    <sup>
      <xsl:apply-templates />
    </sup>
  </xsl:template>

  <xsl:template name="make-div">
    <div>
      <xsl:apply-templates select="@*" />
      <xsl:if test="not(@xml:lang)">
        <xsl:attribute name="lang">
          <xsl:value-of select="ancestor::*[@xml:lang][1]/@xml:lang" />
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="assign-classes">
        <xsl:with-param name="html-element" select="'div'" />
      </xsl:call-template>
      <xsl:call-template name="make-run-in-heading" />
      <xsl:apply-templates select="node()" />
    </div>
  </xsl:template>

  <xsl:template name="make-p">
    <p>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes">
        <xsl:with-param name="html-element" select="'p'" />
      </xsl:call-template>
      <xsl:call-template name="make-run-in-heading" />
      <xsl:apply-templates select="node()" />
    </p>
  </xsl:template>

  <!-- Add a run-in heading if appropriate. -->
  <xsl:template name="make-run-in-heading">
    <xsl:variable name="run-in-heading"
      select="preceding-sibling::*[1]/self::tei:head[contains(@rend, 'run-in')]" />
    <xsl:if test="$run-in-heading">
      <xsl:variable name="hx">
        <xsl:call-template name="generate-heading-level" />
      </xsl:variable>
      <span>
        <xsl:call-template name="assign-classes">
          <xsl:with-param name="node" select="$run-in-heading" />
          <xsl:with-param name="html-element" select="'head'" />
          <xsl:with-param name="extra-classes" select="concat('h', $hx)" />
        </xsl:call-template>
        <xsl:apply-templates select="$run-in-heading/node()" />
        <xsl:text> </xsl:text>
      </span>
    </xsl:if>
  </xsl:template>

  <!-- Convert current element to an HTML h?. -->
  <xsl:template name="make-hx">
    <xsl:variable name="hx">
      <xsl:call-template name="generate-heading-level" />
    </xsl:variable>
    <xsl:element name="h{$hx}">
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes">
        <xsl:with-param name="html-element" select="'head'" />
      </xsl:call-template>
      <xsl:apply-templates select="node()" />
    </xsl:element>
  </xsl:template>

  <xsl:template name="generate-heading-level">
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

  <xsl:template name="make-span">
    <span>
      <xsl:apply-templates select="@*" />
      <xsl:call-template name="assign-classes" />
      <xsl:apply-templates select="node()" />
    </span>
  </xsl:template>

  <xsl:template name="assign-classes">
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

  <xsl:template match="@rend" mode="rend-class">
    <xsl:choose>
      <xsl:when test=". = 'i'">
        <xsl:text>italic </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'b'">
        <xsl:text>bold </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'c'">
        <xsl:text>caps </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'u'">
        <xsl:text>underline </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'lc'">
        <xsl:text>lowercase </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'sc'">
        <xsl:text>small-caps </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'lsc'">
        <xsl:text>lowercase-small-caps </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'strike'">
        <xsl:text>strikethrough </xsl:text>
      </xsl:when>
      <xsl:when test=". = 'small'">
        <xsl:text>smaller </xsl:text>
      </xsl:when>
      <!-- A colon indicates a CSS rule that belongs in the style
           attribute, so do not handle it here. -->
      <xsl:when test="contains(., ':')" />
      <xsl:otherwise>
        <xsl:value-of select="." />
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@rend" mode="rend-style">
    <xsl:if test="contains(., ':')">
      <xsl:value-of select="." />
      <xsl:text>; </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="@nzetc:id">
    <!-- The NZETC ID is used in html-extract-div.xsl. -->
    <xsl:copy />
    <xsl:attribute name="id">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="*[not(@nzetc:id)]/@xml:id">
    <xsl:attribute name="id">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="@xml:lang">
    <xsl:attribute name="lang">
      <xsl:value-of select="." />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="tei:cell/@cols">
    <xsl:if test=". > 1">
      <xsl:attribute name="colspan">
        <xsl:value-of select="." />
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:cell/@rows">
    <xsl:if test=". > 1">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="." />
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:*">
    <xsl:choose>
      <xsl:when test="@rend">
        <xsl:call-template name="make-span" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*" />

</xsl:stylesheet>
