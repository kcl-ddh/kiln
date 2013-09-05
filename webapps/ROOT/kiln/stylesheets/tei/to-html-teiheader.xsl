<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a TEI document's teiHeader into HTML. -->

  <xsl:template match="tei:author">
    <xsl:if test="not(preceding-sibling::tei:author)">
      <p>
        <strong>
          <xsl:text>Author</xsl:text>
          <xsl:if test="following-sibling::tei:author">
            <xsl:text>s</xsl:text>
          </xsl:if>
          <xsl:text>:</xsl:text>
        </strong>
        <xsl:text> </xsl:text>
        <xsl:apply-templates />
        <xsl:for-each select="following-sibling::tei:author">
          <xsl:text>; </xsl:text>
          <xsl:apply-templates />
        </xsl:for-each>
      </p>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:bibl">
    <xsl:value-of select="." />
  </xsl:template>

  <xsl:template match="tei:change">
    <li>
      <xsl:apply-templates select="@when" />
      <!-- A tei:change may contain so much markup that it is best to
           use the base templates to render it. -->
      <xsl:apply-templates />
      <xsl:apply-templates select="@who" />
    </li>
  </xsl:template>

  <xsl:template match="tei:publicationStmt/tei:date">
    <p>
      <strong>Publication date: </strong>
      <xsl:text> </xsl:text>
      <xsl:value-of select="." />
    </p>
  </xsl:template>

  <xsl:template match="tei:encodingDesc">
    <section>
      <h2 class="title" data-section-title="">
        <small><a href="#">Encoding description</a></small>
      </h2>
      <div class="content" data-section-content="">
        <xsl:apply-templates />
      </div>
    </section>
  </xsl:template>

  <xsl:template match="tei:extent">
    <p>
      <strong>Extent:</strong>
      <xsl:text> </xsl:text>
      <xsl:value-of select="normalize-space(.)" />
    </p>
  </xsl:template>

  <xsl:template match="tei:fileDesc">
    <section>
      <h2 class="title" data-section-title="">
        <small><a href="#">Digital document details</a></small>
      </h2>
      <div class="content" data-section-content="">
        <xsl:apply-templates select="tei:*[not(local-name()='sourceDesc')]" />
      </div>
    </section>
    <xsl:apply-templates select="tei:sourceDesc" />
  </xsl:template>

  <xsl:template match="tei:funder">
    <p>
      <strong>Funder: </strong>
      <xsl:text> </xsl:text>
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="tei:msDesc">
    <xsl:apply-templates select="tei:msIdentifier" />
  </xsl:template>

  <xsl:template match="tei:profileDesc" />

  <xsl:template match="tei:publisher">
    <p>
      <strong>Publisher:</strong>
      <xsl:text> </xsl:text>
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="tei:pubPlace">
    <p>
      <strong>Place of publication:</strong>
      <xsl:text> </xsl:text>
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="tei:respStmt">
    <p>
      <strong>
        <xsl:apply-templates select="tei:resp" />
        <xsl:text>: </xsl:text>
      </strong>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="tei:*[not(local-name()='resp')]" />
    </p>
  </xsl:template>

  <xsl:template match="tei:revisionDesc">
    <section>
      <h2 class="title" data-section-title="">
        <small><a href="#">File changelog</a></small>
      </h2>
      <div class="content" data-section-content="">
        <ul class="no-bullet">
          <xsl:apply-templates />
        </ul>
      </div>
    </section>
  </xsl:template>

  <xsl:template match="tei:sourceDesc">
    <section>
      <h2 class="title" data-section-title="">
        <small><a href="#">Source document details</a></small>
      </h2>
      <div class="content" data-section-content="">
        <xsl:apply-templates />
      </div>
    </section>
  </xsl:template>

  <xsl:template match="tei:teiHeader">
    <!-- Display metadata about this document, drawn from the TEI
         header. -->
    <div class="section-container accordion" data-section="accordion">
      <xsl:apply-templates />
      <section>
        <h2 class="title" data-section-title="">
          <small><a href="#">Other Formats</a></small>
        </h2>
        <div class="content" data-section-content="">
          <ul class="no-bullet">
            <li>
              <a href="{../@xml:id}.xml">
                <abbr title="Text Encoding for Interchange">TEI</abbr>
                <xsl:text> source</xsl:text>
              </a>
            </li>
          </ul>
        </div>
      </section>
    </div>
  </xsl:template>

  <xsl:template match="tei:seriesStmt/tei:title">
    <p>
      <strong>Series title:</strong>
      <xsl:text> </xsl:text>
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="tei:titleStmt/tei:title">
    <p>
      <strong>Title:</strong>
      <xsl:text> </xsl:text>
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="tei:change/@when">
    <strong>
      <xsl:value-of select="." />
      <xsl:text>:</xsl:text>
    </strong>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:change/@who">
    <xsl:text> [</xsl:text>
    <xsl:choose>
      <xsl:when test="starts-with(., '#')">
        <xsl:variable name="who-id" select="substring(., 2)" />
        <xsl:apply-templates select="ancestor::tei:teiHeader//*[@xml:id=$who-id]" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="." />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>] </xsl:text>
  </xsl:template>

</xsl:stylesheet>
