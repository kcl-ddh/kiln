<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:ex="http://apache.org/cocoon/exception/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Transform a Cocoon exception to plain HTML.

       Based on Cocoon's error2html.xslt, but modified to work on the
       XML provided by the ExceptionGenerator and to include all
       CSS/JS inline. -->

  <xsl:param name="debug" select="1" />

  <xsl:template match="ex:exception-report">
    <html>
      <head>
        <title>
          <xsl:text>Error: </xsl:text>
          <xsl:value-of select="ex:message" />
        </title>
        <style>
          body { padding: 1em 4em 0 2em; }
          h1 { color: #336699; border-bottom: 1px solid #336699; }
          .message { padding: 1em;
                     font-weight: bold;
                     font-size: 1.5em;
                     border: 1px dashed #336699; }
          .topped { padding-top: 1em; border-top: 1px solid #336699; }
          table { border: 1px solid #336699;
                  border-collapse: collapse; }
          th, td { padding: 0.5em; }
          .even { background-color: #F9F9F9; }
        </style>
        <script>
function toggle(id, showText, hideText) {
    var element = document.getElementById(id);
    with (element.style) {
        if ( display == "none" ){
            display = ""
        } else{
            display = "none"
        }
    }
    var text = document.getElementById(id + "-switch").firstChild;
    if (text.nodeValue == showText) {
        text.nodeValue = hideText;
    } else {
        text.nodeValue = showText;
    }
}
        </script>
      </head>
      <body>
        <h1>An error occurred</h1>

        <!-- Display full technical details only if debug is true. -->
        <xsl:choose>
          <xsl:when test="number($debug)">
            <xsl:apply-templates />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="ex:message" />
          </xsl:otherwise>
        </xsl:choose>

        <p class="topped">If you need help and this information is not
        enough, you are invited to read the <a
        href="http://cocoon.apache.org/2.1/faq/">Cocoon FAQ</a>.<br/>
        If you still don't find the answers you need, can send a mail
        to the <a
        href="http://cocoon.apache.org/community/mail-lists.html">Cocoon
        mailing lists</a>, remembering to:</p>

        <ul>
          <li>specify the version of Cocoon you're using, or we'll
          assume that you are talking about the latest released
          version;</li>
          <li>specify the platform-operating system-version-servlet
          container version;</li>
          <li>send any pertinent error message;</li>
          <li>send pertinent log snippets;</li>
          <li>send pertinent sitemap snippets;</li>
          <li>send pertinent parts of the page that give you
          problems.</li>
        </ul>

        <p>For more detailed technical information, take a look at the
        log files in the log directory of Cocoon, which is placed by
        default in the <code>WEB-INF/logs/</code> folder of your
        cocoon webapp context.<br/> If the logs don't give you enough
        information, you might want to increase the log level by
        changing the Logging configuration which is by default the
        <code>WEB-INF/logkit.xconf</code> file.</p>

        <p>If you think you found a bug, please report it to <a
        href="http://issues.apache.org/jira/browse/COCOON">Apache
        Cocoon issue tracker</a>; a message will automatically be sent
        to the developer mailing list and you'll be kept in contact
        automatically with the further progress on that bug.</p>

        <p>Thanks, and sorry for the trouble if this is our fault.</p>

        <p class="topped">The <a
        href="http://cocoon.apache.org/">Apache Cocoon</a> Project</p>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="ex:exception-report/@class">
    <p>
      <xsl:text>Exception class: </xsl:text>
      <xsl:value-of select="." />
    </p>
  </xsl:template>

  <xsl:template match="ex:exception-report/ex:location">
    <p>
      <xsl:text>On line </xsl:text>
      <xsl:value-of select="@line" />
      <xsl:text>, column </xsl:text>
      <xsl:value-of select="@column" />
      <xsl:text> of </xsl:text>
      <xsl:value-of select="@uri" />
      <xsl:text>: </xsl:text>
      <xsl:apply-templates />
    </p>
  </xsl:template>

  <xsl:template match="ex:exception-report/ex:message">
    <p class="message">
      <xsl:apply-templates />
    </p>
    <xsl:apply-templates select="../@class" />
  </xsl:template>

  <xsl:template match="ex:cocoon-stacktrace">
    <xsl:variable name="id" select="'cocoon-stacktrace'" />
    <p>Cocoon stacktrace: [<a class="switch" href="#" id="{$id}-switch"
    onclick="toggle('{$id}', 'show', 'hide'); return false;">show</a>]</p>

    <div id="{$id}" style="display: none;">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="ex:exception/ex:message">
    <p><xsl:apply-templates /></p>
  </xsl:template>

  <xsl:template match="ex:locations">
    <table>
      <thead>
        <tr class="even">
          <th scope="col">Line</th>
          <th scope="col">File</th>
          <th scope="col">Line #</th>
          <th scope="col">Column #</th>
        </tr>
      </thead>
      <tbody>
        <xsl:apply-templates />
      </tbody>
    </table>
  </xsl:template>

  <xsl:template match="ex:location">
    <tr>
      <xsl:if test="count(preceding-sibling::ex:location) mod 2 != 0">
        <xsl:attribute name="class">even</xsl:attribute>
      </xsl:if>
      <td><xsl:value-of select="." /></td>
      <td><xsl:apply-templates select="@uri" /></td>
      <td><xsl:value-of select="@line" /></td>
      <td><xsl:value-of select="@column" /></td>
    </tr>
  </xsl:template>

  <xsl:template match="ex:location/@uri">
    <span title="{.}">
      <xsl:value-of select="substring-after(., 'webapps/ROOT/')" />
    </span>
  </xsl:template>

  <xsl:template match="ex:stacktrace">
    <xsl:variable name="id" select="'stacktrace'" />
    <p>Stacktrace: [<a class="switch" href="#" id="{$id}-switch"
    onclick="toggle('{$id}', 'show', 'hide'); return false;">show</a>]</p>

    <pre id="{$id}" style="display: none;">
      <xsl:apply-templates />
    </pre>
  </xsl:template>

  <xsl:template match="ex:full-stacktrace">
    <xsl:variable name="id" select="'full-stacktrace'" />
    <p>Full stacktrace: [<a class="switch" href="#" id="{$id}-switch"
    onclick="toggle('{$id}', 'show', 'hide'); return false;">show</a>]</p>

    <pre id="{$id}" style="display: none;">
      <xsl:apply-templates />
    </pre>
  </xsl:template>


</xsl:stylesheet>
