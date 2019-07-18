<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="kiln:same" mode="escape-xml">
    <xsl:param name="depth" select="0" />
    <xsl:if test="not(node-name(preceding-sibling::*[1]) = node-name(.))">
      <xsl:call-template name="escape-xml-indent">
        <xsl:with-param name="depth" select="$depth" />
      </xsl:call-template>
      <span class="test-same-output">[...]</span>
      <xsl:text>
</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="kiln:text" mode="escape-xml">
    <span class="test-different-output">
      <xsl:value-of select="." />
    </span>
  </xsl:template>

  <xsl:template match="*" mode="escape-xml">
    <xsl:param name="depth" select="0" />
    <xsl:call-template name="escape-xml-indent">
      <xsl:with-param name="depth" select="$depth" />
    </xsl:call-template>
    <xsl:call-template name="render-element-part">
      <xsl:with-param name="part" select="concat('&lt;', name(.))" />
    </xsl:call-template>
    <xsl:apply-templates mode="escape-xml" select="@*" />
    <xsl:call-template name="render-element-part">
      <xsl:with-param name="part" select="'&gt;'" />
    </xsl:call-template>
    <xsl:if test="*">
      <xsl:text>
</xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="escape-xml">
      <xsl:with-param name="depth" select="$depth + 1" />
    </xsl:apply-templates>
    <xsl:if test="*">
      <xsl:call-template name="escape-xml-indent">
        <xsl:with-param name="depth" select="$depth" />
      </xsl:call-template>
    </xsl:if>
    <xsl:call-template name="render-element-part">
      <xsl:with-param name="part" select="concat('&lt;/', name(.), '&gt;')" />
    </xsl:call-template>
    <xsl:text>
</xsl:text>
  </xsl:template>

  <xsl:template match="@kiln:same-attributes" mode="escape-xml" priority="100" />
  <xsl:template match="@kiln:same-element" mode="escape-xml" priority="100" />

  <xsl:template match="@*" mode="escape-xml" priority="10">
    <xsl:text> </xsl:text>
    <xsl:choose>
      <xsl:when test="contains(../@kiln:same-attributes, concat(' ', node-name(.), ' '))">
        <span class="test-same-output">
          <xsl:call-template name="render-attribute" />
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="render-attribute" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="kiln:test" mode="output">
    <h4><xsl:value-of select="@id" /></h4>

    <p><xsl:value-of select="kiln:description" /></p>

    <xsl:apply-templates mode="output" select="kiln:result" />
  </xsl:template>

  <xsl:template match="kiln:result" mode="output">
    <table>
      <thead>
        <tr>
          <th scope="col">Actual output</th>
          <th scope="col">Expected output</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>
            <pre class="test-output-diff">
              <xsl:apply-templates mode="escape-xml" select="kiln:actual/*" />
            </pre>
          </td>
          <td>
            <pre class="test-output-diff">
              <xsl:apply-templates mode="escape-xml" select="kiln:expected/*" />
            </pre>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="kiln:tests" mode="output">
    <h3><xsl:value-of select="@path" /></h3>

    <p><xsl:value-of select="kiln:description" /></p>

    <xsl:apply-templates mode="output" select="kiln:test[kiln:result/@pass='false']" />
  </xsl:template>

  <xsl:template match="kiln:test" mode="summary">
    <tr>
      <xsl:if test="position() = 1">
        <th rowspan="{count(../kiln:test)}">
          <xsl:value-of select="../@path" />
        </th>
      </xsl:if>
      <td><xsl:value-of select="@id" /></td>
      <td>
        <xsl:apply-templates mode="summary" select="kiln:result/@pass" />
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="kiln:tests" mode="summary">
    <xsl:apply-templates mode="summary" select="kiln:test" />
  </xsl:template>

  <xsl:template match="kiln:result/@pass" mode="summary">
    <xsl:variable name="result">
      <xsl:choose>
        <xsl:when test=". = 'true'">
          <xsl:text>pass</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>fail</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <span class="{concat('test-result-', $result)}">
      <xsl:value-of select="$result" />
    </span>
  </xsl:template>

  <xsl:template name="escape-xml-indent">
    <xsl:param name="depth" />
    <xsl:if test="$depth &gt; 0">
      <xsl:text>    </xsl:text>
      <xsl:call-template name="escape-xml-indent">
        <xsl:with-param name="depth" select="$depth - 1" />
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="render-attribute">
    <xsl:value-of select="name(.)" />
    <xsl:text>="</xsl:text>
    <xsl:value-of select="." />
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template name="render-element-part">
    <xsl:param name="part" />
    <xsl:choose>
      <xsl:when test="@kiln:same-element='true'">
        <span class="test-same-output">
          <xsl:value-of select="$part" />
        </span>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$part" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
