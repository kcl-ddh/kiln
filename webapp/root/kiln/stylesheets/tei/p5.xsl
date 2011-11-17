<?xml version="1.0"?>
<!--  $Id$ -->
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xmm="http://www.cch.kcl.ac.uk/xmod/menu/1.0"
  xmlns:xmmf="http://www.cch.kcl.ac.uk/xmod/metadata/files/1.0"
  xmlns:xmp="http://www.cch.kcl.ac.uk/xmod/properties/1.0"
  xmlns:xmt="http://www.cch.kcl.ac.uk/xmod/tei/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="tei:teiHeader"/>
  <xsl:template match="tei:body/tei:head"/>
  <xsl:template match="tei:body/tei:head" mode="pagehead">
    <xsl:apply-templates/>
    <!-- <xsl:apply-templates mode="pagehead" /> -->
  </xsl:template>
  <xsl:template match="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title" mode="pagehead">
    <xsl:apply-templates/>
    <!--  <xsl:apply-templates mode="pagehead" /> -->
  </xsl:template>
  <xsl:template
    match="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/*[self::tei:author|self::tei:editor|self::tei:respStmt]"
    mode="pagehead">
    <xsl:apply-templates mode="pagehead"/>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template match="//tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:resp"
    mode="pagehead">
    <xsl:apply-templates/>
    <xsl:if test="following-sibling::tei:name">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>
  <!--   DIVISIONS     -->
  <xsl:template match="tei:div">
    <xsl:choose>
      <!--Contact Details Box -->
      <!-- THIS IS WRONG, DOESN'T WORK IN HTML -->
      <xsl:when test="@type='box'">
        <address>
          <xsl:apply-templates/>
        </address>
      </xsl:when>
      <!--   Default  -->
      <xsl:otherwise>
        <!-- Creates anchor if there is @xml:id -->
        <xsl:if test="@xml:id">
          <a>
            <xsl:attribute name="id">
              <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:text>&#160;</xsl:text>
          </a>
        </xsl:if>
        <div>
          <xsl:apply-templates/>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--   HEADINGS     -->
  <xsl:template match="tei:TEI/*/*/tei:div/tei:head">
    <h2 id="{generate-id()}">
      <xsl:apply-templates/>
    </h2>
  </xsl:template>
  <xsl:template match="tei:TEI/*/*/tei:div/tei:div/tei:head">
    <h3 id="{generate-id()}">
      <xsl:apply-templates/>
    </h3>
  </xsl:template>
  <xsl:template match="tei:TEI/*/*/tei:div/tei:div/tei:div/tei:head">
    <h4 id="{generate-id()}">
      <xsl:apply-templates/>
    </h4>
  </xsl:template>
  <xsl:template match="tei:TEI/*/*/tei:div/tei:div/tei:div/tei:div/tei:head">
    <h5 id="{generate-id()}">
      <xsl:apply-templates/>
    </h5>
  </xsl:template>
  <xsl:template match="tei:TEI/*/*/tei:div/tei:div/tei:div/tei:div/tei:div/tei:head">
    <h6 id="{generate-id()}">
      <xsl:apply-templates/>
    </h6>
  </xsl:template>
  <xsl:template match="tei:TEI/*/*/tei:div/tei:div/tei:div/tei:div/tei:div/tei:div/tei:head">
    <h6 id="{generate-id()}">
      <xsl:apply-templates/>
    </h6>
  </xsl:template>
  <!--   TOC     -->
  <xsl:template match="tei:body/tei:head" mode="toc">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tei:note" mode="toc"> </xsl:template>
  <xsl:template match="tei:term" mode="toc"> </xsl:template>
  <xsl:template match="tei:hi" mode="toc">
    <xsl:apply-templates/>
  </xsl:template>
  <!--   TOC FOR FRONT AND BACK TOO?     -->
  <xsl:template match="tei:front/tei:head" mode="toc">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tei:back/tei:head" mode="toc">
    <xsl:apply-templates/>
  </xsl:template>
  <!--   SUBMENU EXTRAS     -->
  <xsl:template match="tei:head" mode="submenu">
    <xsl:apply-templates mode="submenu"/>
  </xsl:template>
  <xsl:template match="tei:note" mode="submenu"> </xsl:template>
  <xsl:template match="tei:hi" mode="submenu">
    <xsl:apply-templates/>
  </xsl:template>
  <!--   BLOCK LEVEL     -->
  <!-- Creates anchor if there is @xml:id -->
  <xsl:template name="a-id">
    <xsl:if test="@xml:id">
      <xsl:attribute name="id">
        <xsl:value-of select="@xml:id"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <!--   PARAS     -->
  <xsl:template match="tei:p">
    <xsl:choose>
      <xsl:when test="tei:figure/tei:head">
        <xsl:for-each select="tei:figure[tei:head]/tei:graphic">
          <xsl:call-template name="showFigure"/>
        </xsl:for-each>
        <p>
          <xsl:call-template name="a-id"/>
          <xsl:apply-templates/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <xsl:call-template name="a-id"/>
          <xsl:apply-templates/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--   LISTS     -->
  <!--  Selecting list rendition used in the templates below-->
  <xsl:template name="list-rend">
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="@rend='arabic'">t01</xsl:when>
        <xsl:when test="@rend='lower_case'">t02</xsl:when>
        <xsl:when test="@rend='lower_roman'">t03</xsl:when>
        <xsl:when test="@rend='upper_case'">t04</xsl:when>
        <xsl:when test="@rend='upper_roman'">t05</xsl:when>
        <xsl:otherwise>
          <!--  DEFAULT is usually arabic -->
          <xsl:text>t01</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="list-head">
    <xsl:if test="tei:head">
      <h3>
        <xsl:apply-templates select="tei:head"/>
      </h3>
    </xsl:if>
  </xsl:template>
  <xsl:template match="xmt:uList | xmt:oList">
    <xsl:choose>
      <!-- Figure in lists -->
      <!--  CASE 1: Test for nested lists -->
      <xsl:when test="parent::item">
        <div>
          <xsl:call-template name="list-rend"/>
          <xsl:call-template name="list-models"/>
        </div>
      </xsl:when>
      <!--  CASE 2: Test for lists within tables -->
      <xsl:when test="ancestor::tei:table">
        <xsl:call-template name="list-models"/>
      </xsl:when>
      <!--  CASE 3: Test for lists within blockquotes -->
      <xsl:when test="ancestor::tei:q">
        <xsl:call-template name="list-models"/>
      </xsl:when>
      <!--  CASE 4: Ordered lists -->
      <xsl:when test="self::xmt:oList">
        <div class="orderedList">
          <div>
            <xsl:call-template name="list-rend"/>
            <xsl:call-template name="list-models"/>
          </div>
        </div>
      </xsl:when>
      <!--  CASE 5: Inline simple lists -->
      <xsl:when test="@type='simple'">
        <xsl:call-template name="list-models"/>
      </xsl:when>
      <!--  CASE 6: Glossary lists -->
      <xsl:when test="@type='gloss'">
        <div class="resourceList">
          <div class="t02">
            <xsl:call-template name="list-models"/>
          </div>
        </div>
      </xsl:when>
      <!--  CASE 6: Normal/bulleted lists -->
      <xsl:otherwise>
        <div class="unorderedList">
          <div class="t01">
            <xsl:call-template name="list-models"/>
          </div>
        </div>
      </xsl:otherwise>
      <!--  END OF ALL CASES -->
    </xsl:choose>
  </xsl:template>
  <xsl:template name="list-models">
    <!-- Basic list formatting starts -->
    <xsl:choose>
      <xsl:when test="self::xmt:oList">
        <xsl:call-template name="list-head"/>
        <ol>
          <xsl:call-template name="a-id"/>
          <xsl:apply-templates select="*[not(local-name()='head')]"/>
        </ol>
      </xsl:when>
      <!--  DEFAULT  -->
      <xsl:otherwise>
        <xsl:call-template name="list-head"/>
        <ul>
          <xsl:call-template name="a-id"/>
          <xsl:apply-templates select="*[not(local-name()='head')]"/>
        </ul>
      </xsl:otherwise>
    </xsl:choose>
    <!-- Basic list formatting ends -->
  </xsl:template>
  <xsl:template match="tei:list">
    <xsl:choose>
      <!-- CASE 1: Full sized figures in a grid -->
      <xsl:when test="@type='figure-full'">
        <div class="image">
          <div class="t01">
            <xsl:for-each select="tei:item/tei:graphic">
              <xsl:call-template name="showFigure"/>
            </xsl:for-each>
          </div>
        </div>
      </xsl:when>
      <!-- CASE 2: Thumbnail figures in a grid -->
      <xsl:when test="@type='figure-thumb'">
        <div class="image">
          <div class="t04">
            <xsl:for-each select="tei:item/tei:graphic">
              <xsl:call-template name="showFigure"/>
            </xsl:for-each>
          </div>
        </div>
      </xsl:when>
      <!-- CASE 3: Full sized images in a list -->
      <xsl:when test="@type='graphic-list'">
        <div class="image">
          <div class="t02">
            <dl>
              <xsl:apply-templates/>
            </dl>
          </div>
        </div>
      </xsl:when>
      <xsl:when test="@type='gloss'">
        <dl>
          <xsl:call-template name="a-id"/>
          <xsl:apply-templates/>
        </dl>
      </xsl:when>
      <xsl:when test="@type='special'">
        <xsl:if test="tei:head">
          <h2>
            <xsl:apply-templates select="tei:head"/>
          </h2>
        </xsl:if>
        <div class="definitionList">
          <div class="t01">
            <dl>
              <xsl:call-template name="a-id"/>
              <xsl:apply-templates select="tei:item"/>
            </dl>
          </div>
        </div>
      </xsl:when>
      <xsl:when test="@type='logo'">
        <div class="logoMatrix">
          <div class="t01 clfx-b">
            <ul>
              <xsl:for-each select="tei:item">
                <li>
                  <a href="{tei:ref/@target}">
                    <xsl:call-template name="external-link"/>
                    <xsl:for-each select=".//tei:figure/tei:graphic">
                      <xsl:call-template name="showFigure"/>
                    </xsl:for-each>
                  </a>
                </li>
              </xsl:for-each>
            </ul>
          </div>
        </div>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="item-class-oddeven">
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="count(preceding-sibling::tei:item) mod 2 = 0">tableeven</xsl:when>
        <xsl:otherwise>tableodd</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <xsl:template match="tei:item">
    <xsl:choose>
      <!-- Figure in lists -->
      <!-- CASE 1: Full sized figures in a grid -->
      <xsl:when test="../@type='figure-full'">
        <!--<xsl:apply-templates/>-->
      </xsl:when>
      <!-- CASE 2: Thumbnail figures in a grid -->
      <xsl:when test="../@type='figure-thumb'">
        <xsl:apply-templates/>
      </xsl:when>
      <!-- CASE 3: Full sized images in a list -->
      <xsl:when test="../@type='graphic-list'">
        <dt>
          <xsl:apply-templates select="tei:graphic"/>
        </dt>
        <xsl:choose>
          <xsl:when test="tei:p">
            <dd>
              <xsl:apply-templates select="tei:p"/>
            </dd>
          </xsl:when>
          <xsl:otherwise>
            <dd>
              <p>
                <xsl:apply-templates select="text()|*[not(self::tei:graphic)]"/>
              </p>
            </dd>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!--  CASE 2: Glossary items -->
      <xsl:when test="../@type='gloss'">
        <!-- item HERE -->
        <dt>
          <xsl:attribute name="class">
            <xsl:call-template name="r-num"/>
            <xsl:call-template name="odd-even"/>
          </xsl:attribute>
          <xsl:apply-templates mode="glossary" select="preceding-sibling::tei:label[1]"/>
        </dt>
        <!-- label HERE -->
        <dd>
          <xsl:attribute name="class">
            <xsl:call-template name="r-num"/>
            <xsl:text> c01</xsl:text>
            <xsl:call-template name="odd-even"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </dd>
      </xsl:when>
      <!--  CASE 3: Items with their own numbers -->
      <xsl:when test="@n">
        <li>
          <xsl:apply-templates select="@n"/>
          <xsl:text>. </xsl:text>
          <xsl:apply-templates/>
        </li>
      </xsl:when>
      <!--  CASE 4: All other list items -->
      <xsl:otherwise>
        <li>
          <xsl:apply-templates/>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:label" mode="glossary">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tei:label">
    <strong>
      <xsl:apply-templates/>
    </strong>
    <xsl:text>: </xsl:text>
  </xsl:template>
  <!-- <xsl:template match="headLabel">
    <dt class="r01 z01">
      <xsl:apply-templates/>
    </dt>
    <dd class="r01 c01 z01">
      <xsl:apply-templates select="following-sibling::headItem[1]" mode="glossary"/>
    </dd>
  </xsl:template>-->
  <!--<xsl:template match="headItem"/>

  <xsl:template match="headItem" mode="glossary">
    <xsl:apply-templates/>
  </xsl:template>-->
  <!--   TABLE    -->
  <xsl:template match="tei:table">
    <xsl:choose>
      <!--  CASE 5: rowspan/colspan tables  -->
      <xsl:when test="@xmt:type='complex'">
        <xsl:call-template name="table-complexDisplay"/>
      </xsl:when>
      <!--  DEFAULT option: normal tables  -->
      <xsl:otherwise>
        <xsl:call-template name="table-simpleDisplay"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--   ROW   -->
  <xsl:template match="tei:row">
    <!-- Parameters passed through -->
    <xsl:param name="number-of-rows"/>
    <xsl:param name="number-of-cells"/>
    <xsl:choose>
      <!--  CASE 5: rowspan/colspan tables  -->
      <xsl:when test="../@xmt:type='complex'">
        <xsl:call-template name="row-complexDisplay">
          <xsl:with-param name="number-of-rows" select="$number-of-rows"/>
          <xsl:with-param name="number-of-cells" select="$number-of-cells"/>
        </xsl:call-template>
      </xsl:when>
      <!--  DEFAULT option: normal tables  -->
      <xsl:otherwise>
        <xsl:call-template name="row-simpleDisplay"> </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--   CELL   -->
  <xsl:template match="tei:cell">
    <!-- Parameters passed through -->
    <xsl:param name="number-of-rows"/>
    <xsl:param name="number-of-cells"/>
    <xsl:param name="context-row"/>
    <xsl:choose>
      <!--  CASE 5: rowspan/colspan tables  -->
      <xsl:when test="../../@xmt:type='complex'">
        <xsl:call-template name="cell-complexDisplay">
          <xsl:with-param name="number-of-rows" select="$number-of-rows"/>
          <xsl:with-param name="number-of-cells" select="$number-of-cells"/>
          <xsl:with-param name="context-row" select="count(preceding-sibling::row) + 1"/>
        </xsl:call-template>
      </xsl:when>
      <!--  DEFAULT option: normal tables  -->
      <xsl:otherwise>
        <xsl:call-template name="cell-simpleDisplay"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- TEMPLATES FOR SHADING AND ROW NUMBERS -->
  <!-- Template for alternate shading -->
  <xsl:template name="odd-even">
    <xsl:choose>
      <xsl:when test="../@type='gloss'">
        <xsl:choose>
          <xsl:when test="count(preceding-sibling::tei:item) mod 2 = 0"> z01</xsl:when>
          <xsl:otherwise>
            <xsl:text> z02</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="../@type='special'">
        <xsl:choose>
          <xsl:when test="count(parent::tei:item/preceding-sibling::*) mod 2 = 0"> z01</xsl:when>
          <xsl:otherwise>
            <xsl:text> z02</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="count(preceding-sibling::tei:row) mod 2 = 0"> z01</xsl:when>
          <xsl:otherwise>
            <xsl:text> z02</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Template for counting rows -->
  <xsl:template name="r-num">
    <xsl:choose>
      <xsl:when test="../@type='gloss' or ../@type='special'">
        <xsl:variable name="count-item">
          <xsl:number count="tei:item" format="01" level="single"/>
        </xsl:variable>
        <xsl:text>r</xsl:text>
        <xsl:value-of select="$count-item"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="not(following-sibling::tei:row)">
            <xsl:text>x02</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>r</xsl:text>
            <xsl:number count="tei:row" format="01" level="single"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Template for counting cells -->
  <xsl:template name="c-num">
    <xsl:choose>
      <xsl:when test="not(following-sibling::tei:cell)">
        <xsl:text>x01</xsl:text>
      </xsl:when>
      <xsl:when test="../../@xmt:type='special'">
        <xsl:variable name="bcell">
          <xsl:number count="tei:cell" level="single"/>
        </xsl:variable>
        <xsl:variable name="ccell">
          <xsl:value-of select="$bcell - 1"/>
        </xsl:variable>
        <xsl:text>c</xsl:text>
        <xsl:number format="01" value="$ccell"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>c</xsl:text>
        <xsl:number count="tei:cell" format="01" level="single"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- Template for Table heads and captions -->
  <xsl:template name="tableHead">
    <xsl:attribute name="title">
      <xsl:value-of select="tei:head"/>
    </xsl:attribute>
    <caption>
      <xsl:value-of select="tei:head"/>
    </caption>
  </xsl:template>
  <xsl:template name="thScope">
    <xsl:attribute name="scope">
      <xsl:choose>
        <xsl:when test="../@role='label'">
          <xsl:text>col</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>row</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:template>
  <!--  TABLE: specialListDisplay model  -->
  <!--  <xsl:template name="table-specialListDisplay">
    <xsl:if test="tei:head">
      <h6>
        <xsl:apply-templates select="tei:head"/>
      </h6>
    </xsl:if>
    <div class="resourceList">
      <xsl:call-template name="a-id"/>
      <div class="t01">
        <dl>
          <xsl:apply-templates select="tei:row"/>
        </dl>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="row-specialListDisplay">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template name="cell-specialListDisplay">
    <xsl:call-template name="genCellLinkDisplay"/>
  </xsl:template>

