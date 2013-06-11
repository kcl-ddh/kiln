<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE rdf:RDF [
   <!ENTITY xsd  "http://www.w3.org/2001/XMLSchema#" >
 ]>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:sparql="http://www.w3.org/2005/sparql-results#" xmlns="http://www.w3.org/1999/xhtml">

	<xsl:include href="../locale/messages.xsl" />

	<xsl:variable name="title">
		<xsl:value-of select="$repository-delete.title" />
	</xsl:variable>

	<xsl:include href="template.xsl" />

	<xsl:template match="sparql:sparql">
		<script src="../../scripts/delete.js" type="text/javascript">
		</script>
		<form action="delete" method="post" onsubmit="return checkIsSafeToDelete();">
			<table class="dataentry">
				<tbody>
					<tr>
						<th>
							<xsl:value-of select="$repository.label" />
						</th>
						<td>
							<select id="id" name="id">
								<option value=""></option>
								<xsl:for-each
									select="//sparql:result[sparql:binding[@name='id']/sparql:literal/text()!='SYSTEM']">
									<option value="{sparql:binding[@name='id']/sparql:literal}">
										<xsl:value-of select="sparql:binding[@name='id']/sparql:literal" />
										-
										<xsl:value-of
											select="sparql:binding[@name='description']/sparql:literal" />
									</option>
								</xsl:for-each>
							</select>
						</td>
						<td></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="2">
							<input type="submit" value="{$delete.label}" />
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</xsl:template>

</xsl:stylesheet>
