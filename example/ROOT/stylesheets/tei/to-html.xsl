<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Project-specific XSLT for transforming TEI to HTML. Override
       the core to-html.xsl with any local customisations. -->

  <xsl:import href="../../kiln/stylesheets/tei/to-html.xsl" />

  <xsl:param name="record-id" />

  <xsl:template match="document-title">
      <xsl:value-of select="//tei:TEI//tei:div[@xml:id = $record-id]/tei:head" />
  </xsl:template>

  <xsl:template name="record-title">
      <xsl:value-of select="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[not(@type)]" />
      <xsl:text>: </xsl:text>
      <xsl:value-of
          select="//tei:TEI/tei:text/tei:group/tei:text[@xml:id = $record-id]/tei:body/tei:head[@type = 'main']"
          />
  </xsl:template>

  <xsl:template name="document-heading">
      <h1>
          <xsl:value-of select="//tei:TEI//tei:div[@xml:id = $record-id]/tei:head" />
      </h1>
  </xsl:template>

  <xsl:template name="record-heading">
      <xsl:for-each select="//tei:TEI/tei:text/tei:group/tei:text[@xml:id = $record-id]/tei:body">
          <h1>
              <xsl:text>MIDDLESEX: </xsl:text>
              <xsl:apply-templates select="tei:head[@type = 'main']/tei:placeName" />
              <xsl:text> </xsl:text>
              <xsl:apply-templates select="tei:head[@type = 'main']/tei:date" />
          </h1>
          <h2>
              <xsl:apply-templates select="tei:head[@type = 'main']/tei:title" />
          </h2>
          <small>
              <xsl:apply-templates select="tei:head[@type = 'main']/tei:seg" />
          </small>
          <br />
          <small>
              <xsl:apply-templates select="tei:head[@type = 'sub']/node()" />
          </small>
      </xsl:for-each>
  </xsl:template>

  <xsl:template name="record-pagination">
      <div class="pagination pagination-centered">
          <ul>
              <xsl:for-each select="//tei:TEI/tei:text/tei:group/tei:text[@xml:id = $record-id]">
                  <xsl:choose>
                      <xsl:when test="preceding-sibling::tei:text[@xml:id]">
                          <li>
                              <a href="../{preceding-sibling::tei:text[@xml:id][1]/@xml:id}/"
                                  title="{normalize-space(preceding-sibling::tei:text[@xml:id][1]/tei:body/tei:head[@type = 'main'])}">
                                  <xsl:text>Prev</xsl:text>
                              </a>
                          </li>
                      </xsl:when>
                      <xsl:otherwise>
                          <li class="disabled">
                              <a href="#">Prev</a>
                          </li>
                      </xsl:otherwise>
                  </xsl:choose>
                  <xsl:for-each select="tei:link[string-length(@target) > 1]">
                      <xsl:sort select="@type" />
                      <xsl:variable name="type" select="@type" />

                      <xsl:for-each select="tokenize(@target, ' ')">
                          <xsl:variable name="target" select="normalize-space(.)" />

                          <xsl:if test="$target">
                              <li>
                                  <a href="{$target}">
                                      <xsl:choose>
                                          <xsl:when test="$type = 'document_desc'">
                                              <xsl:attribute name="href">
                                                  <xsl:text>/record/fortunetheatre/supporting/The_Documents_fortune/</xsl:text>
                                                  <xsl:value-of select="substring-after($target, '#')" />
                                                  <xsl:text>/</xsl:text>
                                              </xsl:attribute>
                                              <xsl:text>Document Description</xsl:text>
                                          </xsl:when>
                                          <xsl:when test="$type = 'emlot'">
                                              <xsl:attribute name="target">
                                                  <xsl:text>emlot</xsl:text>
                                              </xsl:attribute>
                                              <xsl:text>EMLoT</xsl:text>
                                          </xsl:when>
                                          <xsl:when test="$type = 'patrons'">
                                              <xsl:attribute name="target">
                                                  <xsl:text>patrons</xsl:text>
                                              </xsl:attribute>
                                              <xsl:text>Patrons</xsl:text>
                                          </xsl:when>
                                      </xsl:choose>
                                  </a>
                              </li>
                          </xsl:if>
                      </xsl:for-each>
                  </xsl:for-each>
                  <xsl:choose>
                      <xsl:when test="following-sibling::tei:text[@xml:id]">
                          <li>
                              <a href="../{following-sibling::tei:text[@xml:id][1]/@xml:id}/"
                                  title="{normalize-space(following-sibling::tei:text[@xml:id][1]/tei:body/tei:head[@type = 'main'])}">
                                  <xsl:text>Next</xsl:text>
                              </a>
                          </li>
                      </xsl:when>
                      <xsl:otherwise>
                          <li class="disabled">
                              <a href="#">Next</a>
                          </li>
                      </xsl:otherwise>
                  </xsl:choose>
              </xsl:for-each>
          </ul>
      </div>
  </xsl:template>

  <xsl:template name="marginalia">
      <xsl:param name="place" required="yes" />

      <xsl:for-each select="//tei:TEI/tei:text/tei:group/tei:text[@xml:id = $record-id]">
          <xsl:if test="tei:body/tei:div[@type = 'transcription']//tei:note[@place = $place]">
              <div class="marginalia">
                  <xsl:for-each
                      select="tei:body/tei:div[@type = 'transcription']//tei:note[@place = $place]">
                      <xsl:variable name="corresp" select="concat('#', @xml:id)" />
                      <xsl:variable name="pre-corresp"
                          select="concat('#', preceding::tei:note[@place = $place][1]/@xml:id)" />
                      <xsl:variable name="lbs"
                          select="count(ancestor::tei:div[1]//tei:anchor[@corresp = $corresp]/preceding::tei:lb[ancestor::tei:text[@xml:id = $record-id]])" />
                      <xsl:variable name="pre-lbs"
                          select="count(preceding::tei:note[@place = $place][1]/ancestor::tei:div[1]//tei:anchor[@corresp = $pre-corresp]/preceding::tei:lb[ancestor::tei:text[@xml:id = $record-id]])" />

                      <xsl:for-each select="1 to ($lbs - $pre-lbs)">
                          <br />
                      </xsl:for-each>

                      <span id="{@xml:id}">
                          <xsl:apply-templates select="node()" />
                          <xsl:text> </xsl:text>
                      </span>
                  </xsl:for-each>
              </div>
          </xsl:if>
      </xsl:for-each>
  </xsl:template>

  <xsl:template name="popover-marginalia">
      <xsl:for-each select="//tei:TEI/tei:text/tei:group/tei:text[@xml:id = $record-id]">
          <xsl:for-each select="tei:body/tei:div[@type = 'transcription']//tei:note[@type = 'marginal']">
              <xsl:text>$('#_</xsl:text>
              <xsl:value-of select="@xml:id" />
              <xsl:text>').popover({html: true, content: </xsl:text>
              <xsl:text>function() {</xsl:text>
              <xsl:text>return $('#_</xsl:text>
              <xsl:value-of select="@xml:id" />
              <xsl:text>_content_wrapper').html();
                  }</xsl:text>
              <xsl:text>}).click(function (e) { e.preventDefault(); });</xsl:text>
          </xsl:for-each>
      </xsl:for-each>
  </xsl:template>

  <xsl:template name="align-marginalia">
      <xsl:for-each select="//tei:TEI/tei:text/tei:group/tei:text[@xml:id = $record-id]">
          <xsl:for-each select="tei:body/tei:div[@type = 'transcription']//tei:note[@type = 'marginal']">
              <xsl:variable name="pre-corresp"
                  select="concat('#', preceding::tei:note[@type = 'marginal'][1]/@xml:id)" />
              $("#<xsl:value-of select="@xml:id" />").align({top: {selector: "#_<xsl:value-of
                  select="@xml:id" />"}}); </xsl:for-each>
      </xsl:for-each>
  </xsl:template>

  <xsl:template name="document-content">
      <xsl:for-each select="//tei:TEI//tei:div[@xml:id = $record-id]">
          <div class="content">
              <xsl:choose>
                  <xsl:when test="tei:msDesc">
                      <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:settlement" />
                      <xsl:text>, </xsl:text>
                      <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:repository" />
                      <xsl:text>, </xsl:text>
                      <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:idno" />
                      <xsl:if test="tei:msDesc/tei:msIdentifier/tei:altIdentifier/tei:idno">
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="tei:msDesc/tei:msIdentifier/tei:altIdentifier/tei:idno" />
                      </xsl:if>
                      <xsl:text>; </xsl:text>
                      <xsl:value-of select="tei:msDesc/tei:history/tei:origin/tei:origDate" />
                      <xsl:text>; </xsl:text>
                      <xsl:value-of select="tei:msDesc/tei:msContents/tei:textLang" />
                      <xsl:text>; </xsl:text>
                      <xsl:apply-templates select="tei:msDesc/tei:physDesc/tei:p/node()" />
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:apply-templates select="tei:bibl" />
                  </xsl:otherwise>
              </xsl:choose>
          </div>

          <xsl:if test="tei:note">
              <br />
              <div class="footnotes">
                  <h3>Notes</h3>
                  <ol>
                      <xsl:for-each select="tei:note">
                          <li>
                              <xsl:apply-templates />
                          </li>
                      </xsl:for-each>
                  </ol>
              </div>
          </xsl:if>
      </xsl:for-each>
  </xsl:template>

  <xsl:template name="record-content">
      <xsl:for-each select="//tei:TEI/tei:text/tei:group/tei:text[@xml:id = $record-id]">
          <xsl:for-each select="tei:body/tei:div[*]">
              <div class="{@type}">
                  <xsl:choose>
                      <xsl:when test="@type = 'transcription'" />
                      <xsl:when test="@type = 'endnote'">
                          <h3>
                              <xsl:text>Note</xsl:text>
                          </h3>
                      </xsl:when>
                      <xsl:when test="@type = 'translation'">
                          <h3>
                              <xsl:text>Translation</xsl:text>
                          </h3>
                      </xsl:when>
                  </xsl:choose>
                  <div class="content">
                      <xsl:apply-templates />
                  </div>
                  <xsl:if test=".//tei:note[@type = 'foot']">
                      <div class="footnotes">
                          <xsl:call-template name="footnotes" />
                      </div>
                  </xsl:if>

                  <br />
              </div>
          </xsl:for-each>
      </xsl:for-each>
  </xsl:template>

  <!-- Footnotes -->
  <xsl:template name="footnotes">
      <h3>Footnotes</h3>
      <ul>
          <xsl:for-each select=".//tei:note[@type = 'foot']">
              <li id="{@xml:id}">
                  <xsl:apply-templates select="node()" />
              </li>
          </xsl:for-each>
      </ul>
  </xsl:template>

  <xsl:template match="tei:note[@type = 'foot']" />

  <!-- Entities -->
  <xsl:template match="tei:name[@key] | tei:rs[@key]">
      <xsl:variable name="key" select="substring-after(@key, 'eats/')" />
      <xsl:choose>
          <xsl:when test="@type = ('man', 'place_built',
              'place_court', 'place_playing', 'place_region',
              'place_religion', 'place_settlement', 'place_sub_settlement',
              'play_title', 'troupe', 'woman')">
              <a href="/{$key}">
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
              <xsl:apply-templates select="node()" />
          </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <!-- Additions, above, with handshift -->
  <xsl:template match="tei:add[@rend = 'above'][tei:handShift]" priority="1">
      <span data-original-title="text written above the line" rel="tooltip">
          <xsl:call-template name="assign-classes" />

          <xsl:text>&#x2e22;</xsl:text>
          <xsl:text>&#xb0;</xsl:text>
          <xsl:apply-templates />
          <xsl:text>&#xb0;</xsl:text>
          <xsl:text>&#x2e23;</xsl:text>
      </span>
  </xsl:template>

  <!-- Additions -->
  <xsl:template match="tei:add[tei:handShift]">
      <xsl:text> </xsl:text>
      <span data-original-title="added in another hand" rel="tooltip">
          <xsl:call-template name="assign-classes" />

          <xsl:text>&#xb0;</xsl:text>
          <xsl:apply-templates />
          <xsl:text>&#xb0;</xsl:text>
      </span>
  </xsl:template>

  <!-- Additions, above -->
  <xsl:template match="tei:add[@rend = 'above']">
      <span data-original-title="text written above the line" rel="tooltip">
          <xsl:call-template name="assign-classes" />

          <xsl:text>&#x2e22;</xsl:text>
          <xsl:apply-templates />
          <xsl:text>&#x2e23;</xsl:text>
      </span>
  </xsl:template>

  <!-- Additions, above, with handshift -->
  <xsl:template match="tei:add[@rend = 'above'][tei:handShift]">
      <span data-original-title="text written above the line" rel="tooltip">
          <xsl:call-template name="assign-classes" />

          <xsl:text>&#x2e22;</xsl:text>
          <xsl:text>&#xb0;</xsl:text>
          <xsl:apply-templates />
          <xsl:text>&#xb0;</xsl:text>
          <xsl:text>&#x2e23;</xsl:text>
      </span>
  </xsl:template>

  <!-- Substitutions -->
  <xsl:template match="tei:subst/tei:add[@place = 'over']">
      <span data-original-title="text written above the line" rel="tooltip">
          <xsl:attribute name="data-original-title">
              <xsl:choose>
                  <xsl:when test="../tei:del">
                      <xsl:value-of select="../tei:del" />
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:text>over-written text illegible</xsl:text>
                  </xsl:otherwise>
              </xsl:choose>
          </xsl:attribute>
          <xsl:call-template name="assign-classes" />

          <xsl:apply-templates />
      </span>
  </xsl:template>

  <!-- Orig -->
  <xsl:template match="tei:orig">
      <xsl:if test="not(number($regularised))">
          <span rel="tooltip">
              <xsl:attribute name="data-original-title">
                  <xsl:apply-templates mode="regularised" select="../tei:reg" />
              </xsl:attribute>
              <xsl:apply-templates select="@*" />
              <xsl:call-template name="assign-classes" />
              <xsl:apply-templates select="node()" />
          </span>
      </xsl:if>
  </xsl:template>

  <!-- Sic -->
  <xsl:template match="tei:sic">
      <xsl:if test="number($corrections)">
          <span rel="tooltip">
              <xsl:attribute name="data-original-title">
                  <xsl:variable name="corrected-text" select="../tei:corr" />
                  <xsl:choose>
                      <xsl:when test="$corrected-text = ''">
                          <xsl:text>delete</xsl:text>
                      </xsl:when>
                      <xsl:when test="$corrected-text">
                          <xsl:apply-templates mode="corrections" select="$corrected-text" />
                      </xsl:when>
                      <xsl:otherwise />
                  </xsl:choose>
              </xsl:attribute>
              <xsl:apply-templates select="@*" />
              <xsl:call-template name="assign-classes" />
              <xsl:apply-templates select="node()" />
          </span>
      </xsl:if>
  </xsl:template>

  <!-- Gaps. -->
  <xsl:template match="tei:gap">
      <span rel="tooltip">
          <xsl:attribute name="data-original-title">
              <xsl:text>lost or illegible letters in original</xsl:text>
              <xsl:if test="@desc or @reason">
                  <xsl:text>; </xsl:text>
                  <xsl:apply-templates select="@desc" />
                  <xsl:text> </xsl:text>
                  <xsl:apply-templates select="@reason" />
              </xsl:if>
          </xsl:attribute>
          <xsl:apply-templates select="@*[not(local-name() = 'desc') and not(local-name() = 'reason')]" />
          <xsl:call-template name="assign-classes" />
          <xsl:text>&lt;</xsl:text>
          <xsl:choose>
              <xsl:when test="@extent >= 3">
                  <xsl:text>...</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:for-each select="1 to @extent">
                      <xsl:text>.</xsl:text>
                  </xsl:for-each>
              </xsl:otherwise>
          </xsl:choose>
          <xsl:text>&gt;</xsl:text>
      </span>
  </xsl:template>

  <xsl:template match="tei:gap[@reason = 'omitted']">
      <span data-original-title="ellipsis of original matter" rel="tooltip">
          <xsl:apply-templates select="@*[not(local-name() = 'desc') and not(local-name() = 'reason')]" />
          <xsl:call-template name="assign-classes" />
          <xsl:text>&#8230;</xsl:text>
      </span>
  </xsl:template>

  <xsl:template match="tei:gap/@desc">
      <xsl:text>omitted: </xsl:text>
      <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="tei:gap/@reason">
      <xsl:text>reason: </xsl:text>
      <xsl:value-of select="." />
  </xsl:template>

  <!-- Deletions -->
  <xsl:template match="tei:del[text()|node()]">
      <xsl:if test="number($amendments)">
          <span data-original-title="cancellation in original" rel="tooltip">
              <xsl:apply-templates select="@*" />
              <xsl:call-template name="assign-classes" />
              <xsl:text>[</xsl:text>
              <xsl:apply-templates />
              <xsl:text>]</xsl:text>
          </span>
      </xsl:if>
  </xsl:template>

  <!-- Expansions -->
  <xsl:template match="tei:ex">
      <em data-original-title="expansion of abbreviation in original" rel="tooltip">
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="assign-classes" />
          <xsl:apply-templates />
      </em>
  </xsl:template>

  <!-- Highlighted text -->
  <xsl:template match="tei:hi[@rend = 'italic']">
      <i>
          <xsl:apply-templates />
      </i>
  </xsl:template>

  <xsl:template match="tei:hi[@rend = 'underline']">
      <u>
          <xsl:apply-templates />
      </u>
  </xsl:template>

  <xsl:template match="tei:hi[@rend = 'superscript']">
      <sup>
          <xsl:apply-templates />
      </sup>
  </xsl:template>

  <!-- Links -->
  <xsl:template match="tei:ref[@target][@type = 'foot_anchor']">
      <a>
          <xsl:attribute name="href">
              <xsl:value-of select="@target" />
          </xsl:attribute>
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="assign-classes" />
          <xsl:apply-templates />
      </a>
  </xsl:template>

  <xsl:template match="tei:link[@target]">
      <a class="tei link">
          <xsl:attribute name="href">
              <xsl:value-of select="@target" />
          </xsl:attribute>
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="assign-classes" />
          <i class="icon-arrow-right" />
          <xsl:if test="node()">
              <xsl:apply-templates />
          </xsl:if>
      </a>
  </xsl:template>

  <!-- Anchors. -->
  <xsl:template match="tei:anchor[@corresp]">
      <xsl:variable name="corresp" select="substring-after(@corresp, '#')" />
      <xsl:variable name="margin"
          select="substring-after(//tei:note[@xml:id = $corresp]/@place, 'margin_')" />

      <a data-original-title="Marginal note" data-placement="{$margin}" href="#"
          id="{concat('_', $corresp)}" rel="popover">
          <i class="icon-comment" />
      </a>
      <div id="{concat('_', $corresp)}_content_wrapper" style="display: none;">
          <xsl:apply-templates select="//tei:note[@xml:id = $corresp]/node()" />
      </div>
  </xsl:template>

  <!-- Marginal notes -->
  <xsl:template match="tei:note[@type = 'marginal']" />

  <!-- Page breaks. -->
  <xsl:template match="tei:pb" />

  <xsl:template match="tei:pb[ancestor::tei:ab[not(@type ='subhead')]]">
      <span class="pb">
          <xsl:text> | </xsl:text>
      </span>
  </xsl:template>

  <!-- Line breaks -->
  <xsl:template match="tei:lb[@type = 'pipe']">
      <xsl:text> | </xsl:text>
  </xsl:template>

  <!-- Signatures -->
  <xsl:template match="tei:seg[@type = 'signed']">
      <span data-original-title="signature" rel="tooltip">
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="assign-classes" />
          <i>(signed)</i>
          <xsl:text> </xsl:text>
          <xsl:apply-templates />
      </span>
  </xsl:template>

  <xsl:template match="tei:seg[@type = 'signed_mark']">
      <span data-original-title="personal mark" rel="tooltip">
          <xsl:apply-templates select="@*" />
          <xsl:call-template name="assign-classes" />
          <xsl:apply-templates />
      </span>
  </xsl:template>

  <!-- Title -->
  <xsl:template match="tei:title[@type = 'monograph']">
      <i>
          <xsl:apply-templates />
      </i>
  </xsl:template>

  <!-- Braced lists -->
  <xsl:template match="tei:cell[@role]">
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
          <xsl:attribute name="class">
              <xsl:value-of select="@role" />
          </xsl:attribute>
          <xsl:apply-templates select="node()" />
      </xsl:element>
  </xsl:template>

  <!-- Spans -->
  <xsl:template match="tei:span">
      <xsl:apply-templates select="node()" />
  </xsl:template>

  <!-- Space -->
  <xsl:template match="tei:space">
      <xsl:text> (blank) </xsl:text>
  </xsl:template>

  <xsl:template match="tei:fw">
      <xsl:if test="preceding-sibling::*[1][local-name() != 'lb']">
          <br />
      </xsl:if>
      <xsl:apply-templates />
      <br />
  </xsl:template>

</xsl:stylesheet>
