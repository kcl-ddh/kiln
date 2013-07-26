<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="files" mode="text-index">
    <table class="tablesorter">
      <thead>
        <tr>
          <th>Filename</th>
          <th>XML ID</th>
          <th>Title</th>
          <th>Author</th>
          <th>Editor</th>
          <th>Publication Date</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates mode="text-index" select="file" />
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="files[not(file)]" mode="text-index">
    <p>There are no TEI files in webapps/ROOT/content/xml/tei! Put
    some there and this page will become much more interesting.</p>
  </xsl:template>

  <xsl:template match="file" mode="text-index">
    <tr>
      <td><a href="{@path}"><xsl:value-of select="@xml_path" /></a></td>
      <td><xsl:value-of select="@id" /></td>
      <td><xsl:value-of select="@title" /></td>
      <td><xsl:value-of select="@author" /></td>
      <td><xsl:value-of select="@editor" /></td>
      <td><xsl:value-of select="@publication_date" /></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
