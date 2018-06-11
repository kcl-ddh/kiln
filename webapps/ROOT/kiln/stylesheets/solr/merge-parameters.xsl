<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:h="http://apache.org/cocoon/request/2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT adds the Solr query parameters passed in the
       query-string parameter to an XML query document (root element
       "query"). The document is only added to, with the new elements
       added after the existing ones.

       The query element may have a "q_fields" attribute that contains
       a whitespace delimited list of field names that are to be
       treated as values in the q field, of the form "<field
       name>:<field value>".

       The query element may have a "range_fields" attribute that
       contains a whitespace delimited list of field names that are to
       be treated as providing a range. These field names are not
       those of the actual query parameters; rather, the range start
       parameter is the field name followed by "_start", and the range
       end parameter is the field name followed by "_end".

       An element in the XML query document may have a "default"
       attribute with value "true" to indicate that it should be
       used if and only if there are no parameters with the same name,
       that are not empty, in the query-string.

       An element in the XML query document may have an "escape"
       attribute. If the value of this attribute is "false", the
       contents of that field will not be escaped. This is useful when
       Solr-significant characters should be passed through unchanged,
       for example with a fq field.

       A facet.field element may have a "join" attribute. If the value
       of this attribute is "or", then that facet's values will be
       ORed together (ie, applying one value does not alter the counts
       of the other values). The default value is "and", in which each
       facet value applies restricts the results to those which have
       that facet value.

  -->

  <xsl:import href="../query-string-handler.xsl" />

  <xsl:template match="/aggregation">
    <xsl:apply-templates select="query" />
  </xsl:template>

  <xsl:template match="query">
    <xsl:variable name="default_fields" select="*[@default='true']/local-name()"
                  as="xs:string*" />
    <xsl:variable name="and_facet_fields" select="facet.field[not(@join='or')]"
                  as="xs:string*" />
    <xsl:variable name="or_facet_fields" select="facet.field[@join='or']"
                  as="xs:string*" />
    <xsl:variable name="q_fields" select="tokenize(@q_fields, '\s+')" />
    <xsl:variable name="range_fields" select="tokenize(@range_fields, '\s+')" />
    <xsl:variable name="range_start_fields" as="xs:string*">
      <xsl:for-each select="$range_fields">
        <xsl:sequence select="concat(., '_start')" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="range_end_fields" as="xs:string*">
      <xsl:for-each select="$range_fields">
        <xsl:sequence select="concat(., '_end')" />
      </xsl:for-each>
    </xsl:variable>
    <!-- user_fields is a sequence of query string parameter names
         that will be merged into the query document. -->
    <xsl:variable name="user_fields" select="distinct-values(($default_fields, $and_facet_fields, $or_facet_fields, $q_fields, $range_start_fields, $range_end_fields))" as="xs:string*">
    </xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:variable name="processed-query-string">
        <xsl:apply-templates select="/aggregation/h:request/h:requestParameters/h:parameter">
          <xsl:with-param name="and_facet_fields" select="$and_facet_fields" />
          <xsl:with-param name="or_facet_fields" select="$or_facet_fields" />
          <xsl:with-param name="q_fields" select="$q_fields" />
          <xsl:with-param name="range_start_fields"
                          select="$range_start_fields" />
          <xsl:with-param name="range_end_fields"
                          select="$range_end_fields" />
          <xsl:with-param name="user_fields" select="$user_fields" />
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:apply-templates select="*">
        <xsl:with-param name="query-string" select="$processed-query-string" />
        <xsl:with-param name="q_fields" select="$q_fields" />
      </xsl:apply-templates>
      <xsl:copy-of select="$processed-query-string" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="query/*">
    <xsl:param name="query-string" />
    <xsl:param name="q_fields" />
    <xsl:variable name="field_name" select="local-name()" />
    <xsl:choose>
      <xsl:when test="not(normalize-space())" />
      <!-- If this is a default value, then do not include it if there
           is a query-string parameter with the same name, provided
           that query-string parameter has content. -->
      <xsl:when test="@default='true' and $query-string/*[local-name()=$field_name][normalize-space()]" />
      <xsl:when test="$field_name = $q_fields">
        <q>
          <xsl:value-of select="$field_name" />
          <xsl:text>:</xsl:text>
          <xsl:apply-templates select="text()">
            <xsl:with-param name="escape" select="@escape" />
          </xsl:apply-templates>
        </q>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:apply-templates select="@*|text()">
            <xsl:with-param name="escape" select="@escape" />
          </xsl:apply-templates>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="query/@escape" />

  <xsl:template match="query/@q_fields" />

  <xsl:template match="query/@range_fields" />

  <xsl:template match="@default" />

  <xsl:template match="text()">
    <xsl:param name="escape" select="'true'" />
    <xsl:choose>
      <xsl:when test="$escape = 'false'">
        <xsl:value-of select="." />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="kiln:escape-for-query-string(.)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="h:parameter">
    <xsl:param name="and_facet_fields" />
    <xsl:param name="or_facet_fields" />
    <xsl:param name="q_fields" />
    <xsl:param name="range_start_fields" />
    <xsl:param name="range_end_fields" />
    <xsl:param name="user_fields" />
    <xsl:variable name="name" select="@name" />
    <!-- Only pass along parameters whose name is defined in the query
         as being usable, and which have a value. -->
    <xsl:if test="$name = $user_fields and normalize-space()">
      <xsl:choose>
        <xsl:when test="$name = $and_facet_fields">
          <xsl:apply-templates mode="facet">
            <xsl:with-param name="join" select="'and'" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$name = $or_facet_fields">
          <xsl:apply-templates mode="facet">
            <xsl:with-param name="join" select="'or'" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$name = $q_fields">
          <xsl:apply-templates mode="q_field" />
        </xsl:when>
        <xsl:when test="$name = $range_start_fields">
          <xsl:apply-templates mode="range">
            <xsl:with-param name="suffix" select="'start'" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$name = $range_end_fields">
          <xsl:apply-templates mode="range">
            <xsl:with-param name="suffix" select="'end'" />
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="plain" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="h:value" mode="facet">
    <xsl:param name="join" />
    <xsl:element name="{../@name}">
      <xsl:attribute name="join" select="$join" />
      <xsl:value-of select="kiln:escape-for-query-string(.)" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="h:value" mode="plain">
    <xsl:element name="{../@name}">
      <xsl:value-of select="kiln:escape-for-query-string(.)" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="h:value" mode="q_field">
    <xsl:element name="q">
      <xsl:value-of select="../@name" />
      <xsl:text>:</xsl:text>
      <xsl:value-of select="kiln:escape-for-query-string(.)" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="h:value" mode="range">
    <xsl:param name="suffix" />
    <xsl:element name="{replace(../@name, concat('_', $suffix, '$'), '')}">
      <xsl:attribute name="type" select="concat('range_', $suffix)" />
      <xsl:value-of select="." />
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*|*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
