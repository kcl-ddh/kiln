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

<!-- CVS $Id: linkstatus2html.xslt 433543 2006-08-22 06:22:54Z crossley $ -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:linkstatus="http://apache.org/cocoon/linkstatus/2.0">

  <xsl:template match="linkstatus:linkstatus">
    <html>
      <body>
        <table border="1">
          <tr><th>URL</th><th>referrer</th><th>content-type</th><th>status</th><th>message</th></tr>
          <xsl:apply-templates/>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="linkstatus:link">
    <tr>
      <xsl:attribute name = "bgcolor">
        <xsl:choose>
          <xsl:when test="normalize-space(@status)='200'">#00ff00</xsl:when>
          <xsl:when test="normalize-space(@status)='404'">#ffff00</xsl:when>     	
          <xsl:otherwise>#ff0000</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <td><a href="{@href}"><xsl:value-of select="@href"/></a></td>
      <td><a href="{@referrer}">referrer</a></td>
      <td><xsl:value-of select="@content"/></td> 
      <td><xsl:value-of select="@status"/></td> 
      <td><xsl:value-of select="@message"/></td>
    </tr>
  </xsl:template>

</xsl:stylesheet>
