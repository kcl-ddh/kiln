.. _navigation:

Navigation
==========

Navigation structures (menu hierarchies and breadcrumbs) are defined
in XML files that accord to the Kiln menu schema (see
``webapps/ROOT/assets/schema/menu/menu.rng``). These specify a
hierarchy of labels and their associated URLs (which may be external
to the Kiln site).

By default Kiln's navigation is configured in the file
``KILN_HOME/webapps/ROOT/assets/menu/main.xml``. It is possible to
have multiple menu files used in a single site, and even within a
single ``map:match``.

The structure of a menu is that of a list of items, with each item
being able to hold another list of items. However, it makes a
distinction between a ``kiln:menu`` and a ``kiln:item``. The former
may or may not reference a resource, while the latter must. A
``kiln:menu`` may have children, while a ``kiln:item`` may not.

It is important to understand that there is no necessary connection
between the position of a ``kiln:menu`` or ``kiln:item`` in the
hierarchy, and the URL it references. Specifically, the ``@href`` of
an element, if it is not an absolute or root relative URL, is appended
to the 'path' of ``@root`` values from its ancestors.

For example, given the following menu::

    <root xmlns="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0">
      <menu href="text/" label="Texts">
        <item href="intro.html" label="Introduction" />
        <menu label="Reports" root="text/reports">
          <item href="1.html" label="Report #1" />
        </menu>
      </menu>
    </root>

The "Texts" item links to ``text/``, "Introduction" links to
``intro.html`` (*not* ``text/intro.html``), and "Report #1" links to
``text/reports/1.html``. "Reports" is not a link at all.

Requiring explicit ``@root`` values in order to provide a link
hierarchy allows for a hierarchical menu to map on to a less or
differently organised underlying URL structure.

The simpler form of the above example menu, with everything in a nice
hierarchy, is::

    <root xmlns="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0">
      <menu href="" label="Texts" root="text">
        <item href="intro.html" label="Introduction" />
        <menu label="Reports" root="reports">
          <item href="1.html" label="Report #1" />
        </menu>
      </menu>
    </root>

Note that there is no requirement to pin any ``@href`` or ``@root`` to
a root URL (``/``). This will be handled automatically by the menu
processor. That includes, whether or not the references are root
relative or not, adjusting the URLs if Kiln is mounted at a URL other
than ``/``.

If a constructed URL is meant to reference the same server, but to a
path outside of Kiln's context, start the ``@href`` or ``@root`` with
"//".


Using kiln:url-for-match
------------------------

Rather than explicitly specifying URLs via the ``@root`` and ``@href``
attributes, the ``kiln:url-for-match`` function can be indirectly used
in a menu. Specify the id of the ``map:match`` used to process the URL
in a ``kiln:menu`` or ``kiln:item``\'s ``@match`` attribute, and if
any parameters are required they can be specified (whitespace
delimited) in the ``@params`` attribute. For example::

  <root xmlns="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0">
    <menu label="Texts" match="texts-home">
      <item match="texts-intro" label="Introduction" />
      <menu label="Reports">
        <item label="Report #1" match="texts-report" params="1" />
      </menu>
    </menu>
  </root>

This method is greatly preferable to using ``@href`` for links within
Kiln.


Marking the active item
-----------------------

The menu XML that is returned by ``cocoon://_internal/menu/**.xml``
can have a menu item matching a supplied URL marked as active. This is
useful for display a menu with the item that matches the current
position in the navigation structure highlighted.

To achieve this, supply a querystring to the Cocoon URL with a ``url``
parameter containing the URL to mark as active::

    <map:match pattern="*/text/**/*.html">
      <map:aggregate element="aggregation">
        <map:part label="tei" src="cocoon://internal/tei/preprocess/{2}.xml" />
        <map:part src="cocoon://_internal/menu/{1}/main.xml?url={1}/text/{2}/{3}.html" />
      </map:aggregate>
      ...
    </map:match>

The appropriate ``li`` element will be annotated with a class
attribute with the value "active".

The supplied URL should be root relative, but *without* the initial
"/", as in the example above.

Note that it does not matter what the URL of the request is; the menu
uses only the URL explicitly passed to it. This allows for the same
menu item to be marked as active for a multitude of URLs.


Translation and switching languages
-----------------------------------

To supply a key for looking up the translation of a menu item's label,
add an ``i18n:key`` attribute to the item; translated strings are
supplied as usual in ``assets/translations/messages_<language
code>.xml``.

Menu items, by default, link within the current language context. In
order to have menu items that switch language context (ie, to point to
a URL with a different language code as the first part of the path),
supply a ``language`` attribute to the menu item, whose value is the
language code the link should point to::

  <item label="Recherche" language="fr" match="local-search" />

To link to the same URL only with a different language, use the
``language_switch`` attribute to specify the new language code::

  <item label="English" language_switch="en" />

For linking to non-public URLs that do not have a language parameter
(such as admin URLs), supply an empty language attribute.

For menus that are used in no language context (such as the admin's
menu), the ``map:match`` should reference the menu pipeline that takes
no language code::

  <map:match pattern="admin/*.html">
    <map:aggregate element="aggregation">
      <map:part src="cocoon://_internal/menu/admin.xml?url=admin/{1}.html" />
    </map:aggregate>
    ...
  </map:match>
