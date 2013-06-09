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

<!-- CVS $Id: exception2html.xslt 433543 2006-08-22 06:22:54Z crossley $ -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ex="http://apache.org/cocoon/exception/1.0">

  <xsl:param name="contextPath"/>
  <xsl:param name="realPath"/>

  <!-- let sitemap override default page title -->
  <xsl:param name="pageTitle">An error has occured</xsl:param>

  <xsl:template match="ex:exception-report">
    <html>
      <head>
        <title>
          <xsl:value-of select="$pageTitle"/>
        </title>
        <link href="{$contextPath}/styles/main.css" type="text/css" rel="stylesheet"/>
        <style>
          h1 { font-size: 200%; color: #336699; text-align: left; margin: 0px 0px 30px 0px; padding: 0px; border-width: 0px 0px 1px 0px; border-style: solid; border-color: #336699;}
          p.message { padding: 10px 30px 10px 30px; font-weight: bold; font-size: 110%; border-width: 1px; border-style: dashed; border-color: #336699; }
          p.description { padding: 10px 30px 20px 30px; border-width: 0px 0px 1px 0px; border-style: solid; border-color: #336699;}
          p.topped { padding-top: 10px; border-width: 1px 0px 0px 0px; border-style: solid; border-color: #336699; }
          pre { font-size: 120%; }
          .row-1 { background-color: #F0F0F0;}
          table { border-collapse: collapse; margin-top: 0.3em; }
          td { padding: 0.1em; }
        </style>
        <script src="{$contextPath}/scripts/main.js" type="text/javascript">&#160;</script>
      </head>
      <body>
        <xsl:attribute name="onload">
          <xsl:if test="ex:stacktrace">toggle('stacktrace');</xsl:if>
          <xsl:if test="ex:full-stacktrace">toggle('full-stacktrace');</xsl:if>
        </xsl:attribute>

        <h1><xsl:value-of select="$pageTitle"/></h1>
        <p class="message">
          <xsl:value-of select="@class"/>:
          <xsl:apply-templates select="ex:message" mode="breakLines"/>
          <xsl:if test="ex:location">
             <br/><span style="font-weight: normal"><xsl:apply-templates select="ex:location"/></span>
          </xsl:if>
        </p>

        <p><span class="description">Cocoon stacktrace</span>
           <span class="switch" id="locations-switch" onclick="toggle('locations')">[hide]</span>
        </p>
        <div id="locations">
          <xsl:for-each select="ex:cocoon-stacktrace/ex:exception">
            <xsl:sort select="position()" order="descending"/>
            <strong>
               <xsl:apply-templates select="ex:message" mode="breakLines"/>
            </strong>
            <table>
               <xsl:for-each select="ex:locations/*[string(.) != '[cause location]']">
                 <!-- [cause location] indicates location of a cause, which 
                      the exception generator outputs separately -->
                <tr class="row-{position() mod 2}">
                   <td><xsl:call-template name="print-location"/></td>
                   <td><em><xsl:value-of select="."/></em></td>
                </tr>
                <!--xsl:apply-templates select="."/><br/-->
              </xsl:for-each>
            </table>
            <br/>
           </xsl:for-each>
        </div>

        <xsl:apply-templates select="ex:stacktrace"/>
        <xsl:apply-templates select="ex:full-stacktrace"/>

<!-- Do we really need all that stuff?
     Application developers know this, and application users get really confused by this information.

        <p class="topped">
          If you need help and this information is not enough, you
          are invited to read the
          <a href="http://cocoon.apache.org/2.1/faq/">Cocoon FAQ</a>.<br/>
          If you still don't find the answers you need,
          can send a mail to the
          <a href="http://cocoon.apache.org/community/mail-lists.html">
          Cocoon mailing lists</a>,
          remembering to:
        </p>

        <ul>
          <li>specify the version of Cocoon you're using, or we'll assume that you
              are talking about the latest released version;</li>
          <li>specify the platform-operating system-version-servlet container version;</li>
          <li>send any pertinent error message;</li>
          <li>send pertinent log snippets;</li>
          <li>send pertinent sitemap snippets;</li>
          <li>send pertinent parts of the page that give you problems.</li>
        </ul>

        <p>
          For more detailed technical information, take a look at the log
          files in the log directory of Cocoon, which is placed by default in
          the <code>WEB-INF/logs/</code> folder of your cocoon webapp context.<br/>
          If the logs don't give you enough information, you might want to increase the
          log level by changing the Logging configuration which is by default the
          <code>WEB-INF/logkit.xconf</code> file.
        </p>

        <p>
          If you think you found a bug, please report it to the 
          <a href="http://issues.apache.org/jira/browse/COCOON">Apache Cocoon issue tracker</a>;
          a message will automatically be sent to the developer mailing list and you'll
          be kept in contact automatically with the further progress on that bug.
        </p>

        <p>
          Thanks, and sorry for the trouble if this is our fault.
        </p>
-->
        <p class="topped">
          The <a href="http://cocoon.apache.org/">Apache Cocoon</a> Project
        </p>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="ex:stacktrace|ex:full-stacktrace">
      <p class="stacktrace">
       <span class="description">Java <xsl:value-of select="translate(local-name(), '-', ' ')"/></span>
       <span class="switch" id="{local-name()}-switch" onclick="toggle('{local-name()}')">[hide]</span>
       <pre id="{local-name()}">
         <xsl:value-of select="translate(.,'&#13;','')"/>
       </pre>
      </p>
  </xsl:template>
  
  <xsl:template match="ex:location">
   <xsl:if test="string-length(.) > 0">
     <em><xsl:value-of select="."/></em>
     <xsl:text> - </xsl:text>
   </xsl:if>
   <xsl:call-template name="print-location"/>
  </xsl:template>
  
  <xsl:template name="print-location">
     <xsl:choose>
       <xsl:when test="contains(@uri, $realPath)">
         <xsl:text>context:/</xsl:text>
         <xsl:value-of select="substring-after(@uri, $realPath)"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="@uri"/>
       </xsl:otherwise>
      </xsl:choose>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="@line"/>:<xsl:value-of select="@column"/>
  </xsl:template>
  
  <!-- output a text by splitting it with <br>s on newlines
       can be uses either by an explicit call or with <apply-templates mode="breakLines"/> -->
  <xsl:template match="node()"  mode="breakLines" name="breakLines">
     <xsl:param name="text" select="string(.)"/>
     <xsl:choose>
        <xsl:when test="contains($text, '&#10;')">
           <xsl:value-of select="substring-before($text, '&#10;')"/>
           <br/>
           <xsl:call-template name="breakLines">
              <xsl:with-param name="text" select="substring-after($text, '&#10;')"/>
           </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
           <xsl:value-of select="$text"/>
        </xsl:otherwise>
     </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
