<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE rdf:RDF [
   <!ENTITY xsd  "http://www.w3.org/2001/XMLSchema#" >
   <!ENTITY rdf  "http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
   <!ENTITY rdfs  "http://www.w3.org/2000/01/rdf-schema#" >
 ]>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:sparql="http://www.w3.org/2005/sparql-results#"
	xmlns="http://www.w3.org/1999/xhtml">

	<xsl:include href="../locale/messages.xsl" />

	<xsl:variable name="title">
		<xsl:value-of select="$explore.title" />
	</xsl:variable>

	<xsl:variable name="nextX.label">
		<xsl:value-of select="$next.label" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="count(//sparql:result)" />
	</xsl:variable>

	<xsl:variable name="previousX.label">
		<xsl:value-of select="$previous.label" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="count(//sparql:result)" />
	</xsl:variable>

	<xsl:include href="template.xsl" />

	<xsl:include href="table.xsl" />

	<xsl:template name="sort-list">
		<xsl:param name="title" />
		<xsl:param name="list" />
		<div>
			<h3>
				<xsl:value-of select="$title" />
			</h3>
			<ul>
				<xsl:for-each select="$list">
					<xsl:sort select="." />
					<li>
						<xsl:apply-templates select="." />
					</li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="sparql:sparql">
		<script src="../../scripts/paging.js" type="text/javascript">  </script>
		<script src="../../scripts/explore.js" type="text/javascript">  </script>
		<xsl:if test="$info//sparql:binding[@name='default-limit']/sparql:literal = count(//sparql:result)">
		<p id="result-limited">
			<xsl:value-of select="$result-limited.desc" />
		</p>
		</xsl:if>
		<xsl:if
			test="1 = count(//sparql:result/sparql:binding[@name='predicate']/sparql:uri[text() = '&rdfs;label'])">
			<xsl:for-each
				select="//sparql:result[sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;label']">
				<h2>
					<xsl:value-of
						select="sparql:binding[@name='object']/sparql:literal" />
				</h2>
			</xsl:for-each>
		</xsl:if>
		<xsl:if
			test="1 = count(//sparql:result/sparql:binding[@name='predicate']/sparql:uri[text() = '&rdfs;comment'])">
			<xsl:for-each
				select="//sparql:result[sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;comment']">
				<p>
					<xsl:value-of
						select="sparql:binding[@name='object']/sparql:literal" />
				</p>
			</xsl:for-each>
		</xsl:if>
		<form action="explore">
			<table class="dataentry">
				<tbody>
					<tr>
						<th>
							<xsl:value-of select="$resource.label" />
						</th>
						<td colspan="2">
							<input id="resource" name="resource"
								size="48" type="text" />
						</td>
						<td></td>
					</tr>
				</tbody>
			</table>
			<table class="dataentry">
				<tbody>
					<tr>
						<td></td>
						<td>
							<span class="error">
								<xsl:value-of
									select="//sparql:binding[@name='error-message']" />
							</span>
						</td>
						<td></td>
					</tr>

					<tr>
						<th>
							<xsl:value-of select="$result-limit.label" />
						</th>
						<td>
							<xsl:call-template name="limit-select">
								<xsl:with-param name="onchange">addLimit();</xsl:with-param>
							</xsl:call-template>
						</td>
						<td></td>
					</tr>
					<tr>
					    <th>
							<xsl:value-of select="$result-offset.label" />
				        </th>
						<td>
							<input id="previousX" type="button"
								value="{$previousX.label}" onclick="previousOffset();" />
						</td>
						<td>
							<input id="nextX" type="button"
								value="{$nextX.label}" onclick="nextOffset();" />
						</td>
					</tr>
						<tr>
						<th>
							<xsl:value-of select="$show-datatypes.label" />
						</th>
						<td>
							<input type="checkbox" name="show-datatypes" value="show-dataypes" checked="checked" />
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		
		<table class="simple">
			<tr>
				<td>
					<xsl:if
						test="//sparql:result/sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;subClassOf'">
						<xsl:call-template name="sort-list">
							<xsl:with-param name="title"
								select="$super-classes.title" />
							<xsl:with-param name="list"
								select="//sparql:result[sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;subClassOf']/sparql:binding[@name='object']" />
						</xsl:call-template>
						<xsl:call-template name="sort-list">
							<xsl:with-param name="title"
								select="$sub-classes.title" />
							<xsl:with-param name="list"
								select="//sparql:result[sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;subClassOf']/sparql:binding[@name='subject']" />
						</xsl:call-template>
					</xsl:if>
				</td>
				<td>
					<xsl:if
						test="//sparql:result/sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;domain'">
						<xsl:call-template name="sort-list">
							<xsl:with-param name="title"
								select="$properties.title" />
							<xsl:with-param name="list"
								select="//sparql:result[sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;domain']/sparql:binding[@name='subject']" />
						</xsl:call-template>
						<xsl:if
							test="//sparql:result/sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;subPropertyOf'">
							<xsl:call-template name="sort-list">
								<xsl:with-param name="title"
									select="$super-properties.title" />
								<xsl:with-param name="list"
									select="//sparql:result[sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;subPropertyOf']/sparql:binding[@name='object']" />
							</xsl:call-template>
							<xsl:call-template name="sort-list">
								<xsl:with-param name="title"
									select="$sub-properties.title" />
								<xsl:with-param name="list"
									select="//sparql:result[sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;subPropertyOf']/sparql:binding[@name='subject']" />
							</xsl:call-template>
						</xsl:if>
						<xsl:call-template name="sort-list">
							<xsl:with-param name="title"
								select="$property-domain.title" />
							<xsl:with-param name="list"
								select="//sparql:result[sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;domain']/sparql:binding[@name='object']" />
						</xsl:call-template>
					</xsl:if>
					<xsl:if
						test="//sparql:result/sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;range'">
						<xsl:call-template name="sort-list">
							<xsl:with-param name="title"
								select="$property-range.title" />
							<xsl:with-param name="list"
								select="//sparql:result[sparql:binding[@name='predicate']/sparql:uri/text() = '&rdfs;range']/sparql:binding[@name='object']" />
						</xsl:call-template>
					</xsl:if>
				</td>
			</tr>
		</table>
		<xsl:if
			test="sparql:head/sparql:variable/@name != 'error-message' and sparql:results">
			<table class="data">
				<xsl:apply-templates select="*" />
			</table>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
