<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Join div elements in a TEI document that belong together (are
       linked via "next" and "prev" attributes).
       
       This is a relatively complicated XSLT with a number of desired
       behaviours. There are a number of files in the tests directory,
       being source documents and the expected results of applying
       this transformation to them.
       
       The desired behaviours are:
       
       * Join divs that are associated via next/prev attributes into a
       single div at the point of the first div with a next
       attribute. The subsequent associated divs do not appear in the
       document, only their content at this point, although an anchor
       is placed in the first div for each joined div so that the IDs
       are not lost.
       
       * Headings of subsequent divs are discarded - in at least
       GolMin.xml, the heading is a statement of continuation and not
       desirable for inclusion when the divs are joined. (See
       discussion below on how to join sections that have headings
       that should be kept.)
       
       * Page breaks that are relevant to the subsequent divs are
       copied to their new location.
       
       * Page breaks that are relevant to material following a joining
       div but which are contained within a joined div are repeated
       where necessary. This can lead to situations where the same
       sequence of page numbers occurs multiple times: two articles
       start on the same page, and each continue on the next page,
       leading to pb1, pb2, pb1, pb2...
       
       * Page breaks, that have no content (between it and the next
       page break) that isn't part of a div that has been moved to
       join with another div, are changed to be anchors so that the ID
       is not lost.
       
       
       How to join divs with structure and headings
       
       It is critical for the generation of proper markup to realise
       that a div that is joined to a preceding div does not and will
       not count as a structural unit. If the content of the joined
       div is meant to represent a structural unit (a section of an
       article, for example), then that content must be wrapped in its
       own div, within the joined div.
       
       Therefore, the markup for an article with two subsections, the
       second of which is separated from the first by unrelated
       material, the following markup must be used:
       
       <div xml:id="div-of-entire-article"
            next="div-of-next-part-of-entire-article">
         <div xml:id="div-of-section-one">
           <head>Heading of first section.</p>
           <p>Content of first section.</p>
         </div>
       </div>
       <div xml:id="div-of-unrelated-content">
         <p>Unrelated content.</p>
       </div>
       <div xml:id="div-of-next-part-of-entire-article"
            prev="div-of-entire-article">
         <div xml:id="div-of-section-two">
           <head>Heading of second section.</head>
           <p>Content of second section.</head>
         </div>
       </div>
       
       That is, the split is at the level of entire article, and must
       therefore be joined at that level, regardless of what
       substructures there are.

  -->
  
  <xsl:template match="/">
    <!-- Avoid processing a document that doesn't contain any divs to
         be joined. -->
    <xsl:choose>
      <xsl:when test="//tei:div[@next]">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="/tei:TEI"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:div[@next]">
    <xsl:variable name="nextID" select="substring(@next, 2)"/>
    <xsl:apply-templates select="." mode="repeat"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()" mode="join"/>
      <xsl:apply-templates select="//tei:div[@xml:id=$nextID]" mode="join">
        <xsl:with-param name="linked-div-id" select="$nextID"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:div">
    <xsl:apply-templates select="." mode="repeat"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:div" mode="join">
    <xsl:param name="linked-div-id" select="''"/>
    <xsl:if test="@xml:id = $linked-div-id or not(@prev) or not(ancestor::tei:div[@prev or @next])">
      <!-- Add in page breaks which apply to the joined section but
           which are not contained by the joined section -->
      <xsl:if test="@prev">
        <xsl:variable name="first-required-pb-id" select="descendant::text()[normalize-space()][1]/preceding::tei:pb[1]/@xml:id"/>
        <xsl:variable name="first-pb-id"
                      select="string(current()//tei:pb[1]/@xml:id)"/>
        <xsl:if test="$first-required-pb-id != $first-pb-id">
          <xsl:apply-templates select="preceding::tei:pb[1]" mode="repeat">
            <xsl:with-param name="div-id" select="@xml:id"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@prev">
          <!-- Do not throw out the div's ID if we are removing this div. -->
          <xsl:element name="anchor" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:attribute name="xml:id">
              <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
          </xsl:element>
          <xsl:apply-templates select="node()" mode="join"/>
          <xsl:if test="@next">
            <xsl:variable name="nextID" select="substring(@next, 2)"/>
            <xsl:apply-templates select="//tei:div[@xml:id=$nextID]"
                                 mode="join"/>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="join"/>
            <xsl:if test="@next">
              <xsl:variable name="nextID" select="substring(@next, 2)"/>
              <xsl:apply-templates select="//tei:div[@xml:id=$nextID]"
                                   mode="join"/>
            </xsl:if>
          </xsl:copy>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:div[@prev]/tei:head" mode="join"/>

  <xsl:template match="tei:div[@prev]" priority="1000">
    <!-- The last pb inside the div may apply also to text after this
         div, in which case keep it here. -->
    <xsl:if test=".//tei:pb and following::text()[normalize-space()][1][preceding::tei:pb[1]/ancestor::tei:div[@xml:id=current()/@xml:id]]">
      <xsl:apply-templates select=".//tei:pb[position()=last()]" mode="repeat">
        <xsl:with-param name="div-id" select="@xml:id"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <!-- A div (d2) may follow another div (d1) on the same page that
       joins to a div (d3) on a different page, and so we need to
       repeat the pb for d2 - otherwise it would appear that d2
       occurred on the same page as d3.
       
       A further complication arises that d3 may contain a pb, or join
       to another div on a different page. Therefore the chain of
       joins must be followed until its end.
       
       Because divs that have a @prev are dealt with separately
       (having been taken out of their current context), ignore them
       when searching for a preceding div.
  -->
  <xsl:template match="tei:div" mode="repeat">
    <xsl:variable name="preceding-pb" select="preceding::tei:pb[1]"/>
    <xsl:variable name="preceding-div" select="preceding::tei:div[not(@prev)][1]"/>
    <xsl:variable name="preceding-div-pb-id">
      <xsl:choose>
        <xsl:when test="$preceding-div//tei:pb">
          <xsl:value-of select="$preceding-div//tei:pb[position()=last()]/@xml:id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$preceding-div/preceding::tei:pb[1]/@xml:id"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$preceding-div/@next and $preceding-div-pb-id = $preceding-pb/@xml:id">
      <xsl:call-template name="check-div">
        <xsl:with-param name="original-div-id" select="@xml:id"/>
        <xsl:with-param name="original-pb" select="$preceding-pb"/>
        <xsl:with-param name="div" select="//tei:div[@xml:id = substring($preceding-div/@next, 2)]"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Check whether div contains a pb; if it does, output a page
       break. If it doesn't, check whether div is on the same page as
       original-div. If it is not, output a page break. If it isn't,
       but it does link forward to another div, run the same check on
       the linked div. -->
  <xsl:template name="check-div">
    <xsl:param name="original-div-id"/>
    <xsl:param name="original-pb"/>
    <xsl:param name="div"/>
    <xsl:choose>
      <xsl:when test="$div//tei:pb">
        <xsl:apply-templates select="$original-pb" mode="repeat">
          <xsl:with-param name="div-id" select="$original-div-id"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$div/preceding::tei:pb[1]/@xml:id != $original-pb/@xml:id">
        <xsl:apply-templates select="$original-pb" mode="repeat">
          <xsl:with-param name="div-id" select="$original-div-id"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$div/@next">
        <xsl:call-template name="check-div">
          <xsl:with-param name="original-div-id" select="$original-div-id"/>
          <xsl:with-param name="original-pb" select="$original-pb"/>
          <xsl:with-param name="div" select="//tei:div[@xml:id = substring($div/@next, 2)]"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:pb" mode="repeat">
    <xsl:param name="div-id"/>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="xml:id">
        <xsl:value-of select="@xml:id"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="$div-id"/>
      </xsl:attribute>
    </xsl:copy>
  </xsl:template>

  <!-- A pb may have all of its 'content' (textual material between it
       and the next pb) encompassed by div(s) with @prev, in which
       case it is stranded and misleading to display. In such cases,
       replace it with an anchor so that the ID is not lost.
       
       Note that content is defined as non-whitespace-only text nodes
       and figures that have no textual content - other forms of
       markup, and pure whitespace text, do not count! This should not
       be dangerous, as all markup and text will be processed in the
       normal course of the XSLT; this is solely to determine whether
       to display the pb as a pb or as an anchor.

  -->
  <xsl:template match="tei:pb">
    <xsl:variable name="is-not-fully-encompassed-by-prevs">
      <xsl:apply-templates select="following::text()[normalize-space()][1]"
                           mode="pb-content">
        <xsl:with-param name="pb-id" select="@xml:id"/>
      </xsl:apply-templates>
      <xsl:if test="following::tei:figure[not(normalize-space)][1][preceding::tei:pb/@xml:id=current()/@xml:id]">
        <xsl:text>true</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="normalize-space($is-not-fully-encompassed-by-prevs)">
        <xsl:copy>
          <xsl:apply-templates select="@*"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <anchor>
          <xsl:apply-templates select="@xml:id"/>
        </anchor>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="text()" mode="pb-content">
    <xsl:param name="pb-id"/>
    <xsl:choose>
      <xsl:when test="preceding::tei:pb[1]/@xml:id != $pb-id"/>
      <xsl:when test="ancestor::tei:div[@prev]">
        <xsl:apply-templates select="following::text()[normalize-space()][1]"
                             mode="pb-content">
          <xsl:with-param name="pb-id" select="$pb-id"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>true</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="join">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="join"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>