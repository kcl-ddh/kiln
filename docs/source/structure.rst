.. _structure:

Kiln structure and file layout
==============================

Kiln uses a very specific file structure, as outlined below. It creates a
degree of separation between the Kiln files, that should not be modified, and
the project-specific files, keeping each in their own directories.

* build.bat — Ant startup script for Windows.
* build.sh — Ant startup script for Mac OS X/Linux.
* buildfiles — Ant core build files. This should not need to be modified.
* local.build.properties — Local Ant properties file.
* local.build.xml — Local Ant build file to override core
  functionality.
* example - Example webapps.
* sw — Software used in building and running Kiln.
* webapps
    * ROOT — Project webapp.
        * assets
            * foundation - Foundation CSS/JS framework
            * images - Non-content images.
            * menu — Navigation menu.
            * queries - XML containing base queries
                * solr - Solr query fragments
            * schema
                * menu — Kiln schema, do not change.
                * tei — Schema for TEI files.
            * scripts — JavaScript files and libraries.
            * styles — CSS files and libraries.
            * templates — Templates for content display.
                * admin - Templates for the admin system.
            * translations - Catalogue files containing translations of site content.
        * content
            * images — Project/content images.
            * xml
                * authority - Authority files.
                * indices - Content index files.
                * tei — TEI content files.
                * epidoc - EpiDoc content files.
        * kiln — Kiln core files, should not need to be modified.
        * mount-table.xml — Cocoon's sitemap mount table (do not modify).
        * not-found.xml — Default file to display when a resource is not found.
        * resources — Cocoon resources (do not modify).
        * sitemap.xmap — Cocoon default sitemap (do not modify).
        * sitemaps — Project's sitemaps.
            * admin.xmap — Admin and editorial pipelines.
            * config.xmap — Configuration (global variables, etc).
            * internal.xmap - Internal (not exposed by URL) pipelines.
            * main.xmap — Main pipelines.
            * rdf.xmap - RDF pipelines.
            * solr.xmap - Search pipelines.
        * stylesheets — Project's XSLT stylesheets.
            * defaults.xsl — Defines default globals and
              reads parameters from the sitemaps.
            * escape-xml.xsl - Formats XML for literal display within
              HTML.
            * admin - Admin and editorial transformations.
            * epidoc - EpiDoc display.
            * error - Error handling.
            * introspection - Introspection of sitemaps and XSLT.
            * menu - Menu manipulation.
            * metadata - Extraction of metadata from files.
            * rdf - RDF harvesting and querying.
            * schematron — Schematron output.
            * solr — Searching and indexing.
            * system — Cocoon stylesheets (do not modify).
            * tei — TEI display.
        * WEB—INF — Webapp configuration.
    * openrdf-sesame and openrdf-workbench — RDF / Linked Open Data framework.
    * solr — Searching framework.
        * conf
            * schema.xml - Definition of fields etc.
