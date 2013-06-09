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

<!-- CVS $Id: calendar2html.xslt 433543 2006-08-22 06:22:54Z crossley $ -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:calendar="http://apache.org/cocoon/calendar/1.0">
        
  <xsl:template match="/">
    <html>
      <head>
        <title>
          Calendar for <xsl:value-of select="calendar:calendar/@month"/>
          <xsl:text> </xsl:text><xsl:value-of select="calendar:calendar/@year"/>
        </title>
        <style>
          <xsl:comment>
.calendar {
  font-family: Georgia, "Book Antiqua", Palatino, "Times New Roman", serif;
  margin-top: 20px;
  padding-bottom: 1em;
  background-color: white;
  color: #333;
}

.calendar table {
  background-color: #888;
}

.calendar table caption {
  font-size: x-large;
  font-weight: bold;
  font-variant: small-caps;
  padding-top: 0.2em;
  padding-bottom: 0.3em;
  background: #fff;
  color: #333;
}

.calendar table th {
  font-size: small;
  font-variant: small-caps;
  background: #fff;
  color: #333;
  padding-bottom: 2px;
}

.calendar .weekend {
  background-color: #c0c0c0;
}

.calendar .daytitle {
  position: relative;
  left: 0;
  top: 0;
  width: 25%;
  padding: 3px 0;
  color: #000;
  border-right: 1px solid #888;
  border-bottom: 1px solid #888;
  font-size: small;
  text-align: center;
}

td {
  vertical-align: top;
  margin: 0;
  padding: 0 5px 5px 0;
  height: 7em;
  width: 12%;
  background: #fff;
  color: #333;
}

.calendar p {
  text-align: center;
  font-size: small;
}
          </xsl:comment>
        </style>
      </head>
      <body>
        <p>
        This sample shows a calendar that can be filled with events. The calendar is localized, try one of the
        following examples:
        </p>
        <p>
        <a href="cal?lang=en&amp;country=US">US English</a><br/>
        <a href="cal?lang=en&amp;country=GB">UK English</a><br/>
        <a href="cal?lang=nl">Dutch</a><br/>
        <a href="cal?lang=fr">French</a><br/>
        </p>
        <p>Note: the column headers are not localized, you can do that by simply inserting the appropriate
          i18n tags and transformer. Check the sample sources (sitemap and XSLT style sheet) and uncomment
          the lines.
        </p>
        <hr/>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="calendar:calendar">
    <div class="calendar">
      <table cellpadding="0" cellspacing="1" summary="Monthly calendar">
        <caption><xsl:value-of select="@month"/>
          <xsl:text> </xsl:text><xsl:value-of select="@year"/>
        </caption>
        <thead>
          <tr>
            <xsl:for-each select="calendar:week[2]/calendar:day">
              <th>
                <xsl:if test="@weekday = 'SATURDAY' or @weekday='SUNDAY'">
                    <xsl:attribute name="class">weekend</xsl:attribute>
                </xsl:if>
                <!-- The lines below provide i18n localization for headers -->
                <!-- Note that you also need to provide the appropriate message files -->
                <i18n:text><xsl:value-of select="@weekday"/></i18n:text>
              </th>
            </xsl:for-each>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="calendar:week"/>
        </tbody>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="calendar:week">
    <tr>
      <xsl:if test="position() = 1">
        <xsl:choose>
          <xsl:when test="count(calendar:day) = 1">
            <td/><td/><td/><td/><td/><td/>
          </xsl:when>
          <xsl:when test="count(calendar:day) = 2">
            <td/><td/><td/><td/><td/>
          </xsl:when>
          <xsl:when test="count(calendar:day) = 3">
            <td/><td/><td/><td/>
          </xsl:when>
          <xsl:when test="count(calendar:day) = 4">
            <td/><td/><td/>
          </xsl:when>
          <xsl:when test="count(calendar:day) = 5">
            <td/><td/>
          </xsl:when>
          <xsl:when test="count(calendar:day) = 6">
            <td/>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
      <xsl:for-each select="calendar:day">
        <td>
          <xsl:if test="@weekday = 'SATURDAY' or @weekday = 'SUNDAY'">
            <xsl:attribute name="class">weekend</xsl:attribute>
          </xsl:if>
          <div class="daytitle"><xsl:value-of select="@number"/></div>
          <p><xsl:value-of select="@date"/></p>
        </td>
      </xsl:for-each>
      <xsl:if test="position() = last()">
        <xsl:choose>
          <xsl:when test="count(calendar:day) = 1">
            <td/><td/><td/><td/><td/><td/>
          </xsl:when>
          <xsl:when test="count(calendar:day) = 2">
            <td/><td/><td/><td/><td/>
          </xsl:when>
          <xsl:when test="count(calendar:day) = 3">
            <td/><td/><td/><td/>
          </xsl:when>
          <xsl:when test="count(calendar:day) = 4">
            <td/><td/><td/>
          </xsl:when>
          <xsl:when test="count(calendar:day) = 5">
            <td/><td/>
          </xsl:when>
          <xsl:when test="count(calendar:day) = 6">
            <td/>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </tr>
  </xsl:template>

</xsl:stylesheet>
