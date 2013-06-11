<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:sparql="http://www.w3.org/2005/sparql-results#" xmlns="http://www.w3.org/1999/xhtml">

	<xsl:include href="../locale/messages.xsl" />

	<xsl:variable name="title">
		<xsl:value-of select="$update.title" />
	</xsl:variable>

	<xsl:include href="template.xsl" />

	<xsl:template match="sparql:sparql">
		<script src="../../scripts/update.js" type="text/javascript">
		</script>
		<form action="update" method="POST" onsubmit="return doSubmit()">
			<table class="dataentry">
				<tbody>
					<tr>
						<th>
							<xsl:value-of select="$query-language.label" />
						</th>
						<td>
							<select id="queryLn" name="queryLn" onchange="loadNamespaces()">
								<option value="SPARQL" selected="true">
									SPARQL
								</option>
							</select>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$update-string.label" />
						</th>
						<td>
							<textarea id="update" name="update" rows="16" cols="80">
							</textarea>
						</td>
						<td></td>
					</tr>
					<tr>
						<td></td>
						<td>
							<span id="updateString.errors" class="error">
								<xsl:value-of select="//sparql:binding[@name='error-message']" />
							</span>
						</td>
					</tr>
					<tr>
						<td></td>
						<td colspan="2">
							<input type="submit" value="{$execute.label}" />
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<pre id="SPARQL-namespaces" style="display:none">
			<xsl:for-each
				select="document(//sparql:link[@href='namespaces']/@href)//sparql:results/sparql:result">
				<xsl:value-of
					select="concat('PREFIX ', sparql:binding[@name='prefix']/sparql:literal, ':&lt;', sparql:binding[@name='namespace']/sparql:literal, '&gt;')" />
				<xsl:text>
</xsl:text>
			</xsl:for-each>
		</pre>
	</xsl:template>

</xsl:stylesheet>
