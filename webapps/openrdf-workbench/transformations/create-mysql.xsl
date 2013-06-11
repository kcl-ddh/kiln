<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE rdf:RDF [
   <!ENTITY xsd  "http://www.w3.org/2001/XMLSchema#" >
 ]>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:sparql="http://www.w3.org/2005/sparql-results#" xmlns="http://www.w3.org/1999/xhtml">

	<xsl:include href="../locale/messages.xsl" />

	<xsl:variable name="title">
		<xsl:value-of select="$repository-create.title" />
	</xsl:variable>

	<xsl:include href="template.xsl" />

	<xsl:template match="sparql:sparql">
		<script src="../../scripts/create.js" type="text/javascript">
		</script>
		<form action="create" method="post">
			<table class="dataentry">
				<tbody>
					<tr>
						<th>
							<xsl:value-of select="$repository-type.label" />
						</th>
						<td>
							<select id="type" name="type">
								<option value="mysql">
									MySql RDF Store
								</option>
							</select>
						</td>
						<td></td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$repository-id.label" />
						</th>
						<td>
							<input type="text" id="id" name="Repository ID" size="16"
								value="mysql" />
						</td>
						<td></td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$repository-title.label" />
						</th>
						<td>
							<input type="text" id="title" name="Repository title" size="48"
								value="MySQL Store" />
						</td>
						<td></td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$jdbc-driver.label" />
						</th>
						<td>
							<input type="text" id="driver" name="JDBC driver" size="32"
								value="com.mysql.jdbc.Driver" />
						</td>
						<td></td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$jdbc-host.label" />
						</th>
						<td>
							<input type="text" id="host" name="Host" size="32" value="localhost" />
						</td>
						<td></td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$jdbc-port.label" />
						</th>
						<td>
							<input type="text" id="port" name="Port" size="4" value="3306" />
						</td>
						<td></td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$jdbc-database.label" />
						</th>
						<td>
							<input type="text" id="database" name="Database" size="32"
								value="sesame_store" />
						</td>
						<td></td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$jdbc-properties.label" />
						</th>
						<td>
							<input type="text" id="properties" name="Connection properties"
								size="32" />
						</td>
						<td></td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$jdbc-user.label" />
						</th>
						<td>
							<input type="text" id="user" name="User name" size="32" />
						</td>
						<td></td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$jdbc-password.label" />
						</th>
						<td>
							<input type="text" id="password" name="Password" size="32" />
						</td>
						<td></td>
					</tr>
					<tr>
						<th>
							<xsl:value-of select="$max-triple-tables.label" />
						</th>
						<td>
							<input type="text" id="maxTripleTables" name="Max number of triple tables"
								size="6" value="256" />
						</td>
						<td></td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input type="button" value="{$cancel.label}" style="float:right"
								href="repositories" onclick="document.location.href=this.getAttribute('href')" />
							<input id="create" type="button" value="{$create.label}"
								onclick="checkOverwrite()" />
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</xsl:template>

</xsl:stylesheet>
