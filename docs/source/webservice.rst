.. _webservice:

Using web services
==================

Kiln can interact with external web services that return XML by making
HTTP requests with POSTed data. This is done using Cocoon's `CInclude
Transformer`_. There are three parts to the process, as follows:

1. Create a base query file (in ``assets/queries``) that contains all
   of the static data for the request, and placeholders for dynamic
   data. For example:

.. code-block:: xml

   <?xml version="1.0"?>
   <data xmlns:cinclude="http://apache.org/cocoon/include/1.0"
         xmlns:xi="http://www.w3.org/2001/XInclude">
     <!-- POST a request to a GATE Named Entity Recognition service,
          supplying the contents of a TEI file to be annotated. -->
     <cinclude:includexml ignoreErrors="true">
       <cinclude:src>http://www.example.org/gate/ner-service/</cinclude:src>
       <cinclude:configuration>
         <cinclude:parameter>
           <cinclude:name>method</cinclude:name>
           <cinclude:value>POST</cinclude:value>
         </cinclude:parameter>
       </cinclude:configuration>
       <cinclude:parameters>
         <cinclude:parameter>
           <cinclude:name>source</cinclude:name>
           <!-- Create a placeholder XInclude where the TEI XML is
                wanted. -->
           <cinclude:value><xi:include href="source-placeholder" /></cinclude:value>
         </cinclude:parameter>
       </cinclude:parameters>
     </cinclude:includexml>
   </data>

2. Write an XSLT to provide any dynamic data to the query. For
   example:

.. code-block:: xml

   <?xml version="1.0"?>
   <xsl:stylesheet version="2.0"
                   xmlns:cinclude="http://apache.org/cocoon/include/1.0"
                   xmlns:xi="http://www.w3.org/2001/XInclude"
                   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

     <xsl:param name="tei-filename" />

     <!-- Replace the XInclude's placeholder href attribute with the
          path to the supplied TEI file. -->
     <xsl:template match="xi:include[@href='source-placeholder']">
       <xsl:copy>
         <xsl:attribute name="href">
           <xsl:text>path/to/tei/directory/</xsl:text>
           <xsl:value-of select="$tei-filename" />
         </xsl:attribute>
       </xsl:copy>
     </xsl:template>

     <xsl:template match="@*|node()">
       <xsl:copy>
         <xsl:apply-templates select="@*|node()" />
       </xsl:copy>
     </xsl:template>

   </xsl:stylesheet>

3. Create a pipeline for making the request and display the
   result. For example:

.. code-block:: xml

   <map:match pattern="gate-ner/**.xml">
     <map:generate src="../assets/queries/gate/ner.xml" />
     <!-- Add an XInclude of the TEI file. -->
     <map:transform src="../stylesheets/gate/ner.xsl">
       <map:parameter name="tei-filename" value="{1}.xml" />
     </map:transform>
     <!-- Perform the XInclude of the TEI file. -->
     <map:transform type="xinclude" />
     <!-- Make the request. -->
     <map:transform type="cinclude" />
     <map:serialize type="xml" />
   </map:match>

.. _CInclude Transformer: http://cocoon.apache.org/2.1/userdocs/cinclude-transformer.html
