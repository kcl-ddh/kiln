.. _multilingual:

Multilingual sites
==================

Kiln supports sites in which some or all of the content is available in
more than one language. It does this by allowing for a language code
as the first element in a URL, with the actual content URL hierarchy
repeated for each language after it.

For example, if the site consisted of resources at /index.html,
/about/index.html, and /about/process.html, and these resources were
available in both English and Telugu, the URLs for these resources
would be:

* /en/index.html
* /en/about/index.html
* /en/about/process.html
* /te/index.html
* /te/about/index.html
* /te/about/process.html

Kiln treats the language code prefix similarly to the mount point of
the webapp, so creating links between pages in the same language is no
different from how it is in a monolingual site. Linking between
languages is also simple.

Implementation
--------------

``sitemaps/main.xmap`` provides an example match incorporating a
language code prefix that is used in the various transformations. The
language code is passed as a parameter to XSLT that include
``stylesheets/defaults.xsl``, which incorporates that code into the
``xmg:context-path`` variable (as well as being available separately
as ``xmg:language``. This variable is used in XSLT when creating links
to textual content within Kiln.

What further use is made of this parameter/variable is site-dependent.

HTTP content negotiation
------------------------

Kiln does not include any code for handling automatic content
negotiation based on the HTTP Accept-Language header.
