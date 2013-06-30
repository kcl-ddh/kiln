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
            * images - Non-content images.
            * menu — Navigation menu.
            * schema
                * menu — Kiln schema, do not change.
                * tei — Schema for TEI files.
            * scripts — JavaScript files and libraries.
            * styles — CSS files and libraries.
            * templates — Templates for content display.
                * admin - Templates for the admin system.
        * content
            * images — Project/content images.
            * xml
                * tei — TEI content files.

        * kiln — Kiln core files, should not need to be modified.
        * mount-table.xml — Cocoon's sitemap mount table (do not modify).
        * not-found.xml — Default file to display when a resource is not found.
        * resources — Cocoon resources (do not modify).
        * sitemap.xmap — Cocoon default sitemap (do not modify).
        * sitemaps — Project's sitemaps.
            * admin.xmap — Project's admin (and editorial) pipelines.
            * config.xmap — Project's Cocoon configuration sitemap.
            * main.xmap — Project's Cocoon sitemap.
            * rdf.xmap - Project's RDF pipelines.
            * solr.xmap - Project's search pipelines.
        * stylesheets — Project's XSLT stylesheets.
            * defaults.xsl — Defaults stylesheet, defines default globals and
              reads parameters from the sitemaps.
            * admin — Stylesheets related to admin pipelines.
            * menu - Stylesheets related to menu handling.
            * metadata - Stylesheets related to metadata generation.
            * rdf - Stylesheets related to RDF harvesting and querying.
            * schematron — Stylesheets related to Schematron output.
            * solr — Stylesheets related to searching and indexing.
            * system — Cocoon stylesheets (do not modify).
            * tei — Stylesheets related to TEI display.
        * WEB—INF — Webapp configuration.
    * openrdf-sesame and openrdf-workbench — RDF / Linked Open Data framework.
    * solr — Searching framework.
        * conf
            * schema.xml - Definition of fields etc.
