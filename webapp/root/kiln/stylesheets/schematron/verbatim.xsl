<?xml version="1.0" ?>
<!-- Report Generator for the Schematron XML Schema Language.
	http://www.ascc.net/xml/resource/schematron/schematron.html
   
 Copyright (c) 2000,2001 David Calisle, Oliver Becker,
	 Rick Jelliffe and Academia Sinica Computing Center, Taiwan

 This software is provided 'as-is', without any express or implied warranty. 
 In no event will the authors be held liable for any damages arising from 
 the use of this software.

 Permission is granted to anyone to use this software for any purpose, 
 including commercial applications, and to alter it and redistribute it freely,
 subject to the following restrictions:

 1. The origin of this software must not be misrepresented; you must not claim
 that you wrote the original software. If you use this software in a product, 
 an acknowledgment in the product documentation would be appreciated but is 
 not required.

 2. Altered source versions must be plainly marked as such, and must not be 
 misrepresented as being the original software.

 3. This notice may not be removed or altered from any source distribution.

    1999-10-25  Version for David Carlisle's schematron-report error browser
    1999-11-5   Beta for 1.2 DTD
    1999-12-26  Add code for namespace: thanks DC
    1999-12-28  Version fix: thanks Uche Ogbuji
    2000-03-27  Generate version: thanks Oliver Becker
    2000-10-20  Fix '/' in do-all-patterns: thanks Uche Ogbuji
    2001-02-15  Port to 1.5 code
    2001-03-15  Diagnose test thanks Eddie Robertsson
-->

<!-- updated November 2007 to support ISO schematron, by Conal Tuohy -->

<!-- Updated June 2010 to be based off the Saxon XSLT2 skeleton, by Jamie Norrish. -->

<!-- Schematron report -->

<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron">

  <xsl:import href="iso_schematron_skeleton_for_saxon.xsl"/>

  <xsl:param name="phase">
    <xsl:choose>
      <xsl:when test="//iso:schema/@defaultPhase">
	<xsl:value-of select="//iso:schema/@defaultPhase"/>
      </xsl:when>   
      <xsl:otherwise>#ALL</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:param name="diagnose">yes</xsl:param>

  <xsl:template name="process-prolog">
    <!-- we quote the entire document being checked for which we need
         the "verbatim" quoting stylesheet "verbid.xsl"
	 
	 instead of generating an xsl:import link to verbid.xsl, copy
	 it inline, so that we have only a single XSLT to run -->
		
    <xsl:variable name="verbatim-stylesheet" select="document('verbid.xsl')"/>
    <xsl:copy-of select="$verbatim-stylesheet/*/*[not(@match='/')]"/>
  </xsl:template>
	
  <xsl:template name="process-root">
    <xsl:param name="title" />
    <xsl:param name="icon" />
    <xsl:param name="contents" />
    <html>
      <head>
	<title>Schematron Report</title>
	<style type="text/css">
	  a:link    { color: black; }
	  a:visited { color: gray; }
	  a:active  { color: #FF0088; }
	  table { border-collapse: collapse; border: 2px solid grey; }
	  td, th { vertical-align: top; border: 1px solid grey; padding: 0.5em; }
	  th { color: #0C393F; background: #F0F0F0; }
	</style>
	<axsl:call-template name="verbid-style"/>
      </head>
      <body>
	<h1>
	  <xsl:text>Schematron Report: </xsl:text>
	  <xsl:value-of select="$phase"/>
	  <xsl:value-of select="$title"/>
	</h1>

	<div class="errors">
	  <xsl:copy-of select="$contents" />
	</div>
	
	<hr/>

	<div class="source">
	  <axsl:apply-templates select="/" mode="verb" />
	</div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="process-p">
    <xsl:param name="icon" />
    <p>
      <xsl:if test="$icon">
	<img src="{$icon}" />
	<xsl:text></xsl:text>
      </xsl:if>
      <xsl:apply-templates mode="text"/>
    </p>
  </xsl:template>

  <xsl:template name="process-pattern">
    <xsl:param name="icon" />
    <xsl:param name="name" />
    <xsl:param name="see" />
    <xsl:choose>
      <xsl:when test="$see">
	<a href="{$see}" target="SRDOCO" title="Link to User Documentation:">
	  <h2 class="linked">
	    <xsl:value-of select="$name" />
	  </h2>
	</a>
      </xsl:when>
      <xsl:otherwise>
	<h2>
	  <xsl:value-of select="$name" />
	</h2>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$icon">
      <img src="{$icon}" />
    </xsl:if>
  </xsl:template>

  <xsl:template name="process-assert">
    <xsl:param name="icon" />
    <xsl:param name="pattern" />
    <xsl:param name="role" />
    <xsl:param name="diagnostics" />

    <axsl:variable name="id">
      <axsl:choose>
	<axsl:when test="normalize-space(@id)">
	  <axsl:value-of select="@id" />
	</axsl:when>
	<axsl:otherwise>
	  <axsl:value-of select="generate-id(.)" />
	</axsl:otherwise>
      </axsl:choose>
    </axsl:variable>

    <li>
      <xsl:if test="$icon">
	<img src="{$icon}" />
      </xsl:if>
      <a href="#{{$id}}" title="Link to where this pattern was expected">
	<xsl:if test="$role">
	  <i>
	    <xsl:value-of select="$role"/>
	  </i>
	</xsl:if>
	<xsl:apply-templates mode="text"/>
	<xsl:if test="$diagnose = 'yes'">
	  <b>
	    <xsl:call-template name="diagnosticsSplit">
	      <xsl:with-param name="str" select="$diagnostics" />
	    </xsl:call-template>
	  </b>
	</xsl:if>
      </a>
    </li>
  </xsl:template>

  <xsl:template name="process-report">
    <xsl:param name="pattern" />
    <xsl:param name="icon" />
    <xsl:param name="role" />
    <xsl:param name="diagnostics" />

    <axsl:variable name="id">
      <axsl:choose>
	<axsl:when test="normalize-space(@id)">
	  <axsl:value-of select="@id" />
	</axsl:when>
	<axsl:otherwise>
	  <axsl:value-of select="generate-id(.)" />
	</axsl:otherwise>
      </axsl:choose>
    </axsl:variable>

    <li>
      <xsl:if test="$icon">
	<img src="{$icon}" />
      </xsl:if>
      <a href="#{{$id}}" title="Link to where this pattern was found">
	<xsl:if test="$role">
	  <i>
	    <xsl:value-of select="$role"/>
	  </i>
	</xsl:if>
	<xsl:apply-templates mode="text"/>
	<b>
	  <xsl:call-template name="diagnosticsSplit">
	    <xsl:with-param name="str" select="$diagnostics" />
	  </xsl:call-template>
	</b>
      </a>
    </li>
  </xsl:template>

</xsl:stylesheet>
