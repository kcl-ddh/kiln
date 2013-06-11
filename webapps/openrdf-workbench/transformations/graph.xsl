<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:sparql="http://www.w3.org/2005/sparql-results#"
	xmlns="http://www.w3.org/1999/xhtml">

	<xsl:include href="../locale/messages.xsl" />

	<xsl:variable name="title">
		<xsl:value-of select="$query-result.title" />
		<xsl:text> (</xsl:text>
		<xsl:value-of select="count(//sparql:result)" />
		<xsl:text>)</xsl:text>
	</xsl:variable>

	<xsl:include href="template.xsl" />

	<xsl:include href="table.xsl" />

	<xsl:template match="sparql:sparql">
		<script type="text/javascript">
			<![CDATA[
			function addGraphParam(name) {
				var value = document.getElementById(name).value;
				var url = document.location.href;
				if (url.indexOf('?') + 1 || url.indexOf(';') + 1) {
					document.location.href = url + decodeURIComponent('%26') + name + '=' + encodeURIComponent(value);
				} else {
					document.location.href = url + ';' + name + '=' + encodeURIComponent(value);
				}
			}
			]]>
		</script>
		<form>
			<table class="dataentry">
				<tbody>
					<tr>
						<th>
							<xsl:value-of
								select="$download-format.label" />
						</th>
						<td>
							<select id="Accept" name="Accept">
								<xsl:for-each
									select="$info//sparql:binding[@name='graph-download-format']">
									<option
										value="{substring-before(sparql:literal, ' ')}">
										<xsl:if
											test="$info//sparql:binding[@name='default-Accept']/sparql:literal = substring-before(sparql:literal, ' ')">
											<xsl:attribute
												name="selected">true</xsl:attribute>
										</xsl:if>
										<xsl:value-of
											select="substring-after(sparql:literal, ' ')" />
									</option>
								</xsl:for-each>
							</select>
						</td>
						<td>
							<input type="submit"
								onclick="addGraphParam('Accept');return false"
								value="{$download.label}" />
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<form>
			<table class="dataentry">
				<tbody>
					<tr>
						<th>
							<xsl:value-of select="$result-limit.label" />
						</th>
						<td>
							<xsl:call-template name="limit-select">
								<xsl:with-param name="onchange">
									addGraphParam('limit');
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td id="result-limited">
							<xsl:if
								test="$info//sparql:binding[@name='default-limit']/sparql:literal = count(//sparql:result)">
								<xsl:value-of
									select="$result-limited.desc" />
							</xsl:if>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<table class="data">
			<xsl:apply-templates select="*" />
		</table>
	</xsl:template>

</xsl:stylesheet>
