<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Copies the source XML, removing any unused namespace
       declarations.

       Due to Cocoon's XInclude handling, there are occasions when the
       same XInclude namespace declaration will be made more than once
       on an element, which is a validity error. (This appears to be
       anticipated in paragraph four of section 4.5 of the XInclude
       spec.)

       Rather than use different prefixes for different XIncludes,
       this XSLT will just remove any unwanted namespace declarations
       from the source document, which also avoids the issue. -->

  <xsl:template match="/">
    <xsl:copy-of select="." />
  </xsl:template>

</xsl:stylesheet>
