<?xml version="1.0" encoding="utf-8"?>
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
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:status="http://apache.org/cocoon/status/2.0"
                xmlns:xalan="http://xml.apache.org/xalan"
                exclude-result-prefixes="xalan">

  <!-- Converts output of the StatusGenerator into HTML.

       Adapted from Cocoon's status2html.xslt. -->

  <xsl:template match="status:statusinfo">
    <h2>
      <xsl:value-of select="@status:host" />
      <xsl:text> - </xsl:text>
      <xsl:value-of select="@status:date" />
    </h2>
    <h3>Apache Cocoon <xsl:value-of select="@status:cocoon-version"/></h3>

    <div class="section-container vertical-tabs"
         data-section="vertical-tabs">
      <xsl:apply-templates />
      <xsl:call-template name="xslt-processor" />
    </div>
  </xsl:template>

  <xsl:template match="status:group">
    <section>
      <p class="title system-status-title" data-section-title="">
        <a href="#">
          <xsl:choose>
            <xsl:when test="starts-with(@status:name,
                            'org.apache.cocoon.components.store.impl.')">
              <xsl:value-of select="substring-after(@status:name,
                                    'org.apache.cocoon.components.store.impl.')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@status:name" />
            </xsl:otherwise>
          </xsl:choose>
        </a>
      </p>
      <div class="content" data-section-content="">
        <xsl:if test="status:value">
          <ul class="no-bullet">
            <xsl:apply-templates select="status:value" />
          </ul>
        </xsl:if>
        <xsl:if test="status:group">
          <xsl:choose>
            <xsl:when test="parent::status:group">
              <div class="section-container accordion"
                   data-section="accordion">
                <xsl:apply-templates select="status:group" />
              </div>
            </xsl:when>
            <xsl:otherwise>
              <div class="section-container vertical-tabs"
                   data-section="vertical-tabs">
                <xsl:apply-templates select="status:group" />
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </div>
    </section>
  </xsl:template>

  <xsl:template match="status:value">
    <li>
      <span class="system-status-name">
        <xsl:value-of select="@status:name" />
        <xsl:text>:</xsl:text>
      </span>
      <xsl:text> </xsl:text>
      <xsl:choose>
        <xsl:when test="contains(@status:name,'free') or contains(@status:name,'used') or contains(@status:name,'total')">
          <xsl:call-template name="suffix">
            <xsl:with-param name="bytes" select="number(.)" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="count(status:line) &lt;= 1">
          <xsl:value-of select="status:line" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="id" select="generate-id(.)" />
          <span class="switch" id="{$id}-switch"
                onclick="toggle('{$id}', '[show]', '[hide]')">[show]</span>
          <ul id="{$id}" style="display: none">
            <xsl:apply-templates />
          </ul>
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>

  <xsl:template match="status:line">
    <li><xsl:value-of select="." /></li>
  </xsl:template>

  <xsl:template name="suffix">
    <xsl:param name="bytes" />
    <xsl:choose>
      <!-- More than 4 MB (=4194304) -->
      <xsl:when test="$bytes &gt;= 4194304">
        <xsl:value-of select="round($bytes div 10485.76) div 100" />
        <xsl:text> MB</xsl:text>
      </xsl:when>
      <!-- More than 4 KB (=4096) -->
      <xsl:when test="$bytes &gt; 4096">
        <xsl:value-of select="round($bytes div 10.24) div 100" />
        <xsl:text> KB</xsl:text>
      </xsl:when>
      <!-- Less -->
      <xsl:otherwise>
        <xsl:value-of select="$bytes" />
        <xsl:text> B</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Process Xalan extension output -->
  <xsl:template match="checkEnvironmentExtension">
    <h3>Xerces, Xalan</h3>
    <ul>
      <xsl:apply-templates select="EnvironmentCheck/environment/item[starts-with(@key, 'version.')]" />
    </ul>
  </xsl:template>

  <xsl:template match="item">
    <li>
      <span class="system-status-name">
        <xsl:value-of select="@key" />
        <xsl:text>:</xsl:text>
      </span>
      <xsl:text> </xsl:text>
      <xsl:value-of select="." />
    </li>
  </xsl:template>

  <xsl:template name="xslt-processor">
    <section>
      <p class="title system-status-title" data-section-title="">
        <a href="#">XSLT Processor</a>
      </p>
      <div class="content" data-section-content="">
        <ul class="no-bullet">
          <li>
            <span class="system-status-name">XSLT Version:</span>
            <xsl:text> </xsl:text>
            <xsl:value-of select="system-property('xsl:version')"/>
          </li>
          <li>
            <span class="system-status-name">Vendor:</span>
            <xsl:text> </xsl:text>
            <xsl:value-of select="system-property('xsl:vendor')"/>
          </li>
          <li>
            <span class="system-status-name">Vendor URL:</span>
            <xsl:text> </xsl:text>
            <xsl:value-of select="system-property('xsl:vendor-url')"/>
          </li>
          <!--Add Xalan / Xerces information using custom Xalan
               extension (if it's present). -->
          <xsl:if test="function-available('xalan:checkEnvironment')">
            <li><xsl:apply-templates select="xalan:checkEnvironment()"/></li>
          </xsl:if>
        </ul>
      </div>
    </section>
  </xsl:template>

</xsl:stylesheet>
