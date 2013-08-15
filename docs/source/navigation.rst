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


Marking the active item
-----------------------

The menu XML that is returned by ``cocoon://_internal/menu/**.xml``
can have a menu item matching a supplied URL marked as active. This is
useful for display a menu with the item that matches the current
position in the navigation structure highlighted.

To achieve this, supply a querystring to the Cocoon URL with a ``url``
parameter containing the URL to mark as active::

    <map:match pattern="text/tei/**/*.html">
      <map:aggregate element="aggregation">
        <map:part label="tei" src="cocoon://internal/tei/preprocess/{1}.xml" />
        <map:part src="cocoon://_internal/menu/main.xml?url=text/{1}/{2}.html" />
      </map:aggregate>
      ...
    </map:match>

The appropriate ``li``
element will be annotated with a class attribute with the value
"active".

The supplied URL should be root relative, but *without* the initial
"/", as in the example above.

Note that it does not matter what the URL of the request is; the menu
uses only the URL explicitly passed to it. This allows for the same
menu item to be marked as active for a multitude of URLs.
