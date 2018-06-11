<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="base-uri" />

  <xsl:template name="field_file_path">
    <!-- The file_path field for user indices should be the same for
         all indices defined in the same index file, as they are all
         indexed together and so existing entries need to be deleted
         together. -->
    <field name="file_path">
      <xsl:text>indices/</xsl:text>
      <xsl:value-of select="$subdirectory" />
    </field>
  </xsl:template>

  <xsl:template name="field_index_instance_location">
    <field name="index_instance_location">
      <!-- This field contains a combination of the following:

             * The content/xml subdirectory containing the indexed
             field, to be used in generating the map:match id used in
             generating the URL of the document containing this
             instance, via kiln:url-for-match. (This is the
             $subdirectory parameter.)

             * The path to the file (minus extension) this instance
             belongs to, relative to the content subdirectory (ie, the
             value in the preceding item), to be passed to the
             kiln:url-for-match call to generate the URL of the
             document containing this instance.

             * The text part numbers in descending hierarchical
             sequence for the instance, separated by ".".

             * The line number of the instance.

             * A Boolean marker (0 or 1) marking if the instance is
             partially or completely restored (1) or not (0).

           Each part is separated by "#" for parsing in the query
           results.

      -->
      <xsl:variable name="filepath" select="substring-before(ancestor::file[1]/@path, '.xml')" />
      <xsl:value-of select="$subdirectory" />
      <xsl:text>#</xsl:text>
      <xsl:value-of select="$filepath" />
      <xsl:text>#</xsl:text>
      <xsl:for-each select="ancestor::tei:div[@type='textpart']/@n">
        <xsl:value-of select="." />
        <xsl:if test="position() != last()">
          <xsl:text>.</xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>#</xsl:text>
      <xsl:value-of select="preceding::tei:lb[1]/@n" />
      <xsl:text>#</xsl:text>
      <xsl:choose>
        <xsl:when test="descendant::tei:supplied or ancestor::tei:supplied">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>

</xsl:stylesheet>
