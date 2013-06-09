<?xml version="1.0"?>
<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->

<!--+
    | Converts output of the StatusGenerator into HTML page
    | 
    | CVS $Id: status2html.xslt 433543 2006-08-22 06:22:54Z crossley $
    +-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:status="http://apache.org/cocoon/status/2.0"
                xmlns:xalan="http://xml.apache.org/xalan"
                exclude-result-prefixes="xalan">
 
  <xsl:param name="contextPath"/>

  <xsl:template match="status:statusinfo">
    <html>
      <head>
        <title>Cocoon Status [<xsl:value-of select="@status:host"/>]</title>
        <link href="{$contextPath}/styles/main.css" type="text/css" rel="stylesheet"/>
        <script src="{$contextPath}/scripts/main.js" type="text/javascript"/>
      </head>

      <body>
        <h1><xsl:value-of select="@status:host"/> - <xsl:value-of select="@status:date"/></h1>
        <h2>Apache Cocoon <xsl:value-of select="@status:cocoon-version"/></h2>
        <xsl:apply-templates/>

        <!--
          - Add XSLT processor information
          -->
        <h2>XSLT Processor</h2>
        <li>
          <span class="description">XSLT Version:</span>
          <xsl:text> </xsl:text>
          <xsl:value-of select="system-property('xsl:version')"/>
        </li>
        <li>
          <span class="description">Vendor:</span>
          <xsl:text> </xsl:text>
          <xsl:value-of select="system-property('xsl:vendor')"/>
        </li>
        <li>
          <span class="description">Vendor URL:</span>
          <xsl:text> </xsl:text>
          <xsl:value-of select="system-property('xsl:vendor-url')"/>
        </li>

        <!--
          - Add Xalan / Xerces information using custom Xalan extension
          - (if it's present)
          -->
        <xsl:if test="function-available('xalan:checkEnvironment')">
          <xsl:apply-templates select="xalan:checkEnvironment()"/>
        </xsl:if>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="status:group">
    <h2><xsl:value-of select="@status:name"/></h2>
    <ul><xsl:apply-templates select="status:value"/></ul>
    <xsl:apply-templates select="status:group"/>
  </xsl:template>

  <xsl:template match="status:value">
    <li>
      <span class="description"><xsl:value-of select="@status:name"/><xsl:text>: </xsl:text></span>
      <xsl:choose>
        <xsl:when test="contains(@status:name,'free') or contains(@status:name,'used') or contains(@status:name,'total')">
          <xsl:call-template name="suffix">
            <xsl:with-param name="bytes" select="number(.)"/>
          </xsl:call-template>
        </xsl:when>      
        <xsl:when test="count(status:line) &lt;= 1">
          <xsl:value-of select="status:line"/>
        </xsl:when>
        <xsl:otherwise>
          <span class="switch" id="{generate-id(.)}-switch" onclick="toggle('{generate-id(.)}')">[show]</span>
          <ul id="{generate-id(.)}" style="display: none">
             <xsl:apply-templates />
          </ul>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="status:line">
    <li><xsl:value-of select="."/></li>
  </xsl:template>

  <xsl:template name="suffix">
    <xsl:param name="bytes"/>
    <xsl:choose>
      <!-- More than 4 MB (=4194304) -->
      <xsl:when test="$bytes &gt;= 4194304">
        <xsl:value-of select="round($bytes div 10485.76) div 100"/> MB
      </xsl:when>
      <!-- More than 4 KB (=4096) -->
      <xsl:when test="$bytes &gt; 4096">
        <xsl:value-of select="round($bytes div 10.24) div 100"/> KB
      </xsl:when>
      <!-- Less -->
      <xsl:otherwise>
        <xsl:value-of select="$bytes"/> B
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
    - Process Xalan extension output
    -->
  <xsl:template match="checkEnvironmentExtension">
    <h2>Xerces, Xalan</h2>
    <ul><xsl:apply-templates select="EnvironmentCheck/environment/item[starts-with(@key, 'version.')]"/></ul>
  </xsl:template> 

  <xsl:template match="item">
    <li style="width: 40%">
      <span class="description"><xsl:value-of select="@key"/>:</span>
      <xsl:text> </xsl:text>
      <xsl:value-of select="."/>
    </li>
  </xsl:template> 
   
</xsl:stylesheet>
