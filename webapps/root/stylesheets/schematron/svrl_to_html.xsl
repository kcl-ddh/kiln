<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Import the Kiln version of this XSLT for default HTML
       rendering. Project-specific customisations are made in this
       file. -->
  <xsl:import href="../../kiln/stylesheets/schematron/svrl_to_html.xsl"/>

  <!-- File path of document being validated. -->
  <xsl:param name="file" select="''"/>

</xsl:stylesheet>
