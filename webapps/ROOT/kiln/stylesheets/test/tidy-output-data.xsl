<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Remove unwanted xml:base due to XInclude from actual and
       expected data.

       This is a serious problem gnawing at the very roots of the
       entire test system. Cocoon 2.1.12 added in compulsory base URI
       fixup to the XInclude processor, which means the actual and
       expected outputs get an xml:base attribute, whether it had one
       before or not. These will not match, ever, so they must be
       removed. This means that we cannot ever test that the root
       element of the actual output has the correct xml:base attribute
       (if it were to have one). So sad, but not having every test
       fail is better. -->

  <xsl:strip-space elements="*"/>

  <xsl:template match="kiln:actual/*/@xml:base" />
  <xsl:template match="kiln:expected/*/@xml:base" />

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