-->
  <!--  Generic Cell processing  -->
  <!-- LinkBiblio and Special list Table template uses. Table => definition list transformation -->
  <!-- <xsl:template name="genCellLinkDisplay">
    <xsl:choose>
      <xsl:when test="not(preceding-sibling::tei:cell)">
        <dt>
          <xsl:attribute name="class">
            <xsl:call-template name="r-num"/>
            <xsl:call-template name="odd-even"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </dt>
      </xsl:when>
      <xsl:otherwise>
        <dd>
          <xsl:attribute name="class">
            <xsl:call-template name="r-num"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="c-num"/>
            <xsl:call-template name="odd-even"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </dd>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->
  <!--  table: complexDisplay model  -->
  <!-- Test to prevent endless looping -->
  <xsl:template name="consistency-test">
    <xsl:param name="number-of-cells"/>
    <xsl:for-each select="tei:row[position()>1]">
      <xsl:variable name="cur-cell-count" select="count(tei:cell) + sum(tei:cell/@cols) -
        count(tei:cell/@cols)"/>
      <xsl:if test="$cur-cell-count > $number-of-cells">
        <xsl:text>1</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="table-complexDisplay">
    <!-- Number of rows in the table. -->
    <xsl:variable name="number-of-rows" select="count(tei:row)"/>
    <!-- Number of columns in a row. -->
    <xsl:variable name="number-of-cells" select="count(tei:row[position() = 1]/tei:cell) +
      sum(tei:row[position() = 1]/tei:cell/@cols) - count(tei:row[position() = 1]/tei:cell/@cols)"/>
    <!-- To prevent extra cells causing the process to break -->
    <xsl:variable name="error">
      <xsl:call-template name="consistency-test">
        <xsl:with-param name="number-of-cells" select="$number-of-cells"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <!-- Test to prevent endless looping -->
      <xsl:when test="contains($error, '1')">
        <h3>Error converting table. Please check encoding for extra cells or missing colspans.</h3>
      </xsl:when>
      <!-- Output -->
      <xsl:otherwise>
        <div class="tbs">
          <xsl:call-template name="a-id"/>
          <div class="t01">
            <table>
              <xsl:if test="string(tei:head)">
                <xsl:call-template name="tableHead"/>
              </xsl:if>
              <xsl:if test="tei:row[@role='label']">
                <thead>
                  <xsl:apply-templates select="tei:row[@role='label']">
                    <xsl:with-param name="number-of-rows" select="$number-of-rows"/>
                    <xsl:with-param name="number-of-cells" select="$number-of-cells"/>
                  </xsl:apply-templates>
                </thead>
              </xsl:if>
              <tbody>
                <xsl:apply-templates select="tei:row[not(@role='label')]">
                  <xsl:with-param name="number-of-rows" select="$number-of-rows"/>
                  <xsl:with-param name="number-of-cells" select="$number-of-cells"/>
                </xsl:apply-templates>
              </tbody>
            </table>
          </div>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="row-complexDisplay">
    <!-- Parameters passed through -->
    <xsl:param name="number-of-rows"/>
    <xsl:param name="number-of-cells"/>
    <!-- Variable for current row class -->
    <xsl:variable name="r-num">
      <xsl:choose>
        <xsl:when test="not(following-sibling::tei:row)">
          <xsl:text>x02</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>r</xsl:text>
          <xsl:number count="tei:row" format="01" level="single"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <tr>
      <xsl:attribute name="class">
        <xsl:value-of select="$r-num"/>
        <!-- Shaded rows so that the borders show up -->
        <xsl:text> z01</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates>
        <xsl:with-param name="number-of-rows" select="$number-of-rows"/>
        <xsl:with-param name="number-of-cells" select="$number-of-cells"/>
        <xsl:with-param name="context-row" select="count(preceding-sibling::tei:row) + 1"/>
      </xsl:apply-templates>
    </tr>
  </xsl:template>
  <xsl:template name="cell-complexDisplay">
    <!-- Parameters passed through -->
    <xsl:param name="number-of-rows"/>
    <xsl:param name="number-of-cells"/>
    <xsl:param name="context-row"/>
    <xsl:choose>
      <!-- Heading cells -->
      <xsl:when test="@role='label'">
        <th>
          <xsl:call-template name="cell-att">
            <xsl:with-param name="number-of-rows" select="$number-of-rows"/>
            <xsl:with-param name="number-of-cells" select="$number-of-cells"/>
            <xsl:with-param name="context-row" select="$context-row"/>
          </xsl:call-template>
          <xsl:apply-templates/>
        </th>
      </xsl:when>
      <!-- Data cells -->
      <xsl:otherwise>
        <td>
          <xsl:call-template name="cell-att">
            <xsl:with-param name="number-of-rows" select="$number-of-rows"/>
            <xsl:with-param name="number-of-cells" select="$number-of-cells"/>
            <xsl:with-param name="context-row" select="$context-row"/>
          </xsl:call-template>
          <xsl:apply-templates/>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--  TABLE: simpleDisplay model  -->
  <xsl:template name="table-simpleDisplay">
    <div class="tbs">
      <xsl:call-template name="a-id"/>
      <!-- Type only changes if a project needs different formatting-->
      <div class="t01">
        <table>
          <xsl:if test="string(tei:head)">
            <xsl:call-template name="tableHead"/>
          </xsl:if>
          <xsl:if test="tei:row[@role='label']">
            <thead>
              <xsl:apply-templates select="tei:row[@role='label']"/>
            </thead>
          </xsl:if>
          <tbody>
            <xsl:apply-templates select="tei:row[@role='data' or not(@role)]"/>
          </tbody>
        </table>
      </div>
    </div>
  </xsl:template>
  <xsl:template name="row-simpleDisplay">
    <!-- Variable for alternate shading -->
    <xsl:variable name="oddeven">
      <xsl:call-template name="odd-even"/>
    </xsl:variable>
    <!-- Variable for counting rows -->
    <xsl:variable name="r-num">
      <xsl:call-template name="r-num"/>
    </xsl:variable>
    <tr>
      <xsl:attribute name="class">
        <xsl:value-of select="$r-num"/>
        <xsl:value-of select="$oddeven"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  <xsl:template name="cell-simpleDisplay">
    <!-- Variable for counting cells -->
    <xsl:variable name="c-num">
      <xsl:call-template name="c-num"/>
    </xsl:variable>
    <xsl:choose>
      <!-- Heading cells -->
      <xsl:when test="@role='label'">
        <th>
          <xsl:attribute name="class">
            <xsl:value-of select="$c-num"/>
          </xsl:attribute>
          <xsl:call-template name="thScope"/>
          <xsl:apply-templates/>
        </th>
      </xsl:when>
      <!-- Data cells -->
      <xsl:otherwise>
        <td>
          <xsl:attribute name="class">
            <xsl:value-of select="$c-num"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </td>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- COMPLEX TABLE: complexDisplay cell attribute template -->
  <xsl:template name="cell-att">
    <xsl:param name="number-of-rows"/>
    <xsl:param name="number-of-cells"/>
    <xsl:param name="context-row"/>
    <!-- Context cell position -->
    <xsl:variable name="con-cell-position" select="count(preceding-sibling::tei:cell)  +
      sum(preceding-sibling::tei:cell/@cols) - count(preceding-sibling::tei:cell/@cols) + 1"/>
    <xsl:variable name="updated-position">
      <xsl:call-template name="update-position">
        <xsl:with-param name="number-of-rows" select="$number-of-rows"/>
        <xsl:with-param name="number-of-cells" select="$number-of-cells"/>
        <xsl:with-param name="context-row" select="$context-row"/>
        <xsl:with-param name="con-cell" select="$con-cell-position"/>
        <!-- Cell position -->
        <xsl:with-param name="cell" select="1"/>
        <!-- Row position -->
        <xsl:with-param name="row" select="1"/>
        <!-- Total number of cells in the table -->
        <xsl:with-param name="count" select="count(ancestor::tei:table//tei:cell)"/>
        <xsl:with-param name="pos" select="$con-cell-position"/>
      </xsl:call-template>
    </xsl:variable>
    <!-- Output value of the column position -->
    <xsl:variable name="col-position">
      <xsl:choose>
        <!-- Test for last cell -->
        <!-- No spanning cell -->
        <xsl:when test="$updated-position = $number-of-cells">
          <xsl:text>x01</xsl:text>
        </xsl:when>
        <!-- Colspan on self -->
        <xsl:when test="$updated-position +@cols - 1 = $number-of-cells">
          <xsl:text>x01</xsl:text>
        </xsl:when>
        <!-- Normal numbering -->
        <xsl:otherwise>
          <xsl:text>c</xsl:text>
          <xsl:number format="01" value="$updated-position"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- ATTRIBUTE OUTPUTS -->
    <!-- class attributes including column position, rowspan and colspan -->
    <xsl:attribute name="class">
      <xsl:value-of select="$col-position"/>
      <xsl:if test="string(@rows) and not(@rows='1')">
        <xsl:text> rs</xsl:text>
        <xsl:value-of select="@rows"/>
      </xsl:if>
      <xsl:if test="string(@cols) and not(@cols='1')">
        <xsl:text> cs</xsl:text>
        <xsl:value-of select="@cols"/>
      </xsl:if>
    </xsl:attribute>
    <!-- rowspan and colspan attributes -->
    <xsl:if test="string(@rows) and not(@rows='1')">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="@rows"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="string(@cols) and not(@cols='1')">
      <xsl:attribute name="colspan">
        <xsl:value-of select="@cols"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  <!--
        Recursive template to calculate the position of cells in the table according to the previous cells. 
        The new position of the cell depends on the rowspans and colspans of the sibling cells and the cells in the
        previous rows.
    -->
  <xsl:template name="update-position">
    <xsl:param name="number-of-rows"/>
    <xsl:param name="number-of-cells"/>
    <xsl:param name="context-row"/>
    <xsl:param name="con-cell"/>
    <xsl:param name="cell"/>
    <xsl:param name="row"/>
    <xsl:param name="count"/>
    <xsl:param name="pos"/>
    <xsl:choose>
      <!-- Stop condition -->
      <xsl:when test="$count > 0">
        <!-- Update the count -->
        <xsl:variable name="new-count">
          <xsl:choose>
            <xsl:when test="ancestor::tei:table/tei:row[position() = $row]/tei:cell[position() =
              $cell]">
              <xsl:value-of select="$count - 1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$count"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="new-pos">
          <xsl:choose>
            <xsl:when test="ancestor::tei:table/tei:row[position() = $row and $context-row >
              position()]/tei:cell[position() = $cell and @rows]">
              <!-- Cases where preceding-siblings of the cell being tested have colspan -->
              <xsl:variable name="pre-cols" select="sum(ancestor::tei:table/tei:row[position() =
                $row]/tei:cell[position() = $cell]/preceding-sibling::tei:cell[$cell >
                position()]/@cols)"/>
              <!-- 
                The position of the context cell is updated if there are rowspans in previous cells of the previous rows and the
                column spans until the context cell position.
              -->
              <xsl:choose>
                <xsl:when test="$pos >= $cell + $pre-cols and $row +
                  ancestor::tei:table/tei:row[position() = $row]/tei:cell[position() = $cell]/@rows
                  - 1 >= $context-row">
                  <!-- 
                    Creates the value that is added to the context cell position. Where there are colspans, it adds the value of the colspan,
                    otherwise it just increases the value of the context cell by one.
                  -->
                  <xsl:variable name="step">
                    <xsl:choose>
                      <xsl:when test="ancestor::tei:table/tei:row[position() =
                        $row]/tei:cell[position() = $cell and @cols]">
                        <xsl:value-of select="ancestor::tei:table/tei:row[position() =
                          $row]/tei:cell[position() = $cell]/@cols"/>
                      </xsl:when>
                      <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:value-of select="$pos + $step"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$pos"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$pos"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- Position of the new cell being tested -->
        <xsl:variable name="new-cell">
          <xsl:choose>
            <xsl:when test="$number-of-cells > $cell">
              <xsl:value-of select="$cell + 1"/>
            </xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- Checks if the row position needs to be incremented -->
        <xsl:variable name="new-row">
          <xsl:choose>
            <xsl:when test="$cell = $number-of-cells">
              <xsl:value-of select="$row + 1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$row"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- 
          Recurs a call to the current template with the updated values of the context cell position, previous row position and previous cell
          position that was tested last. 
        -->
        <xsl:call-template name="update-position">
          <xsl:with-param name="number-of-rows" select="$number-of-rows"/>
          <xsl:with-param name="number-of-cells" select="$number-of-cells"/>
          <xsl:with-param name="context-row" select="$context-row"/>
          <xsl:with-param name="con-cell" select="$con-cell"/>
          <xsl:with-param name="cell" select="$new-cell"/>
          <xsl:with-param name="row" select="$new-row"/>
          <xsl:with-param name="count" select="$new-count"/>
          <xsl:with-param name="pos" select="$new-pos"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$pos"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--  END Table templates     -->
  <!--   NEW BIB SECTION     -->
  <xsl:template match="tei:listBibl">
    <ul>
      <xsl:apply-templates/>
    </ul>
  </xsl:template>
  <xsl:template match="tei:bibl[parent::tei:listBibl]">
    <li>
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  <xsl:template match="tei:listBibl/tei:head">
    <!-- This rendering is surely wrong, since caption is not a valid
         child of ul. -->
    <caption>
      <strong>
        <xsl:apply-templates/>
      </strong>
    </caption>
  </xsl:template>
  <xsl:template match="tei:title">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xsl:template match="tei:author">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
  <!--   BLOCKQUOTES   -->
  <xsl:template match="tei:q">
    <blockquote>
      <xsl:apply-templates/>
    </blockquote>
  </xsl:template>
  <!--   ADDRESSES   -->
  <xsl:template match="tei:address">
    <address>
      <xsl:apply-templates/>
    </address>
    <xsl:if test="following-sibling::tei:address">
      <br/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tei:addrLine">
    <!-- START automatic links or email addresses -->
    <xsl:choose>
      <xsl:when test="tei:email">
        <a href="mailto:{tei:email}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="tei:ref">
        <a href="{tei:ref/@target}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- END automatic links or email addresses -->
    <xsl:if test="following-sibling::tei:addrLine">
      <br/>
    </xsl:if>
  </xsl:template>
  <!--   FIGURES   -->
  <xsl:template match="tei:graphic">
    <xsl:if test="string(@url)">
      <xsl:call-template name="showFigure"/>
    </xsl:if>
  </xsl:template>
  <!-- Image dimensions -->
  <xsl:template name="img-dim">
    <xsl:param name="img-width"/>
    <xsl:param name="img-height"/>
    <xsl:attribute name="width">
      <xsl:value-of select="$img-width"/>
    </xsl:attribute>
    <xsl:attribute name="height">
      <xsl:value-of select="$img-height"/>
    </xsl:attribute>
  </xsl:template>
  <!-- Popup information -->
  <xsl:template name="img-popup">
    <xsl:param name="popup"/>
    <xsl:choose>
      <xsl:when test="string($popup)">
        <xsl:value-of select="$popup"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>x87</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:figDesc"/>
  <xsl:template match="tei:figure/tei:head"/>
  <xsl:template match="tei:figure">
    <xsl:choose>
      <xsl:when test="parent::tei:p and tei:head"/>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- SHOW FIGURE /// REDO IT ///-->
  <xsl:template name="showFigure">
    <!--   Find info for publication images  -->
    <!-- folder info -->
    <xsl:variable name="img-folder" select="concat($xmp:images-path, '/local')"/>
    <xsl:variable name="img-subpath-full" select="'full'"/>
    <xsl:variable name="img-subpath-thumb" select="'thumb'"/>
    <!-- file info -->
    <xsl:variable name="img-src" select="@url"/>
    <xsl:variable name="img-thm-prefix" select="'thm_'"/>
    <!-- path to images -->
    <xsl:variable name="img-path-full" select="concat($img-folder, '/', $img-subpath-full, '/',
      $img-src)"/>
    <xsl:variable name="img-path-thumb" select="concat($img-folder, '/', $img-subpath-thumb,
      '/thm_', $img-src)"/>
    <!-- Dimensions -->
    <xsl:variable name="img-width">
      <xsl:choose>
        <xsl:when test="@width">
          <xsl:value-of select="number(substring-before(@width, 'px'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="img-height">
      <xsl:choose>
        <xsl:when test="@height">
          <xsl:value-of select="number(substring-before(@height, 'px'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="img-max-height">
      <xsl:value-of select="max(ancestor::tei:list[starts-with(@type,
        'figure')]/tei:item/tei:graphic/number(substring-before(@height, 'px')))"/>
    </xsl:variable>
    <!-- Caption or description -->
    <xsl:variable name="img-cap-alt">
      <xsl:choose>
        <xsl:when test="parent::tei:figure/tei:figDesc">
          <xsl:value-of select="parent::tei:figure/tei:figDesc"/>
        </xsl:when>
        <xsl:when test="@n">
          <xsl:value-of select="@n"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="img-cap-desc" select="ancestor::tei:figure/tei:head"/>
    <!-- Rendition info -->
    <!-- extra width to delimit captions for the inline thumbnails -->
    <xsl:variable name="img-thm-plus-width" select="$img-width + 12"/>
    <!-- Use for the image: prefix with 's' and the div: prefix with 't' -->
    <xsl:variable name="img-left-right">
      <xsl:choose>
        <xsl:when test="contains(@rend, 'left')">
          <xsl:text>01</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@rend, 'right')">
          <xsl:text>02</xsl:text>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    <!-- Used on the anchor for thumb-captions -->
    <xsl:variable name="cap-left-right">
      <xsl:choose>
        <xsl:when test="contains(@rend, 'left')">
          <xsl:text>s03</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@rend, 'right')">
          <xsl:text>s04</xsl:text>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>
    <!-- Different popup options, x87: shrink to fit, x88 and x89 different html pages -->
    <xsl:variable name="popup">
      <xsl:choose>
        <xsl:when test="contains(@rend, 'img') or ancestor::table[@type='thumbnail'][@rend='img']">
          <xsl:text>x87</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@rend, 'html1') or
          ancestor::table[@type='thumbnail'][@rend='html1']">
          <xsl:text>x88</xsl:text>
        </xsl:when>
        <xsl:when test="contains(@rend, 'html2') or
          ancestor::table[@type='thumbnail'][@rend='html2']">
          <xsl:text>x89</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <!-- OUTPUT FIGURE TEMPLATE -->
    <xsl:choose>
      <!-- START Option 1: showing thumbnail lists -->
      <xsl:when test="ancestor::tei:list[@type='figure-full']">
        <dl style="width: {$img-width}px;">
          <!--<dt style="height: {$img-max-height}px;">-->
          <dt style="height: {$img-max-height}px;">
            <!-- Image -->
            <img src="{$img-path-full}">
              <!-- @alt info -->
                <xsl:attribute name="alt">
                  <xsl:value-of select="normalize-space($img-cap-alt)"/>
                </xsl:attribute>
            </img>
          </dt>
          <dd>
            <p>
              <xsl:value-of select="$img-cap-desc"/>
            </p>
          </dd>
        </dl>
      </xsl:when>
      <xsl:when test="ancestor::tei:list[@type='figure-thumb']">
        <dl style="width: {$img-width}px;">
          <dt style="height: {$img-max-height}px;">
            <!-- Full size popup -->
            <a class="x87" href="{$img-path-full}">
              <span>&#160;</span>
              <!-- Thumbnail image -->
              <img src="{$img-path-thumb}">
                <!-- @alt info -->
                  <xsl:attribute name="alt">
                    <xsl:value-of select="$img-cap-alt"/>
                  </xsl:attribute>
              </img>
            </a>
          </dt>
          <dd>
            <p>
              <xsl:value-of select="$img-cap-desc"/>
            </p>
          </dd>
        </dl>
      </xsl:when>
      <xsl:when test="ancestor::tei:list[@type='graphic-list']">
        <img src="{$img-path-full}">
          <!-- IMG @ALT INFO STARTS -->
          <xsl:attribute name="alt">
            <xsl:choose>
              <xsl:when test="string($img-cap-alt)">
                <xsl:value-of select="$img-cap-alt"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>empty</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <!-- IMG @ALT INFO ENDS -->
          <xsl:if test="$img-width != 0">
            <xsl:attribute name="width">
              <xsl:value-of select="$img-width"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="$img-height != 0">
            <xsl:attribute name="height">
              <xsl:value-of select="$img-height"/>
            </xsl:attribute>
          </xsl:if>
        </img>
      </xsl:when>
      <!-- START Option 2: Inline images -->
      <!-- Images with renditional information are treated differently, they can be thumbnails, thumbnails with captions or full sized images -->
      <xsl:when test="string(@rend)">
        <xsl:choose>
          <xsl:when test="@xmt:type='thumb'">
            <a href="{$img-path-full}">
              <xsl:attribute name="class">
                <xsl:value-of select="$cap-left-right"/>
                <xsl:text> </xsl:text>
                <xsl:call-template name="img-popup">
                  <xsl:with-param name="popup" select="$popup"/>
                </xsl:call-template>
              </xsl:attribute>
              <span>&#160;</span>
              <img class="s{$img-left-right}" src="{$img-path-thumb}">
                <!-- @alt info -->
                  <xsl:attribute name="alt">
                    <xsl:value-of select="$img-cap-alt"/>
                  </xsl:attribute>
              </img>
            </a>
          </xsl:when>
          <!-- Thumbnail with caption inline image -->
          <xsl:when test="@xmt:type='thumb-caption'">
            <div class="figure">
              <div class="t{$img-left-right}">
                <dl style="width: {$img-thm-plus-width}px;">
                  <dt>
                    <!-- Full size popup -->
                    <a href="{$img-path-full}">
                      <xsl:attribute name="class">
                        <xsl:value-of select="$cap-left-right"/>
                        <xsl:text> </xsl:text>
                        <xsl:call-template name="img-popup">
                          <xsl:with-param name="popup" select="$popup"/>
                        </xsl:call-template>
                      </xsl:attribute>
                      <span>&#160;</span>
                      <!-- Thumbnail image -->
                      <img class="s{$img-left-right}" src="{$img-path-thumb}">
                        <!-- @alt info -->
                          <xsl:attribute name="alt">
                            <xsl:value-of select="$img-cap-alt"/>
                          </xsl:attribute>
                      </img>
                    </a>
                  </dt>
                  <dd>
                    <xsl:value-of select="$img-cap-desc"/>
                  </dd>
                </dl>
              </div>
            </div>
          </xsl:when>
          <xsl:when test="@xmt:type='full'">
            <xsl:if test="not(preceding-sibling::tei:graphic[@xmt:type='thumb' or
              @xmt:type='thumb-caption'])">
              <img class="s{$img-left-right}" src="{$img-path-full}">
                <!-- @alt info -->
                  <xsl:attribute name="alt">
                    <xsl:value-of select="$img-cap-alt"/>
                  </xsl:attribute>
              </img>
            </xsl:if>
          </xsl:when>
          <!-- Full size inline image -->
          <xsl:otherwise>
            <img class="s{$img-left-right}" src="{$img-path-full}">
              <!-- @alt info -->
                <xsl:attribute name="alt">
                  <xsl:value-of select="$img-cap-alt"/>
                </xsl:attribute>
            </img>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- START Option 3: showing oneoff thumbnail -->
      <xsl:when test="@xmt:type='thumb-caption'">
        <!-- Displayed in a div unlike the thumbnails which are inline. -->
        <div class="image">
          <div class="t03">
            <dl style="width: {$img-thm-plus-width}px;">
              <dt>
                <!-- Full size popup -->
                <a href="{$img-path-full}">
                  <xsl:attribute name="class">
                    <xsl:call-template name="img-popup">
                      <xsl:with-param name="popup" select="$popup"/>
                    </xsl:call-template>
                  </xsl:attribute>
                  <span>&#160;</span>
                  <!-- Thumbnail image -->
                  <img class="s{$img-left-right}" src="{$img-path-thumb}">
                    <!-- @alt info -->
                      <xsl:attribute name="alt">
                        <xsl:value-of select="$img-cap-desc"/>
                      </xsl:attribute>
                  </img>
                </a>
              </dt>
              <dd>
                <xsl:value-of select="$img-cap-desc"/>
              </dd>
            </dl>
          </div>
        </div>
      </xsl:when>
      <xsl:when test="@xmt:type='thumb'">
        <a href="{$img-path-full}">
          <xsl:attribute name="class">
            <xsl:value-of select="$cap-left-right"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="img-popup">
              <xsl:with-param name="popup" select="$popup"/>
            </xsl:call-template>
          </xsl:attribute>
          <span>&#160;</span>
          <img class="s{$img-left-right}" src="{$img-path-thumb}">
            <!-- @alt info -->
              <xsl:attribute name="alt">
                <xsl:value-of select="$img-cap-alt"/>
              </xsl:attribute>
          </img>
        </a>
      </xsl:when>
      <!-- START Option 4: showing logo tables -->
      <xsl:when test="ancestor::tei:list/@type='logo'">
        <img src="{$img-path-full}">
          <!-- @alt info -->
          <xsl:attribute name="alt">
            <xsl:choose>
              <xsl:when test="string($img-cap-desc)">
                <xsl:value-of select="$img-cap-desc"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>logo</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <!-- dimension info -->
          <xsl:call-template name="img-dim">
            <xsl:with-param name="img-width" select="$img-width"/>
            <xsl:with-param name="img-height" select="$img-height"/>
          </xsl:call-template>
        </img>
      </xsl:when>
      <xsl:when test="@xmt:type='full'">
        <xsl:if test="not(preceding-sibling::tei:graphic[@xmt:type='thumb' or
          @xmt:type='thumb-caption'])">
          <div class="image">
            <div class="t03">
              <dl style="width: {$img-width}px;">
                <dt>
                  <img src="{$img-path-full}">
                    <!-- @alt info -->
                      <xsl:attribute name="alt">
                        <xsl:value-of select="$img-cap-desc"/>
                      </xsl:attribute>
                    <!-- dimension info -->
                    <xsl:call-template name="img-dim">
                      <xsl:with-param name="img-width" select="$img-width"/>
                      <xsl:with-param name="img-height" select="$img-height"/>
                    </xsl:call-template>
                  </img>
                </dt>
                <dd>
                  <xsl:value-of select="$img-cap-desc"/>
                </dd>
              </dl>
            </div>
          </div>
        </xsl:if>
      </xsl:when>
      <!-- START Default: show full image -->
      <xsl:otherwise>
        <!-- Changed: div is centered -->
        <div class="image">
          <div class="t03">
            <dl style="width: {$img-width}px;">
              <dt>
                <img src="{$img-path-full}">
                  <!-- @alt info -->
                    <xsl:attribute name="alt">
                      <xsl:value-of select="$img-cap-desc"/>
                    </xsl:attribute>
                  <!-- dimension info -->
                  <xsl:call-template name="img-dim">
                    <xsl:with-param name="img-width" select="$img-width"/>
                    <xsl:with-param name="img-height" select="$img-height"/>
                  </xsl:call-template>
                </img>
              </dt>
              <dd>
                <xsl:value-of select="$img-cap-desc"/>
              </dd>
            </dl>
          </div>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--   PHRASE LEVEL   -->
  <!--   LINKS: xref   -->
  <xsl:template match="tei:ref">
    <xsl:choose>
      <xsl:when test="@type  = 'external' or @rend = 'external'">
        <a href="{@target}">
          <xsl:call-template name="external-link"/>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:when test="@cRef">
        <xsl:choose>
          <xsl:when test="contains(@cRef, '#')">
            <xsl:variable name="file" select="substring-before(@cRef, '#')"/>
            <xsl:variable name="title" select="//xmmf:file[@xml:id = $file]/@title"/>
            <xsl:variable name="path" select="//xmmf:file[@xml:id = $file]/@path"/>
            <xsl:variable name="anchor" select="substring-after(@cRef, '#')"/>
            <a title="Link internal to this page">
              <xsl:attribute name="href">
                <xsl:if test="string($file)">
                  <xsl:value-of select="$path"/>
                </xsl:if>
                <xsl:text>#</xsl:text>
                <xsl:value-of select="$anchor"/>
              </xsl:attribute>
              <xsl:call-template name="internal-link">
                <xsl:with-param name="title" select="$title"/>
              </xsl:call-template>
              <xsl:apply-templates/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="file" select="@cRef"/>
            <xsl:variable name="title" select="//xmmf:file[@xml:id = $file]/@title"/>
            <xsl:variable name="path" select="//xmmf:file[@xml:id = $file]/@path"/>
            <a>
              <xsl:call-template name="internal-link">
                <xsl:with-param name="title" select="$title"/>
              </xsl:call-template>
              <xsl:attribute name="href">
                <xsl:value-of select="$xmp:context-path"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$path"/>
              </xsl:attribute>
              <xsl:apply-templates/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="@target">
        <a>
          <xsl:attribute name="href">
            <xsl:if test="starts-with(@target, '/')">
              <xsl:value-of select="$xmp:context-path"/>
            </xsl:if>
            <!-- This is well dodgy. -->
            <xsl:value-of select="@target"/>
          </xsl:attribute>
          <xsl:apply-templates/>
        </a>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <!-- href classes for same or new window -->
  <xsl:template name="external-link">
    <!-- Title information and extra class for if external window -->
    <xsl:choose>
      <!-- Open in a new window -->
      <xsl:when test="@rend='newWindow'">
        <xsl:attribute name="class">
          <xsl:text>extNew</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="rel">
          <xsl:text>external</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>External website (Opens in a new window)</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <!-- Open in same window -->
      <xsl:otherwise>
        <xsl:attribute name="class">
          <xsl:text>ext</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>External website</xsl:text>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="internal-link">
    <xsl:param name="title"/>
    <!-- Title information and extra class for if external window -->
    <xsl:choose>
      <!-- Open in a new window -->
      <xsl:when test="@rend='newWindow'">
        <xsl:attribute name="class">
          <xsl:text>intNew</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="rel">
          <xsl:text>external</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>Link to </xsl:text>
          <xsl:value-of select="$title"/>
          <xsl:text> (Opens in a new window)</xsl:text>
        </xsl:attribute>
      </xsl:when>
      <!-- Open in same window -->
      <xsl:otherwise>
        <xsl:attribute name="class">
          <xsl:text>int</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="title">
          <xsl:text>Link to </xsl:text>
          <xsl:value-of select="$title"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:email">
    <a class="mail" href="mailto:{@xmt:target}" title="Email link">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  <xsl:template match="xmt:download">
    <a class="file">
      <xsl:attribute name="title">
        <xsl:text>File Link (</xsl:text>
        <xsl:value-of select="substring-after(@target, '.')"/>
        <xsl:text>file)</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="href">
        <!--<xsl:value-of select="$linkroot"/>-->
        <xsl:text>/redist/</xsl:text>
        <xsl:value-of select="@target"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </a>
  </xsl:template>
  <xsl:template match="tei:anchor">
    <a id="{@xml:id}"/>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="tei:ptr">
    <a href="{@target}">
      <xsl:choose>
        <xsl:when test="starts-with(@target, 'http://')">
          <xsl:call-template name="external-link" />
        </xsl:when>
        <xsl:when test="starts-with(@target, '#')">
          <xsl:attribute name="title">
            <xsl:text>Link internal to this page</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="title">
            <xsl:text>Encoding error: @target does not start with 'http://' and not internal link</xsl:text>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@target" />
    </a>
  </xsl:template>
  <!--  UBI     -->
  <xsl:template match="tei:hi">
    <xsl:choose>
      <!-- ITALICS -->
      <xsl:when test="@rend='italic'">
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:when>
      <!-- BOLD -->
      <xsl:when test="@rend='bold'">
        <strong>
          <xsl:apply-templates/>
        </strong>
      </xsl:when>
      <!-- BOLD AND ITALICS -->
      <xsl:when test="@rend='bolditalic'">
        <strong>
          <em>
            <xsl:apply-templates/>
          </em>
        </strong>
      </xsl:when>
      <xsl:when test="@rend='sup'">
        <sup>
          <xsl:apply-templates/>
        </sup>
      </xsl:when>
      <xsl:when test="@rend='sub'">
        <sub>
          <xsl:apply-templates/>
        </sub>
      </xsl:when>
      <!-- CURRENT DEFAULT: italics -->
      <xsl:otherwise>
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--   FOOTNOTES     -->
  <xsl:template match="tei:note">
    <sup>
      <a class="fnLink">
        <xsl:attribute name="href">
          <xsl:text>#fn</xsl:text>
          <xsl:number format="01" from="tei:text" level="any"/>
        </xsl:attribute>
        <xsl:attribute name="id">
          <xsl:text>fnLink</xsl:text>
          <xsl:number format="01" from="tei:text" level="any"/>
        </xsl:attribute>
        <xsl:number from="tei:text" level="any"/>
      </a>
    </sup>
    <!--  TOOK OUT THIS: count="note" from="group/text" -->
  </xsl:template>
  <!--   VARIOUS TERMS   -->
  <xsl:template match="tei:foreign">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xsl:template match="tei:rs">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
  <xsl:template match="tei:date[not(ancestor::tei:bibl)]">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
  <xsl:template match="tei:emph">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  <xsl:template match="tei:code">
    <pre>
    <xsl:apply-templates/>
  </pre>
  </xsl:template>
  <xsl:template match="tei:eg">
    <code>
      <xsl:apply-templates/>
    </code>
  </xsl:template>
  <xsl:template match="tei:ab">
    <xsl:choose>
      <xsl:when test="@type='form'">
        <form method="post" name="{@xml:id}">
          <xsl:attribute name="action">
            <!--  probably:  http://curlew.cch.kcl.ac.uk/cgi-bin/doemail.pl-->
          </xsl:attribute>
          <input name="script" type="hidden" value="crsbi_fb"/>
          <p class="content">
            <xsl:for-each select="tei:seg[@type='input']">
              <xsl:value-of select="preceding-sibling::tei:label[1]"/>
              <xsl:text>:</xsl:text>
              <br/>
              <input style="background-color: rgb(255, 255, 160);" type="text">
                <xsl:choose>
                  <xsl:when test="contains(preceding-sibling::tei:label[1],'(')">
                    <xsl:attribute name="id">
                      <xsl:value-of select="substring-before(preceding-sibling::tei:label[1], '(')"
                      />
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="contains(preceding-sibling::tei:label[1],':')">
                    <xsl:attribute name="id">
                      <xsl:value-of select="substring-before(preceding-sibling::tei:label[1], ':')"
                      />
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="preceding-sibling::tei:label[1]"/>
                  </xsl:otherwise>
                </xsl:choose>
              </input>
              <br/>
            </xsl:for-each>
          </p>
          <xsl:if test="tei:seg[@type='textfield']">
            <xsl:for-each select="tei:seg[@type='textfield']">
              <p class="content">
                <xsl:value-of select="preceding-sibling::tei:label[1]"/>
                <xsl:text>:</xsl:text>
              </p>
              <p class="content">
                <textarea cols="40" rows="6">
                  <xsl:choose>
                    <xsl:when test="contains(preceding-sibling::tei:label[1],'(')">
                      <xsl:attribute name="id">
                        <xsl:value-of select="substring-before(preceding-sibling::tei:label[1],
                          '(')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="contains(preceding-sibling::tei:label[1],':')">
                      <xsl:attribute name="id">
                        <xsl:value-of select="substring-before(preceding-sibling::tei:label[1],
                          ':')"/>
                      </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="preceding-sibling::tei:label[1]"/>
                    </xsl:otherwise>
                  </xsl:choose> &#x00A0; </textarea>
              </p>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="tei:list[@type='select']">
            <p class="content">
              <label for="fe01">
                <xsl:value-of select="tei:list[@type='select']/preceding-sibling::tei:label[1]"/>
                <xsl:text>: </xsl:text>
              </label>
              <select id="fe01" name="fe01">
                <option selected="selected"> Please select... </option>
                <xsl:for-each select="tei:list[@type='select']/tei:item">
                  <option value="{.}">
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text> </xsl:text>
                  </option>
                </xsl:for-each>
              </select>
            </p>
          </xsl:if>
          <p class="content">
            <input name="Submit" type="submit" value="Submit"/>
            <input name="Reset" type="reset" value="Reset"/>
          </p>
        </form>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--   SEARCHABLE TESTS   -->
  <xsl:template match="tei:name">
    <span>
      <xsl:attribute name="id">
        <xsl:value-of select="ancestor::tei:TEI/@xml:id"/>
        <xsl:text>-</xsl:text>
        <xsl:number level="any"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
</xsl:stylesheet>
