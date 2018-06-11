.. _multilingual:

Multilingual sites
==================

Kiln supports sites in which some or all of the content is available
in more than one language. It does this by having a language code as
the first element in all public URLs (not internal, not admin).

For example, if the site consisted of resources at index.html,
about/index.html, and about/process.html, and these resources were
available in both English and Telugu, the URLs for these resources
would be:

* /en/index.html
* /en/about/index.html
* /en/about/process.html
* /te/index.html
* /te/about/index.html
* /te/about/process.html

Implementation
--------------

All of the matches in ``sitemaps/main.xmap`` incorporate a language
code prefix that is used in the various transformations. The language
code is passed as a parameter to XSLT that include
``stylesheets/defaults.xsl``. This value is used in XSLT when creating
links to textual content within Kiln.

A default language code must be set in ``sitemaps/config.xmap`` in the
global variable ``default-display-language``.

Kiln also follows the approach for internationalisation (i18n) as
documented in the `Cocoon documentation`_. A sample catalogue of
translations is available in ``assets/translations/messages_en.xml``;
translations into other languages should use the same filename
convention and content format. Note that of the provided templates and
menus, only ``assets/templates/home.xml`` and ``assets/menu/main.xml``
have even partial i18n markup; this must be added where appropriate to
templates and XSLT.

HTTP content negotiation
------------------------

Kiln does not include any code for handling automatic content
negotiation based on the HTTP Accept-Language header.

Nice URLs for monolingual sites
-------------------------------

Monolingual sites also use the same URL scheme with a language code
prefix, which may not be desired in production. This problem can be
solved by using, for example, ``mod_proxy`` and ``mod_proxy_html``
with Apache HTTPD to rewrite headers and links so that users see the
URLs without the language code prefix.


.. _Cocoon documentation: https://cocoon.apache.org/2.1/userdocs/i18nTransformer.html
