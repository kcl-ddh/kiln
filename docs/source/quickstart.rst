.. _quickstart:

Quickstart
==========

To get started with Kiln, it first needs to be downloaded or cloned from
the `GitHub repository <http://github.com/kcl-ddh/kiln/>`_.

#. Open a Terminal window and go to the directory where Kiln is installed
   (hereafter KILN_HOME)
#. Run the command ``build.sh`` (Mac OS X/Linux) or ``build.bat`` (Windows),
   and leave the Terminal window open
#. Open a browser and got to http://localhost:9999/
    #. If all is well it should display a *Resource not found* error message!
#. Store project XML content (TEI) in the folder
   ``KILN_HOME/webapps/root/content/xml/tei``. By default Kiln needs a TEI
   index.xml file at that location
#. Reload the browser. It should now display the contents of the index file,
   together with some very basid navigation.
